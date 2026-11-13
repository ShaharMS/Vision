package vision.ds.accelerate;

// A supported graphics target takes precedence over the CPU define.
#if (js && !nodejs)
typedef PlatformImage = vision.native.browser.BrowserImage;
typedef PlatformBatch = vision.native.browser.BrowserImageBatch;
#elseif (cpp && !cppia && (mac || ios) && vision_metal)
typedef PlatformImage = vision.native.apple.MetalImage;
typedef PlatformBatch = vision.native.apple.MetalImageBatch;
#elseif (cpp && !cppia && vision_vulkan)
typedef PlatformImage = vision.native.vulkan.VulkanImage;
typedef PlatformBatch = vision.native.vulkan.VulkanImageBatch;
#elseif (windows && cpp && !cppia)
typedef PlatformImage = vision.native.windows.D3D11Image;
typedef PlatformBatch = vision.native.windows.D3D11ImageBatch;
#elseif vision_cpu
typedef PlatformImage = vision.native.cpu.CpuImage;
typedef PlatformBatch = vision.native.cpu.CpuImageBatch;
#else
// Preserve existing headless and native targets until their graphics implementation lands.
typedef PlatformImage = vision.native.cpu.CpuImage;
typedef PlatformBatch = vision.native.cpu.CpuImageBatch;
#end
