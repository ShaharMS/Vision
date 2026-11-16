#pragma once
#include <X11/Xatom.h>

namespace vision_vulkan {
class X11Window final : public WindowSystem {
    Display* display = nullptr;
    ::Window window = 0;
    Atom wmProtocols = 0, wmDelete = 0;

    void changeState(long action, const char* first, const char* second = nullptr) {
        XEvent event{};
        event.xclient.type = ClientMessage;
        event.xclient.window = window;
        event.xclient.message_type = XInternAtom(display, "_NET_WM_STATE", False);
        event.xclient.format = 32;
        event.xclient.data.l[0] = action;
        event.xclient.data.l[1] = XInternAtom(display, first, False);
        if (second) event.xclient.data.l[2] = XInternAtom(display, second, False);
        event.xclient.data.l[3] = 1;
        XSendEvent(display, DefaultRootWindow(display), False, SubstructureRedirectMask | SubstructureNotifyMask, &event);
    }

public:
    ~X11Window() override {
        if (window) XDestroyWindow(display, window);
        if (display) XCloseDisplay(display);
    }

    bool open(int x, int y, int width, int height, bool visible) override {
        display = XOpenDisplay(nullptr);
        if (!display) return false;
        window = XCreateSimpleWindow(display, DefaultRootWindow(display), x, y, width, height, 0, 0, 0);
        XStoreName(display, window, "Vision Vulkan");
        wmProtocols = XInternAtom(display, "WM_PROTOCOLS", False);
        wmDelete = XInternAtom(display, "WM_DELETE_WINDOW", False);
        XSetWMProtocols(display, window, &wmDelete, 1);
        XSelectInput(display, window, StructureNotifyMask | ExposureMask);
        if (visible) XMapRaised(display, window);
        XSync(display, False);
        mapped = visible;
        return true;
    }

    VkSurfaceKHR createSurface(VkInstance instance) override {
        VkXlibSurfaceCreateInfoKHR info{VK_STRUCTURE_TYPE_XLIB_SURFACE_CREATE_INFO_KHR};
        info.dpy = display;
        info.window = window;
        VkSurfaceKHR surface;
        return vkCreateXlibSurfaceKHR(instance, &info, nullptr, &surface) == VK_SUCCESS ? surface : VK_NULL_HANDLE;
    }

    VkExtent2D drawableSize() const override {
        XWindowAttributes attributes;
        if (!mapped || !XGetWindowAttributes(display, window, &attributes) || attributes.map_state != IsViewable)
            return {};
        return {uint32_t(attributes.width), uint32_t(attributes.height)};
    }

    bool poll() override {
        while (XPending(display)) {
            XEvent event;
            XNextEvent(display, &event);
            if (event.type == DestroyNotify) {
                closed = true;
                window = 0;
            } else if (event.type == ClientMessage && event.xclient.message_type == wmProtocols
                && event.xclient.data.l[0] == static_cast<long>(wmDelete)) {
                closed = true;
            } else if (event.type == MapNotify || event.type == UnmapNotify) {
                mapped = event.type == MapNotify;
                repaint = mapped;
            } else if (event.type == Expose || event.type == ConfigureNotify) {
                repaint = true;
            }
        }
        return !closed;
    }

    bool setBounds(int x, int y, int width, int height) override {
        if (!XMoveResizeWindow(display, window, x, y, width, height)) return false;
        XSync(display, False);
        return true;
    }

    bool setMode(int mode) override {
        if (mode == 1) {
            if (!XIconifyWindow(display, window, DefaultScreen(display))) return false;
            mapped = false;
        } else {
            XMapRaised(display, window);
            mapped = true;
            changeState(mode == 3 ? 1 : 0, "_NET_WM_STATE_FULLSCREEN");
            changeState(mode == 2 ? 1 : 0, "_NET_WM_STATE_MAXIMIZED_VERT", "_NET_WM_STATE_MAXIMIZED_HORZ");
        }
        XSync(display, False);
        return true;
    }

    void requestClose() override {
        XEvent event{};
        event.xclient.type = ClientMessage;
        event.xclient.window = window;
        event.xclient.message_type = wmProtocols;
        event.xclient.format = 32;
        event.xclient.data.l[0] = wmDelete;
        XSendEvent(display, window, False, 0, &event);
        XSync(display, False);
    }

    const char* name() const override { return "x11"; }
};
}
