package vision.ds.accelerate;

// A supported graphics target takes precedence over the CPU define.
#if (js && !nodejs)
typedef PlatformImage = vision.native.browser.BrowserImage;
typedef PlatformBatch = vision.native.browser.BrowserImageBatch;
#elseif vision_cpu
typedef PlatformImage = vision.native.cpu.CpuImage;
typedef PlatformBatch = vision.native.cpu.CpuImageBatch;
#else
// Preserve existing headless and native targets until their graphics implementation lands.
typedef PlatformImage = vision.native.cpu.CpuImage;
typedef PlatformBatch = vision.native.cpu.CpuImageBatch;
#end
