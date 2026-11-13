#pragma once
#include "VulkanDevice.hpp"

#ifdef VISION_VULKAN_SCREEN
namespace vision_vulkan {
struct Window {
    SDL_Window* window = nullptr;
    VkSurfaceKHR surface = VK_NULL_HANDLE;
    VkSwapchainKHR swapchain = VK_NULL_HANDLE;
    VkSemaphore acquired = VK_NULL_HANDLE, rendered = VK_NULL_HANDLE;
    VkExtent2D extent{};
    bool bgra = false;
    std::atomic<bool> closed{false};

    static int watch(void* data, SDL_Event* event) {
        auto* window = static_cast<Window*>(data);
        if (event->type == SDL_WINDOWEVENT && event->window.event == SDL_WINDOWEVENT_CLOSE
            && event->window.windowID == SDL_GetWindowID(window->window)) window->closed = true;
        return 1;
    }
    std::vector<VkImage> images;
    std::vector<bool> presented;

    ~Window() {
        SDL_DelEventWatch(watch, this);
        auto& gpu = device();
        if (swapchain) vkDestroySwapchainKHR(gpu.logical, swapchain, nullptr);
        if (acquired) vkDestroySemaphore(gpu.logical, acquired, nullptr);
        if (rendered) vkDestroySemaphore(gpu.logical, rendered, nullptr);
        if (surface) vkDestroySurfaceKHR(gpu.instance, surface, nullptr);
        if (window) SDL_DestroyWindow(window);
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
        int w, h;
        SDL_Vulkan_GetDrawableSize(window, &w, &h);
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
    window->window = SDL_CreateWindow("Vision Vulkan", x, y, width, height,
        SDL_WINDOW_VULKAN | (visible ? SDL_WINDOW_SHOWN : SDL_WINDOW_HIDDEN));
    if (!window->window || !SDL_Vulkan_CreateSurface(window->window, gpu.instance, &window->surface)) return nullptr;
    VkBool32 supported = VK_FALSE;
    if (vkGetPhysicalDeviceSurfaceSupportKHR(gpu.physical, gpu.family, window->surface, &supported) != VK_SUCCESS || !supported)
        return nullptr;
    VkSemaphoreCreateInfo semaphore{VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO};
    if (vkCreateSemaphore(gpu.logical, &semaphore, nullptr, &window->acquired) != VK_SUCCESS ||
        vkCreateSemaphore(gpu.logical, &semaphore, nullptr, &window->rendered) != VK_SUCCESS ||
        !window->resize()) return nullptr;
    SDL_AddEventWatch(Window::watch, window.get());
    return window.release();
}

inline void closeWindow(Window* window) { delete window; }

inline bool pollWindow(Window* window) {
    SDL_PumpEvents();
    SDL_FlushEvent(SDL_WINDOWEVENT);
    return !window->closed && !SDL_HasEvent(SDL_QUIT);
}

inline bool setBounds(Window* window, int x, int y, int width, int height) {
    SDL_SetWindowPosition(window->window, x, y);
    SDL_SetWindowSize(window->window, width, height);
    return window->resize();
}

inline bool composite(Buffer* target, Buffer* source, int x, int y, bool invert) {
    return source != target && dispatch(source, target, target->width, target->height, 10, invert ? 1 : 0,
        0, 0, 0, 0, x, y, 0, 0, nullptr);
}

inline bool present(Window* window, Buffer* frame) {
    auto& gpu = device();
    if (!window || !frame || !window->swapchain) return false;
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
    return completed == VK_SUCCESS && (status == VK_SUCCESS || status == VK_SUBOPTIMAL_KHR);
}
}
#endif
