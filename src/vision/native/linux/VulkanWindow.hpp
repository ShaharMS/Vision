#pragma once
#include "VulkanDevice.hpp"

namespace vision_vulkan {
struct WindowSystem {
    bool mapped = false, closed = false, repaint = false;

    virtual ~WindowSystem() = default;
    virtual bool open(int x, int y, int width, int height, bool visible) = 0;
    virtual VkSurfaceKHR createSurface(VkInstance instance) = 0;
    virtual VkExtent2D drawableSize() const = 0;
    virtual bool poll() = 0;
    virtual bool setBounds(int x, int y, int width, int height) = 0;
    virtual bool setMode(int mode) = 0;
    virtual void requestClose() = 0;
    virtual const char* name() const = 0;
    virtual bool needsRemap() const { return false; }
    virtual void preparePresent(VkExtent2D) {}
    virtual VkPresentModeKHR preferredPresentMode() const { return VK_PRESENT_MODE_FIFO_KHR; }
};
}

#ifdef VISION_VULKAN_X11
#include "VulkanX11Window.hpp"
#endif
#ifdef VISION_VULKAN_WAYLAND
#include "VulkanWaylandWindow.hpp"
#endif

namespace vision_vulkan {
struct Window {
    std::unique_ptr<WindowSystem> platform;
    VkSurfaceKHR surface = VK_NULL_HANDLE;
    VkSwapchainKHR swapchain = VK_NULL_HANDLE;
    VkSemaphore acquired = VK_NULL_HANDLE;
    VkExtent2D extent{};
    bool bgra = false;
    VkPresentModeKHR presentMode = VK_PRESENT_MODE_FIFO_KHR;
    std::vector<VkImage> images;
    std::vector<VkSemaphore> rendered;
    std::vector<bool> presented;

    ~Window() {
        resetSurface();
        if (acquired) vkDestroySemaphore(device().logical, acquired, nullptr);
    }

    void resetSurface() {
        auto& gpu = device();
        for (auto signal : rendered) if (signal) vkDestroySemaphore(gpu.logical, signal, nullptr);
        rendered.clear();
        if (swapchain) vkDestroySwapchainKHR(gpu.logical, swapchain, nullptr);
        if (surface) vkDestroySurfaceKHR(gpu.instance, surface, nullptr);
        swapchain = VK_NULL_HANDLE;
        surface = VK_NULL_HANDLE;
        extent = {};
    }

    bool startSurface() {
        auto& gpu = device();
        surface = platform->createSurface(gpu.instance);
        if (!surface) return false;
        VkBool32 supported = VK_FALSE;
        if (vkGetPhysicalDeviceSurfaceSupportKHR(gpu.physical, gpu.family, surface, &supported) != VK_SUCCESS || !supported) {
            resetSurface();
            return false;
        }

        const auto preferred = platform->preferredPresentMode();
        uint32_t count = 0;
        if (vkGetPhysicalDeviceSurfacePresentModesKHR(gpu.physical, surface, &count, nullptr) == VK_SUCCESS && count) {
            std::vector<VkPresentModeKHR> modes(count);
            if (vkGetPhysicalDeviceSurfacePresentModesKHR(gpu.physical, surface, &count, modes.data()) == VK_SUCCESS
                && std::find(modes.begin(), modes.end(), preferred) != modes.end()) presentMode = preferred;
        }
        return true;
    }

    bool resize(VkExtent2D drawable) {
        auto& gpu = device();
        VkSurfaceCapabilitiesKHR caps;
        if (vkGetPhysicalDeviceSurfaceCapabilitiesKHR(gpu.physical, surface, &caps) != VK_SUCCESS
            || !(caps.supportedUsageFlags & VK_IMAGE_USAGE_TRANSFER_DST_BIT)) return false;
        uint32_t count = 0;
        vkGetPhysicalDeviceSurfaceFormatsKHR(gpu.physical, surface, &count, nullptr);
        std::vector<VkSurfaceFormatKHR> formats(count);
        vkGetPhysicalDeviceSurfaceFormatsKHR(gpu.physical, surface, &count, formats.data());
        auto format = std::find_if(formats.begin(), formats.end(), [](const VkSurfaceFormatKHR& f) {
            return f.format == VK_FORMAT_B8G8R8A8_UNORM || f.format == VK_FORMAT_R8G8B8A8_UNORM;
        });
        if (format == formats.end()) return false;
        auto size = caps.currentExtent;
        if (size.width == UINT32_MAX) {
            size.width = std::max(caps.minImageExtent.width, std::min(drawable.width, caps.maxImageExtent.width));
            size.height = std::max(caps.minImageExtent.height, std::min(drawable.height, caps.maxImageExtent.height));
        }
        if (!size.width || !size.height) return false;
        VkSwapchainCreateInfoKHR info{VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR};
        info.surface = surface;
        info.minImageCount = caps.maxImageCount ? std::min(caps.minImageCount + 1, caps.maxImageCount) : caps.minImageCount + 1;
        info.imageFormat = format->format;
        info.imageColorSpace = format->colorSpace;
        info.imageExtent = size;
        info.imageArrayLayers = 1;
        info.imageUsage = VK_IMAGE_USAGE_TRANSFER_DST_BIT;
        info.imageSharingMode = VK_SHARING_MODE_EXCLUSIVE;
        info.preTransform = caps.currentTransform;
        info.compositeAlpha = static_cast<VkCompositeAlphaFlagBitsKHR>(caps.supportedCompositeAlpha & -caps.supportedCompositeAlpha);
        info.presentMode = presentMode;
        info.clipped = VK_TRUE;
        info.oldSwapchain = swapchain;
        VkSwapchainKHR next;
        if (vkCreateSwapchainKHR(gpu.logical, &info, nullptr, &next) != VK_SUCCESS) return false;
        if (swapchain) vkDestroySwapchainKHR(gpu.logical, swapchain, nullptr);
        swapchain = next;
        extent = size;
        bgra = format->format == VK_FORMAT_B8G8R8A8_UNORM;
        vkGetSwapchainImagesKHR(gpu.logical, swapchain, &count, nullptr);
        images.resize(count);
        if (vkGetSwapchainImagesKHR(gpu.logical, swapchain, &count, images.data()) != VK_SUCCESS) return false;
        for (auto signal : rendered) if (signal) vkDestroySemaphore(gpu.logical, signal, nullptr);
        rendered.assign(count, VK_NULL_HANDLE);
        VkSemaphoreCreateInfo semaphore{VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO};
        for (auto& signal : rendered)
            if (vkCreateSemaphore(gpu.logical, &semaphore, nullptr, &signal) != VK_SUCCESS) return false;
        presented.assign(count, false);
        return count != 0;
    }
};

inline Window* openWindow(int x, int y, int width, int height, bool visible) {
    auto& gpu = device();
    if (!available() || !gpu.presentation) return nullptr;
    std::unique_ptr<Window> window(new Window());
#ifdef VISION_VULKAN_WAYLAND
    const auto session = std::getenv("XDG_SESSION_TYPE");
    const auto display = std::getenv("WAYLAND_DISPLAY");
    const auto socket = std::getenv("WAYLAND_SOCKET");
    if ((session && std::strcmp(session, "wayland") == 0)
        || ((!session || std::strcmp(session, "x11") != 0) && ((display && *display) || (socket && *socket)))) {
        if (!gpu.wayland) return nullptr;
        window->platform.reset(new WaylandWindow());
    }
#endif
#ifdef VISION_VULKAN_X11
    if (!window->platform && gpu.x11) window->platform.reset(new X11Window());
#endif
    if (!window->platform || !window->platform->open(x, y, width, height, visible)) return nullptr;
    VkSemaphoreCreateInfo semaphore{VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO};
    if (vkCreateSemaphore(gpu.logical, &semaphore, nullptr, &window->acquired) != VK_SUCCESS) return nullptr;
    return window.release();
}

inline void closeWindow(Window* window) { delete window; }
inline void requestClose(Window* window) { window->platform->requestClose(); }
inline bool pollWindow(Window* window) { return window->platform->poll(); }
inline const char* windowSystem(Window* window) { return window->platform->name(); }
inline bool swapchainSizeMatches(Window* window, int width, int height) {
    return window->swapchain && window->extent.width == uint32_t(width) && window->extent.height == uint32_t(height);
}

inline bool needsRepaint(Window* window) {
    const bool repaint = window->platform->repaint;
    window->platform->repaint = false;
    return repaint && window->platform->mapped;
}

inline bool setBounds(Window* window, int x, int y, int width, int height) {
    return !window->platform->closed && window->platform->setBounds(x, y, width, height);
}

inline bool setWindowMode(Window* window, int mode) {
    if (window->platform->closed) return false;
    if (mode != 1 && window->platform->needsRemap()) window->resetSurface();
    return window->platform->setMode(mode);
}

inline bool present(Window* window, Buffer* frame) {
    auto& gpu = device();
    if (!window || !frame || window->platform->closed) return false;
    const auto drawable = window->platform->drawableSize();
    if (!drawable.width || !drawable.height) return true;
    if (!window->surface && !window->startSurface()) return false;
    if ((!window->swapchain || drawable.width != window->extent.width || drawable.height != window->extent.height)
        && !window->resize(drawable)) return false;
    auto width = window->extent.width, height = window->extent.height;
    std::unique_ptr<Buffer> rgb(filter(frame, width, height, 9, window->bgra ? 1 : 0, 0, 0, 0, 0, 0, 0, 0, 0, nullptr));
    if (!rgb) return false;

    std::lock_guard<std::mutex> lock(gpu.mutex);
    VkCommandBufferAllocateInfo allocation{VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO};
    allocation.commandPool = gpu.commands;
    allocation.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
    allocation.commandBufferCount = 1;
    VkCommandBuffer command;
    if (vkAllocateCommandBuffers(gpu.logical, &allocation, &command) != VK_SUCCESS) return false;
    struct CommandCleanup {
        Device& gpu;
        VkCommandBuffer command;
        ~CommandCleanup() { vkFreeCommandBuffers(gpu.logical, gpu.commands, 1, &command); }
    } cleanup{gpu, command};
    VkCommandBufferBeginInfo begin{VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO};
    begin.flags = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;
    if (vkBeginCommandBuffer(command, &begin) != VK_SUCCESS) return false;
    uint32_t index;
    auto status = vkAcquireNextImageKHR(gpu.logical, window->swapchain, UINT64_MAX, window->acquired, VK_NULL_HANDLE, &index);
    if (status == VK_ERROR_OUT_OF_DATE_KHR) {
        window->platform->repaint = true;
        return window->resize(drawable);
    }
    if (status != VK_SUCCESS && status != VK_SUBOPTIMAL_KHR) return false;
    VkMemoryBarrier memory{VK_STRUCTURE_TYPE_MEMORY_BARRIER};
    memory.srcAccessMask = VK_ACCESS_SHADER_WRITE_BIT;
    memory.dstAccessMask = VK_ACCESS_TRANSFER_READ_BIT;
    VkImageMemoryBarrier transition{VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER};
    transition.dstAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
    transition.oldLayout = window->presented[index] ? VK_IMAGE_LAYOUT_PRESENT_SRC_KHR : VK_IMAGE_LAYOUT_UNDEFINED;
    transition.newLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
    transition.srcQueueFamilyIndex = transition.dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
    transition.image = window->images[index];
    transition.subresourceRange = {VK_IMAGE_ASPECT_COLOR_BIT, 0, 1, 0, 1};
    vkCmdPipelineBarrier(command, VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT, VK_PIPELINE_STAGE_TRANSFER_BIT, 0,
        1, &memory, 0, nullptr, 1, &transition);
    VkBufferImageCopy copy{};
    copy.imageSubresource = {VK_IMAGE_ASPECT_COLOR_BIT, 0, 0, 1};
    copy.imageExtent = {width, height, 1};
    vkCmdCopyBufferToImage(command, rgb->handle, transition.image, VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, 1, &copy);
    transition.srcAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
    transition.dstAccessMask = 0;
    transition.oldLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
    transition.newLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;
    vkCmdPipelineBarrier(command, VK_PIPELINE_STAGE_TRANSFER_BIT, VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT, 0,
        0, nullptr, 0, nullptr, 1, &transition);
    if (vkEndCommandBuffer(command) != VK_SUCCESS) return false;
    VkPipelineStageFlags waitStage = VK_PIPELINE_STAGE_TRANSFER_BIT;
    VkSubmitInfo submit{VK_STRUCTURE_TYPE_SUBMIT_INFO};
    submit.waitSemaphoreCount = submit.signalSemaphoreCount = submit.commandBufferCount = 1;
    submit.pWaitSemaphores = &window->acquired;
    submit.pWaitDstStageMask = &waitStage;
    submit.pSignalSemaphores = &window->rendered[index];
    submit.pCommandBuffers = &command;
    if (vkQueueSubmit(gpu.queue, 1, &submit, VK_NULL_HANDLE) != VK_SUCCESS) return false;
    VkPresentInfoKHR present{VK_STRUCTURE_TYPE_PRESENT_INFO_KHR};
    present.waitSemaphoreCount = present.swapchainCount = 1;
    present.pWaitSemaphores = &window->rendered[index];
    present.pSwapchains = &window->swapchain;
    present.pImageIndices = &index;
    window->platform->preparePresent(window->extent);
    status = vkQueuePresentKHR(gpu.queue, &present);
    auto completed = vkQueueWaitIdle(gpu.queue);
    window->presented[index] = true;
    if (completed != VK_SUCCESS) return false;
    if (status == VK_ERROR_OUT_OF_DATE_KHR || status == VK_SUBOPTIMAL_KHR) {
        window->platform->repaint = true;
        return window->resize(drawable);
    }
    return status == VK_SUCCESS;
}
}
