package vision.ds;

/** The concrete synchronous batch implementation returned by Image.accelerate(). **/
#if (js && !nodejs)
typedef ImageAcceleration = vision.native.browser.WebGLAccelerationBackend;
#elseif (windows && ((cpp && !cppia) || (hl && vision_hashlink_screen)))
typedef ImageAcceleration = vision.native.windows.D3D11AccelerationBackend;
#elseif (cpp && !cppia && mac)
typedef ImageAcceleration = vision.native.apple.MetalAccelerationBackend;
#elseif (cpp && !cppia && vision_vulkan)
typedef ImageAcceleration = vision.native.linux.VulkanAccelerationBackend;
#else
typedef ImageAcceleration = vision.native.portable.CpuAccelerationBackend;
#end
