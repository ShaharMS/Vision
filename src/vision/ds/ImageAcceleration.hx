package vision.ds;

/** The concrete synchronous batch implementation returned by Image.accelerate(). **/
#if (js && !nodejs)
typedef ImageAcceleration = vision.native.browser.WebGLAccelerationBackend;
#else
typedef ImageAcceleration = vision.native.portable.CpuAccelerationBackend;
#end
