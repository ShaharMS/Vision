#pragma once
#include "VulkanDevice.hpp"

namespace vision_vulkan {
struct Window {
    Display* display = nullptr;
    ::Window window = 0;
    Atom wmProtocols = 0, wmDelete = 0;
    bool mapped = false, closed = false, repaint = false;
    VkSurfaceKHR surface = VK_NULL_HANDLE;
    VkSwapchainKHR swapchain = VK_NULL_HANDLE;
    VkSemaphore acquired = VK_NULL_HANDLE, rendered = VK_NULL_HANDLE;
    VkExtent2D extent{};
    bool bgra = false;
    std::vector<VkImage> images;
    std::vector<bool> presented;

    ~Window() {
        auto& gpu = device();
        if (swapchain) vkDestroySwapchainKHR(gpu.logical, swapchain, nullptr);
        if (acquired) vkDestroySemaphore(gpu.logical, acquired, nullptr);
        if (rendered) vkDestroySemaphore(gpu.logical, rendered, nullptr);
        if (surface) vkDestroySurfaceKHR(gpu.instance, surface, nullptr);
        if (window) XDestroyWindow(display, window);
        if (display) XCloseDisplay(display);
    }

    bool resize() {
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
        XWindowAttributes attributes;
        if (!XGetWindowAttributes(display, window, &attributes)) return false;
        const int w = attributes.width, h = attributes.height;
        if (w <= 0 || h <= 0) return false;
        auto size = caps.currentExtent;
        if (size.width == UINT32_MAX) {
            size.width = std::max(caps.minImageExtent.width, std::min(uint32_t(w), caps.maxImageExtent.width));
            size.height = std::max(caps.minImageExtent.height, std::min(uint32_t(h), caps.maxImageExtent.height));
        }
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
        info.presentMode = VK_PRESENT_MODE_FIFO_KHR;
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
        presented.assign(count, false);
        return count != 0;
    }
};

inline Window* openWindow(int x, int y, int width, int height, bool visible) {
    auto& gpu = device();
    if (!available() || !gpu.presentation) return nullptr;
    std::unique_ptr<Window> window(new Window());
    window->display = XOpenDisplay(nullptr);
    if (!window->display) return nullptr;
    auto display = window->display;
    window->window = XCreateSimpleWindow(display, DefaultRootWindow(display), x, y, width, height, 0, 0, 0);
    XStoreName(display, window->window, "Vision Vulkan");
    window->wmProtocols = XInternAtom(display, "WM_PROTOCOLS", False);
    window->wmDelete = XInternAtom(display, "WM_DELETE_WINDOW", False);
    XSetWMProtocols(display, window->window, &window->wmDelete, 1);
    XSelectInput(display, window->window, StructureNotifyMask | ExposureMask);
    if (visible) XMapRaised(display, window->window);
    XSync(display, False);
    window->mapped = visible;
    VkXlibSurfaceCreateInfoKHR surfaceInfo{VK_STRUCTURE_TYPE_XLIB_SURFACE_CREATE_INFO_KHR};
    surfaceInfo.dpy = display;
    surfaceInfo.window = window->window;
    if (vkCreateXlibSurfaceKHR(gpu.instance, &surfaceInfo, nullptr, &window->surface) != VK_SUCCESS) return nullptr;
    VkBool32 supported = VK_FALSE;
    if (vkGetPhysicalDeviceSurfaceSupportKHR(gpu.physical, gpu.family, window->surface, &supported) != VK_SUCCESS || !supported)
        return nullptr;
    VkSemaphoreCreateInfo semaphore{VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO};
    if (vkCreateSemaphore(gpu.logical, &semaphore, nullptr, &window->acquired) != VK_SUCCESS ||
        vkCreateSemaphore(gpu.logical, &semaphore, nullptr, &window->rendered) != VK_SUCCESS ||
        !window->resize()) return nullptr;
    return window.release();
}

inline void closeWindow(Window* window) { delete window; }

inline void requestClose(Window* window) {
    XEvent event{};
    event.xclient.type = ClientMessage;
    event.xclient.window = window->window;
    event.xclient.message_type = window->wmProtocols;
    event.xclient.format = 32;
    event.xclient.data.l[0] = window->wmDelete;
    XSendEvent(window->display, window->window, False, 0, &event);
    XSync(window->display, False);
}

inline bool pollWindow(Window* window) {
    while (XPending(window->display)) {
        XEvent event;
        XNextEvent(window->display, &event);
        if (event.type == DestroyNotify) {
            window->closed = true;
            window->window = 0;
        } else if (event.type == ClientMessage && event.xclient.message_type == window->wmProtocols
            && event.xclient.data.l[0] == static_cast<long>(window->wmDelete)) {
            window->closed = true;
        } else if (event.type == MapNotify || event.type == UnmapNotify) {
            window->mapped = event.type == MapNotify;
            window->repaint = window->mapped;
        } else if (event.type == Expose || event.type == ConfigureNotify) {
            window->repaint = true;
        }
    }
    return !window->closed;
}

inline bool needsRepaint(Window* window) {
    const bool repaint = window->repaint;
    window->repaint = false;
    return repaint && window->mapped;
}

inline bool setBounds(Window* window, int x, int y, int width, int height) {
    if (!XMoveResizeWindow(window->display, window->window, x, y, width, height)) return false;
    XSync(window->display, False);
    return true;
}

inline void changeState(Window* window, long action, const char* first, const char* second = nullptr) {
    XEvent event{};
    event.xclient.type = ClientMessage;
    event.xclient.window = window->window;
    event.xclient.message_type = XInternAtom(window->display, "_NET_WM_STATE", False);
    event.xclient.format = 32;
    event.xclient.data.l[0] = action;
    event.xclient.data.l[1] = XInternAtom(window->display, first, False);
    if (second) event.xclient.data.l[2] = XInternAtom(window->display, second, False);
    event.xclient.data.l[3] = 1;
    XSendEvent(window->display, DefaultRootWindow(window->display), False,
        SubstructureRedirectMask | SubstructureNotifyMask, &event);
}

inline bool setWindowMode(Window* window, int mode) {
    if (!window || window->closed) return false;
    if (mode == 1) {
        if (!XIconifyWindow(window->display, window->window, DefaultScreen(window->display))) return false;
        window->mapped = false;
    } else {
        XMapRaised(window->display, window->window);
        window->mapped = true;
        changeState(window, mode == 3 ? 1 : 0, "_NET_WM_STATE_FULLSCREEN");
        changeState(window, mode == 2 ? 1 : 0, "_NET_WM_STATE_MAXIMIZED_VERT", "_NET_WM_STATE_MAXIMIZED_HORZ");
    }
    XSync(window->display, False);
    return true;
}

inline bool present(Window* window, Buffer* frame) {
    auto& gpu = device();
    if (!window || !frame || !window->swapchain) return false;
    if (!window->mapped) return true;
    XWindowAttributes attributes;
    if (!XGetWindowAttributes(window->display, window->window, &attributes)) return false;
    if (attributes.map_state != IsViewable) return true;
    if ((uint32_t(attributes.width) != window->extent.width || uint32_t(attributes.height) != window->extent.height)
        && !window->resize()) return false;
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
        window->repaint = true;
        return window->resize();
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
    submit.pSignalSemaphores = &window->rendered;
    submit.pCommandBuffers = &command;
    if (vkQueueSubmit(gpu.queue, 1, &submit, VK_NULL_HANDLE) != VK_SUCCESS) return false;
    VkPresentInfoKHR present{VK_STRUCTURE_TYPE_PRESENT_INFO_KHR};
    present.waitSemaphoreCount = present.swapchainCount = 1;
    present.pWaitSemaphores = &window->rendered;
    present.pSwapchains = &window->swapchain;
    present.pImageIndices = &index;
    status = vkQueuePresentKHR(gpu.queue, &present);
    auto completed = vkQueueWaitIdle(gpu.queue);
    window->presented[index] = true;
    if (completed != VK_SUCCESS) return false;
    if (status == VK_ERROR_OUT_OF_DATE_KHR || status == VK_SUBOPTIMAL_KHR) {
        window->repaint = true;
        return window->resize();
    }
    return status == VK_SUCCESS;
}
}
