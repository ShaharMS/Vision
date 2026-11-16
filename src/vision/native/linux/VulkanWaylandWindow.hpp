#pragma once
#include <wayland-client.h>
#include "xdg-shell-client.h"
#include "xdg-decoration-client.h"
#include <cerrno>
#include <poll.h>

namespace vision_vulkan {
class WaylandWindow final : public WindowSystem {
    wl_display* display = nullptr;
    wl_compositor* compositor = nullptr;
    xdg_wm_base* shell = nullptr;
    zxdg_decoration_manager_v1* decorations = nullptr;
    wl_surface* surface = nullptr;
    xdg_surface* shellSurface = nullptr;
    xdg_toplevel* toplevel = nullptr;
    zxdg_toplevel_decoration_v1* decoration = nullptr;
    VkExtent2D requested{}, configured{}, pending{}, geometry{};
    bool configuredState = false, pendingState = false, minimized = false;

    static void global(void* data, wl_registry* registry, uint32_t name, const char* interface, uint32_t) {
        auto& window = *static_cast<WaylandWindow*>(data);
        if (std::strcmp(interface, wl_compositor_interface.name) == 0)
            window.compositor = static_cast<wl_compositor*>(wl_registry_bind(registry, name, &wl_compositor_interface, 1));
        else if (std::strcmp(interface, xdg_wm_base_interface.name) == 0)
            window.shell = static_cast<xdg_wm_base*>(wl_registry_bind(registry, name, &xdg_wm_base_interface, 1));
        else if (std::strcmp(interface, zxdg_decoration_manager_v1_interface.name) == 0)
            window.decorations = static_cast<zxdg_decoration_manager_v1*>(
                wl_registry_bind(registry, name, &zxdg_decoration_manager_v1_interface, 1));
    }

    static void configureToplevel(void* data, xdg_toplevel*, int32_t width, int32_t height, wl_array* states) {
        auto& window = *static_cast<WaylandWindow*>(data);
        window.pending = {uint32_t(std::max(0, width)), uint32_t(std::max(0, height))};
        window.pendingState = false;
        auto state = static_cast<const uint32_t*>(states->data);
        for (size_t i = 0; i < states->size / sizeof(uint32_t); ++i)
            if (state[i] == XDG_TOPLEVEL_STATE_MAXIMIZED || state[i] == XDG_TOPLEVEL_STATE_FULLSCREEN)
                window.pendingState = true;
    }

    static void configureSurface(void* data, xdg_surface* shellSurface, uint32_t serial) {
        auto& window = *static_cast<WaylandWindow*>(data);
        xdg_surface_ack_configure(shellSurface, serial);
        window.configured = window.pending;
        window.configuredState = window.pendingState;
        window.mapped = !window.minimized;
        window.repaint = true;
    }

    static void closeToplevel(void* data, xdg_toplevel*) {
        static_cast<WaylandWindow*>(data)->closed = true;
    }

    void destroyToplevel() {
        if (decoration) zxdg_toplevel_decoration_v1_destroy(decoration);
        if (toplevel) xdg_toplevel_destroy(toplevel);
        if (shellSurface) xdg_surface_destroy(shellSurface);
        if (surface) wl_surface_destroy(surface);
        decoration = nullptr;
        toplevel = nullptr;
        shellSurface = nullptr;
        surface = nullptr;
        mapped = false;
        configured = pending = geometry = {};
        configuredState = pendingState = false;
    }

    bool map(int mode) {
        surface = wl_compositor_create_surface(compositor);
        if (!surface) return false;
        shellSurface = xdg_wm_base_get_xdg_surface(shell, surface);
        if (!shellSurface) return false;
        toplevel = xdg_surface_get_toplevel(shellSurface);
        if (!toplevel) return false;
        static const xdg_surface_listener surfaceEvents = {configureSurface};
        static const xdg_toplevel_listener toplevelEvents = {configureToplevel, closeToplevel};
        xdg_surface_add_listener(shellSurface, &surfaceEvents, this);
        xdg_toplevel_add_listener(toplevel, &toplevelEvents, this);
        xdg_toplevel_set_title(toplevel, "Vision Vulkan");
        xdg_toplevel_set_app_id(toplevel, "vision");
        if (decorations) {
            decoration = zxdg_decoration_manager_v1_get_toplevel_decoration(decorations, toplevel);
            if (decoration) {
                static const zxdg_toplevel_decoration_v1_listener events = {
                    [](void*, zxdg_toplevel_decoration_v1*, uint32_t) {}
                };
                zxdg_toplevel_decoration_v1_add_listener(decoration, &events, this);
                zxdg_toplevel_decoration_v1_set_mode(decoration, ZXDG_TOPLEVEL_DECORATION_V1_MODE_SERVER_SIDE);
            }
        }
        applyMode(mode);
        wl_surface_commit(surface);
        while (!mapped && !closed)
            if (wl_display_dispatch(display) < 0) return false;
        return mapped && !closed;
    }

    void applyMode(int mode) {
        if (mode == 3) {
            xdg_toplevel_unset_maximized(toplevel);
            xdg_toplevel_set_fullscreen(toplevel, nullptr);
        } else {
            xdg_toplevel_unset_fullscreen(toplevel);
            if (mode == 2) xdg_toplevel_set_maximized(toplevel);
            else xdg_toplevel_unset_maximized(toplevel);
        }
    }

public:
    ~WaylandWindow() override {
        destroyToplevel();
        if (decorations) zxdg_decoration_manager_v1_destroy(decorations);
        if (shell) xdg_wm_base_destroy(shell);
        if (compositor) wl_compositor_destroy(compositor);
        if (display) wl_display_disconnect(display);
    }

    bool open(int, int, int width, int height, bool visible) override {
        requested = {uint32_t(width), uint32_t(height)};
        display = wl_display_connect(nullptr);
        if (!display) return false;
        auto registry = wl_display_get_registry(display);
        if (!registry) return false;
        static const wl_registry_listener globals = {global, [](void*, wl_registry*, uint32_t) {}};
        wl_registry_add_listener(registry, &globals, this);
        const auto status = wl_display_roundtrip(display);
        wl_registry_destroy(registry);
        if (status < 0 || !compositor || !shell) return false;
        static const xdg_wm_base_listener shellEvents = {
            [](void*, xdg_wm_base* shell, uint32_t serial) { xdg_wm_base_pong(shell, serial); }
        };
        xdg_wm_base_add_listener(shell, &shellEvents, this);
        return !visible || map(0);
    }

    VkSurfaceKHR createSurface(VkInstance instance) override {
        VkWaylandSurfaceCreateInfoKHR info{VK_STRUCTURE_TYPE_WAYLAND_SURFACE_CREATE_INFO_KHR};
        info.display = display;
        info.surface = surface;
        VkSurfaceKHR result;
        return vkCreateWaylandSurfaceKHR(instance, &info, nullptr, &result) == VK_SUCCESS ? result : VK_NULL_HANDLE;
    }

    VkExtent2D drawableSize() const override {
        if (!mapped) return {};
        return {configured.width ? configured.width : requested.width, configured.height ? configured.height : requested.height};
    }

    void preparePresent(VkExtent2D extent) override {
        if (geometry.width == extent.width && geometry.height == extent.height) return;
        xdg_surface_set_window_geometry(shellSurface, 0, 0, extent.width, extent.height);
        geometry = extent;
    }

    bool poll() override {
        if (closed) return false;
        while (wl_display_prepare_read(display) != 0)
            if (wl_display_dispatch_pending(display) < 0) return false;
        const int flushed = wl_display_flush(display);
        if (flushed < 0 && errno != EAGAIN) {
            wl_display_cancel_read(display);
            return false;
        }
        pollfd fd{wl_display_get_fd(display), POLLIN, 0};
        const int ready = ::poll(&fd, 1, 0);
        if (ready > 0 && (fd.revents & POLLIN)) {
            if (wl_display_read_events(display) < 0) return false;
        } else {
            wl_display_cancel_read(display);
            if ((ready < 0 && errno != EINTR) || (fd.revents & (POLLERR | POLLHUP | POLLNVAL))) return false;
        }
        return wl_display_dispatch_pending(display) >= 0 && !closed;
    }

    bool setBounds(int, int, int width, int height) override {
        requested = {uint32_t(width), uint32_t(height)};
        if (!configuredState) configured = {};
        repaint = mapped;
        return true;
    }

    bool needsRemap() const override { return minimized; }

    bool setMode(int mode) override {
        if (mode == 1) {
            if (toplevel) xdg_toplevel_set_minimized(toplevel);
            minimized = true;
            mapped = false;
        } else {
            if (minimized) {
                destroyToplevel();
                minimized = false;
            }
            if (!toplevel) return map(mode);
            applyMode(mode);
        }
        return wl_display_flush(display) >= 0 || errno == EAGAIN;
    }

    void requestClose() override { closeToplevel(this, toplevel); }

    VkPresentModeKHR preferredPresentMode() const override { return VK_PRESENT_MODE_MAILBOX_KHR; }
    const char* name() const override { return "wayland"; }
};
}
