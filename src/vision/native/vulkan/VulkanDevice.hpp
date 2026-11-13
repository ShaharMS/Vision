#pragma once
#include <vulkan/vulkan.h>
#include <algorithm>
#include <atomic>
#include <cstring>
#include <cstdlib>
#include <memory>
#include <mutex>
#include <vector>
#include "VulkanShader.hpp"
#ifdef VISION_VULKAN_SCREEN
#include <SDL2/SDL.h>
#include <SDL2/SDL_vulkan.h>
#endif

namespace vision_vulkan {
struct Device {
    VkInstance instance = VK_NULL_HANDLE;
    VkDevice logical = VK_NULL_HANDLE;
    VkPhysicalDevice physical = VK_NULL_HANDLE;
    uint32_t family = 0;
    bool presentation = false;
    VkQueue queue = VK_NULL_HANDLE;
    VkDescriptorSetLayout layout = VK_NULL_HANDLE;
    VkPipelineLayout pipelineLayout = VK_NULL_HANDLE;
    VkPipeline pipeline = VK_NULL_HANDLE;
    VkCommandPool commands = VK_NULL_HANDLE;
    VkDescriptorPool descriptors = VK_NULL_HANDLE;
    VkPhysicalDeviceMemoryProperties memory{};
    VkPhysicalDeviceProperties properties{};
    std::mutex mutex;
    std::atomic<int> readbacks{0};

    Device() {
        VkApplicationInfo app{VK_STRUCTURE_TYPE_APPLICATION_INFO};
        app.apiVersion = VK_API_VERSION_1_0;
        VkInstanceCreateInfo info{VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO};
        info.pApplicationInfo = &app;
#ifdef VISION_VULKAN_SCREEN
        std::vector<const char*> extensions;
        if (SDL_InitSubSystem(SDL_INIT_VIDEO) == 0) {
            auto probe = SDL_CreateWindow("Vision Vulkan", 0, 0, 1, 1, SDL_WINDOW_VULKAN | SDL_WINDOW_HIDDEN);
            if (probe) {
                unsigned count = 0;
                if (SDL_Vulkan_GetInstanceExtensions(probe, &count, nullptr)) {
                    extensions.resize(count);
                    if (SDL_Vulkan_GetInstanceExtensions(probe, &count, extensions.data())) {
                        info.enabledExtensionCount = count;
                        info.ppEnabledExtensionNames = extensions.data();
                        presentation = true;
                    }
                }
                SDL_DestroyWindow(probe);
            }
        }
#endif
        if (vkCreateInstance(&info, nullptr, &instance) != VK_SUCCESS) return;
        uint32_t count = 0;
        if (vkEnumeratePhysicalDevices(instance, &count, nullptr) != VK_SUCCESS || !count) return;
        std::vector<VkPhysicalDevice> devices(count);
        if (vkEnumeratePhysicalDevices(instance, &count, devices.data()) != VK_SUCCESS) return;
        for (auto candidate : devices) {
            VkPhysicalDeviceProperties candidateProperties;
            vkGetPhysicalDeviceProperties(candidate, &candidateProperties);
            if (candidateProperties.deviceType == VK_PHYSICAL_DEVICE_TYPE_CPU && !std::getenv("VISION_VULKAN_ALLOW_SOFTWARE")) continue;
            uint32_t families = 0;
            vkGetPhysicalDeviceQueueFamilyProperties(candidate, &families, nullptr);
            std::vector<VkQueueFamilyProperties> queues(families);
            vkGetPhysicalDeviceQueueFamilyProperties(candidate, &families, queues.data());
            for (uint32_t i = 0; i < families; ++i)
                if (queues[i].queueCount && (queues[i].queueFlags & VK_QUEUE_COMPUTE_BIT)) {
                    physical = candidate;
                    family = i;
                    properties = candidateProperties;
                    break;
                }
            if (physical) break;
        }
        if (!physical) return;
        vkGetPhysicalDeviceMemoryProperties(physical, &memory);
        const float priority = 1;
        VkDeviceQueueCreateInfo queueInfo{VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO};
        queueInfo.queueFamilyIndex = family;
        queueInfo.queueCount = 1;
        queueInfo.pQueuePriorities = &priority;
        VkDeviceCreateInfo deviceInfo{VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO};
        deviceInfo.queueCreateInfoCount = 1;
        deviceInfo.pQueueCreateInfos = &queueInfo;
        const char* swapchain = VK_KHR_SWAPCHAIN_EXTENSION_NAME;
        if (presentation) {
            uint32_t count = 0;
            vkEnumerateDeviceExtensionProperties(physical, nullptr, &count, nullptr);
            std::vector<VkExtensionProperties> extensions(count);
            vkEnumerateDeviceExtensionProperties(physical, nullptr, &count, extensions.data());
            presentation = std::any_of(extensions.begin(), extensions.end(), [swapchain](const VkExtensionProperties& property) {
                return std::strcmp(property.extensionName, swapchain) == 0;
            });
            if (presentation) {
                deviceInfo.enabledExtensionCount = 1;
                deviceInfo.ppEnabledExtensionNames = &swapchain;
            }
        }
        if (vkCreateDevice(physical, &deviceInfo, nullptr, &logical) != VK_SUCCESS) return;
        vkGetDeviceQueue(logical, family, 0, &queue);
        VkDescriptorSetLayoutBinding bindings[3]{};
        for (uint32_t i = 0; i < 3; ++i)
            bindings[i] = {i, VK_DESCRIPTOR_TYPE_STORAGE_BUFFER, 1, VK_SHADER_STAGE_COMPUTE_BIT, nullptr};
        VkDescriptorSetLayoutCreateInfo layoutInfo{VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO};
        layoutInfo.bindingCount = 3;
        layoutInfo.pBindings = bindings;
        if (vkCreateDescriptorSetLayout(logical, &layoutInfo, nullptr, &layout) != VK_SUCCESS) return;
        VkPipelineLayoutCreateInfo pipelineInfo{VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO};
        pipelineInfo.setLayoutCount = 1;
        pipelineInfo.pSetLayouts = &layout;
        if (vkCreatePipelineLayout(logical, &pipelineInfo, nullptr, &pipelineLayout) != VK_SUCCESS) return;
        VkShaderModuleCreateInfo shaderInfo{VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO};
        shaderInfo.codeSize = sizeof(visionVulkanShader);
        shaderInfo.pCode = visionVulkanShader;
        VkShaderModule shader;
        if (vkCreateShaderModule(logical, &shaderInfo, nullptr, &shader) != VK_SUCCESS) return;
        VkComputePipelineCreateInfo compute{VK_STRUCTURE_TYPE_COMPUTE_PIPELINE_CREATE_INFO};
        compute.stage = {VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO};
        compute.stage.stage = VK_SHADER_STAGE_COMPUTE_BIT;
        compute.stage.module = shader;
        compute.stage.pName = "main";
        compute.layout = pipelineLayout;
        auto status = vkCreateComputePipelines(logical, VK_NULL_HANDLE, 1, &compute, nullptr, &pipeline);
        vkDestroyShaderModule(logical, shader, nullptr);
        if (status != VK_SUCCESS) return;
        VkCommandPoolCreateInfo commandInfo{VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO};
        commandInfo.queueFamilyIndex = family;
        if (vkCreateCommandPool(logical, &commandInfo, nullptr, &commands) != VK_SUCCESS) return;
        VkDescriptorPoolSize poolSize{VK_DESCRIPTOR_TYPE_STORAGE_BUFFER, 3};
        VkDescriptorPoolCreateInfo poolInfo{VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO};
        poolInfo.maxSets = 1;
        poolInfo.poolSizeCount = 1;
        poolInfo.pPoolSizes = &poolSize;
        vkCreateDescriptorPool(logical, &poolInfo, nullptr, &descriptors);
    }

    ~Device() {
        if (logical) {
            vkDestroyDescriptorPool(logical, descriptors, nullptr);
            vkDestroyCommandPool(logical, commands, nullptr);
            vkDestroyPipeline(logical, pipeline, nullptr);
            vkDestroyPipelineLayout(logical, pipelineLayout, nullptr);
            vkDestroyDescriptorSetLayout(logical, layout, nullptr);
            vkDestroyDevice(logical, nullptr);
        }
        if (instance) vkDestroyInstance(instance, nullptr);
    }
};

// Retain the device through process shutdown because Haxe owns buffer lifetimes.
inline Device& device() { static auto instance = new Device(); return *instance; }
inline bool available() { return device().descriptors != VK_NULL_HANDLE; }
inline const char* adapterName() { return device().properties.deviceName; }
inline int readbackCount() { return device().readbacks.load(); }
inline bool hardware() { return available() && device().properties.deviceType != VK_PHYSICAL_DEVICE_TYPE_CPU; }

struct Buffer {
    VkBuffer handle = VK_NULL_HANDLE;
    VkDeviceMemory allocation = VK_NULL_HANDLE;
    VkDeviceSize size;
    int width = 0, height = 0;
    void* mapped = nullptr;

    explicit Buffer(VkDeviceSize size) : size(size) {}
    ~Buffer() {
        auto logical = device().logical;
        if (mapped) vkUnmapMemory(logical, allocation);
        vkDestroyBuffer(logical, handle, nullptr);
        vkFreeMemory(logical, allocation, nullptr);
    }

    bool initialize(const void* input) {
        auto& gpu = device();
        VkBufferCreateInfo info{VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO};
        info.size = size;
        info.usage = VK_BUFFER_USAGE_STORAGE_BUFFER_BIT | VK_BUFFER_USAGE_TRANSFER_SRC_BIT;
        if (vkCreateBuffer(gpu.logical, &info, nullptr, &handle) != VK_SUCCESS) return false;
        VkMemoryRequirements requirements;
        vkGetBufferMemoryRequirements(gpu.logical, handle, &requirements);
        constexpr auto flags = VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT | VK_MEMORY_PROPERTY_HOST_COHERENT_BIT;
        uint32_t index = 0;
        while (index < gpu.memory.memoryTypeCount &&
               (!(requirements.memoryTypeBits & (1u << index)) ||
                (gpu.memory.memoryTypes[index].propertyFlags & flags) != flags)) ++index;
        if (index == gpu.memory.memoryTypeCount) return false;
        VkMemoryAllocateInfo memoryInfo{VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO};
        memoryInfo.allocationSize = requirements.size;
        memoryInfo.memoryTypeIndex = index;
        if (vkAllocateMemory(gpu.logical, &memoryInfo, nullptr, &allocation) != VK_SUCCESS ||
            vkBindBufferMemory(gpu.logical, handle, allocation, 0) != VK_SUCCESS ||
            vkMapMemory(gpu.logical, allocation, 0, size, 0, &mapped) != VK_SUCCESS) return false;
        if (input) std::memcpy(mapped, input, size);
        return true;
    }
};

inline Buffer* allocate(int width, int height, const unsigned char* bytes = nullptr) {
    if (!available() || width <= 0 || height <= 0) return nullptr;
    auto& limits = device().properties.limits;
    const VkDeviceSize size = VkDeviceSize(width) * height * 4;
    if (size > limits.maxStorageBufferRange || (width + 15u) / 16 > limits.maxComputeWorkGroupCount[0]
        || (height + 15u) / 16 > limits.maxComputeWorkGroupCount[1]) return nullptr;
    std::unique_ptr<Buffer> result(new Buffer(size));
    result->width = width;
    result->height = height;
    return result->initialize(bytes) ? result.release() : nullptr;
}
inline Buffer* upload(int width, int height, const unsigned char* bytes) { return allocate(width, height, bytes); }
inline void release(Buffer* buffer) { delete buffer; }
inline bool download(Buffer* buffer, unsigned char* bytes) {
    if (!buffer) return false;
    std::memcpy(bytes, buffer->mapped, buffer->size);
    ++device().readbacks;
    return true;
}

inline bool dispatch(Buffer* source, Buffer* result, int width, int height, int mode, int value, double stepX, double stepY,
        int kernelWidth, int kernelHeight, int x, int y, int w, int h, const unsigned char* weights) {
    if (!source || !result || kernelWidth * kernelHeight > 81) return false;
    auto& gpu = device();
    std::lock_guard<std::mutex> lock(gpu.mutex);
    struct Parameters {
        int sourceWidth, sourceHeight, width, height, mode;
        uint32_t value;
        int kernelWidth, kernelHeight, x, y, w, h;
        float stepX, stepY, weights[81];
    } data = {source->width, source->height, width, height, mode, uint32_t(value),
              kernelWidth, kernelHeight, x, y, w, h, float(stepX), float(stepY)};
    static_assert(sizeof(Parameters) == 95 * 4, "Shader parameters must use 32-bit words");
    for (int i = 0; i < kernelWidth * kernelHeight; ++i) {
        double weight;
        std::memcpy(&weight, weights + i * sizeof(double), sizeof(double));
        data.weights[i] = float(weight);
    }
    Buffer parameters(sizeof(data));
    if (!parameters.initialize(&data)) return false;
    if (vkResetDescriptorPool(gpu.logical, gpu.descriptors, 0) != VK_SUCCESS ||
        vkResetCommandPool(gpu.logical, gpu.commands, 0) != VK_SUCCESS) return false;
    VkDescriptorSetAllocateInfo descriptorInfo{VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO};
    descriptorInfo.descriptorPool = gpu.descriptors;
    descriptorInfo.descriptorSetCount = 1;
    descriptorInfo.pSetLayouts = &gpu.layout;
    VkDescriptorSet descriptor;
    if (vkAllocateDescriptorSets(gpu.logical, &descriptorInfo, &descriptor) != VK_SUCCESS) return false;
    VkDescriptorBufferInfo buffers[] = {{source->handle, 0, source->size},
        {result->handle, 0, result->size}, {parameters.handle, 0, parameters.size}};
    VkWriteDescriptorSet writes[3]{};
    for (uint32_t i = 0; i < 3; ++i) {
        writes[i].sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
        writes[i].dstSet = descriptor;
        writes[i].dstBinding = i;
        writes[i].descriptorCount = 1;
        writes[i].descriptorType = VK_DESCRIPTOR_TYPE_STORAGE_BUFFER;
        writes[i].pBufferInfo = &buffers[i];
    }
    vkUpdateDescriptorSets(gpu.logical, 3, writes, 0, nullptr);
    VkCommandBufferAllocateInfo commandInfo{VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO};
    commandInfo.commandPool = gpu.commands;
    commandInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
    commandInfo.commandBufferCount = 1;
    VkCommandBuffer command;
    if (vkAllocateCommandBuffers(gpu.logical, &commandInfo, &command) != VK_SUCCESS) return false;
    VkCommandBufferBeginInfo begin{VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO};
    begin.flags = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;
    if (vkBeginCommandBuffer(command, &begin) != VK_SUCCESS) return false;
    VkMemoryBarrier inputBarrier{VK_STRUCTURE_TYPE_MEMORY_BARRIER};
    inputBarrier.srcAccessMask = VK_ACCESS_SHADER_WRITE_BIT;
    inputBarrier.dstAccessMask = VK_ACCESS_SHADER_READ_BIT | VK_ACCESS_SHADER_WRITE_BIT;
    vkCmdPipelineBarrier(command, VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
        VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT, 0, 1, &inputBarrier, 0, nullptr, 0, nullptr);
    vkCmdBindPipeline(command, VK_PIPELINE_BIND_POINT_COMPUTE, gpu.pipeline);
    vkCmdBindDescriptorSets(command, VK_PIPELINE_BIND_POINT_COMPUTE, gpu.pipelineLayout, 0, 1, &descriptor, 0, nullptr);
    vkCmdDispatch(command, (width + 15) / 16, (height + 15) / 16, 1);
    VkMemoryBarrier outputBarrier{VK_STRUCTURE_TYPE_MEMORY_BARRIER};
    outputBarrier.srcAccessMask = VK_ACCESS_SHADER_WRITE_BIT;
    outputBarrier.dstAccessMask = VK_ACCESS_HOST_READ_BIT;
    vkCmdPipelineBarrier(command, VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
        VK_PIPELINE_STAGE_HOST_BIT, 0, 1, &outputBarrier, 0, nullptr, 0, nullptr);
    auto status = vkEndCommandBuffer(command);
    if (status == VK_SUCCESS) {
        VkSubmitInfo submit{VK_STRUCTURE_TYPE_SUBMIT_INFO};
        submit.commandBufferCount = 1;
        submit.pCommandBuffers = &command;
        status = vkQueueSubmit(gpu.queue, 1, &submit, VK_NULL_HANDLE);
        if (status == VK_SUCCESS) status = vkQueueWaitIdle(gpu.queue);
    }
    vkFreeCommandBuffers(gpu.logical, gpu.commands, 1, &command);
    return status == VK_SUCCESS;
}
inline Buffer* filter(Buffer* source, int width, int height, int mode, int value, double stepX, double stepY,
        int kernelWidth, int kernelHeight, int x, int y, int w, int h, const unsigned char* weights) {
    std::unique_ptr<Buffer> result(allocate(width, height));
    return dispatch(source, result.get(), width, height, mode, value, stepX, stepY,
        kernelWidth, kernelHeight, x, y, w, h, weights) ? result.release() : nullptr;
}
}
