#pragma once
#include "MetalDevice.hpp"
#include <CoreGraphics/CGGeometry.h>
#include <pthread.h>
#include <TargetConditionals.h>

namespace vision_metal {
#if TARGET_OS_IOS
// The host owns the UIView and binds it on the main thread.
inline id& hostView() { static id view = nullptr; return view; }
inline void bindHostView(id view) { hostView() = view; }
#endif

struct Window {
    id window = nullptr, layer = nullptr, pipeline = nullptr;
    ~Window() {
#if TARGET_OS_IOS
        if (window) send(window, "removeFromSuperview");
#else
        if (window) send(window, "close");
#endif
        if (layer) send(layer, "release");
        if (window) send(window, "release");
        if (pipeline) send(pipeline, "release");
    }
};

inline Window* openWindow(int x, int y, int width, int height, bool visible) {
    if (!available() || !pthread_main_np()) return nullptr;
    Pool pool;
#if TARGET_OS_IOS
    if (!hostView()) return nullptr;
    auto result = new Window();
    result->window = send<id>(send<id>((id)objc_getClass("UIView"), "alloc"), "initWithFrame:", CGRectMake(x,y,width,height));
    result->layer = send<id>((id)objc_getClass("CAMetalLayer"), "new");
    if (!result->window || !result->layer) { delete result; return nullptr; }
    send(result->window, "setHidden:", !visible);
    send(hostView(), "addSubview:", result->window);
#else
    auto app = send<id>((id)objc_getClass("NSApplication"), "sharedApplication");
    if (!app) return nullptr;
    send<bool>(app, "setActivationPolicy:", long(0));
    send(app, "finishLaunching");
    auto result = new Window();
    result->window = send<id>(send<id>((id)objc_getClass("NSWindow"), "alloc"),
        "initWithContentRect:styleMask:backing:defer:", CGRectMake(x,y,width,height), size_t(7), size_t(2), false);
    result->layer = send<id>((id)objc_getClass("CAMetalLayer"), "new");
    if (!result->window || !result->layer) { delete result; return nullptr; }
    send(result->window, "setReleasedWhenClosed:", false);
    auto title = send<id>((id)objc_getClass("NSString"), "stringWithUTF8String:", "Vision Metal");
    send(result->window, "setTitle:", title);
#endif
    send(result->layer, "setDevice:", device().hardware);
    send(result->layer, "setPixelFormat:", size_t(80)); // MTLPixelFormatBGRA8Unorm
    send(result->layer, "setFramebufferOnly:", false);
    send(result->layer, "setDrawableSize:", CGSizeMake(width,height));
#if TARGET_OS_IOS
    auto view = send<id>(result->window, "layer");
    send(result->layer, "setFrame:", CGRectMake(0,0,width,height));
    send(view, "addSublayer:", result->layer);
#else
    auto view = send<id>(result->window, "contentView");
    send(view, "setWantsLayer:", true);
    send(view, "setLayer:", result->layer);
#endif

    static const char shader[] = R"(
        #include <metal_stdlib>
        using namespace metal;
        kernel void show(device const uint* source [[buffer(0)]],
                constant uint2& size [[buffer(1)]], texture2d<float, access::write> drawable [[texture(0)]],
                uint2 p [[thread_position_in_grid]]) {
            if (p.x >= drawable.get_width() || p.y >= drawable.get_height()) return;
            uint c = all(p < size) ? source[p.y*size.x+p.x] : 0;
            drawable.write(float4((c >> 8) & 255u,(c >> 16) & 255u,c >> 24,255)/255,p);
        })";
    auto string = (id)objc_getClass("NSString");
    auto source = send<id>(string, "stringWithUTF8String:", shader);
    id error = nullptr;
    auto library = send<id>(device().hardware, "newLibraryWithSource:options:error:", source, (id)nullptr, &error);
    if (library) {
        auto function = send<id>(library, "newFunctionWithName:", send<id>(string, "stringWithUTF8String:", "show"));
        if (function) {
            result->pipeline = send<id>(device().hardware, "newComputePipelineStateWithFunction:error:", function, &error);
            send(function, "release");
        }
        send(library, "release");
    }
    if (!result->pipeline) { delete result; return nullptr; }
#if !TARGET_OS_IOS
    if (visible) send(result->window, "makeKeyAndOrderFront:", (id)nullptr);
#endif
    return result;
}

inline void closeWindow(Window* window) { delete window; }

inline bool pollWindow(Window* window) {
    if (!window || !pthread_main_np()) return false;
    Pool pool;
#if TARGET_OS_IOS
    return send<id>(window->window, "window") != nullptr;
#else
    auto app = send<id>((id)objc_getClass("NSApplication"), "sharedApplication");
    auto date = send<id>((id)objc_getClass("NSDate"), "distantPast");
    auto mode = send<id>((id)objc_getClass("NSString"), "stringWithUTF8String:", "kCFRunLoopDefaultMode");
    while (auto event = send<id>(app, "nextEventMatchingMask:untilDate:inMode:dequeue:", ~size_t(0), date, mode, true))
        send(app, "sendEvent:", event);
    return send<bool>(window->window, "isVisible");
#endif
}

inline void setBounds(Window* window, int x, int y, int width, int height) {
    Pool pool;
#if TARGET_OS_IOS
    send(window->window, "setFrame:", CGRectMake(x,y,width,height));
    send(window->layer, "setFrame:", CGRectMake(0,0,width,height));
#else
    send(window->window, "setContentSize:", CGSizeMake(width,height));
    send(window->window, "setFrameOrigin:", CGPointMake(x,y));
#endif
    send(window->layer, "setDrawableSize:", CGSizeMake(width,height));
}

inline bool present(Window* window, Buffer* frame) {
    if (!window || !frame || !pthread_main_np()) return false;
    Pool pool;
    auto drawable = send<id>(window->layer, "nextDrawable");
    if (!drawable) return false;
    auto texture = send<id>(drawable, "texture");
    auto& gpu = device();
    std::lock_guard<std::mutex> lock(gpu.mutex);
    auto commands = send<id>(gpu.queue, "commandBuffer");
    auto encoder = send<id>(commands, "computeCommandEncoder");
    if (!encoder) return false;
    const uint32_t size[] = {uint32_t(frame->width),uint32_t(frame->height)};
    send(encoder, "setComputePipelineState:", window->pipeline);
    send(encoder, "setBuffer:offset:atIndex:", frame->object, size_t(0), size_t(0));
    send(encoder, "setBytes:length:atIndex:", size, sizeof(size), size_t(1));
    send(encoder, "setTexture:atIndex:", texture, size_t(0));
    send(encoder, "dispatchThreadgroups:threadsPerThreadgroup:",
        Grid{(send<size_t>(texture, "width")+15)/16,(send<size_t>(texture, "height")+15)/16,1}, Grid{16,16,1});
    send(encoder, "endEncoding");
    send(commands, "presentDrawable:", drawable);
    send(commands, "commit");
    send(commands, "waitUntilCompleted");
    return send<size_t>(commands, "status") == 4;
}
}
