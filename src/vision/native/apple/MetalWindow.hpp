#pragma once
#include "MetalDevice.hpp"
#include <CoreGraphics/CGGeometry.h>
#include <pthread.h>

namespace vision_metal {
struct Window {
    id window = nullptr, layer = nullptr, pipeline = nullptr;
    bool closed = false;
    static void didClose(id observer, SEL, id) {
        auto owner = *static_cast<Window**>(object_getIndexedIvars(observer));
        owner->closed = true;
    }
    id observer = nullptr;
    ~Window() {
        if (observer) {
            auto center = send<id>((id)objc_getClass("NSNotificationCenter"), "defaultCenter");
            send(center, "removeObserver:", observer);
            send(observer, "release");
        }
        if (window && !closed) send(window, "close");
        if (layer) send(layer, "release");
        if (window) send(window, "release");
        if (pipeline) send(pipeline, "release");
    }
};

inline Window* openWindow(int x, int y, int width, int height, bool visible) {
    if (!available() || !pthread_main_np()) return nullptr;
    Pool pool;
    auto app = send<id>((id)objc_getClass("NSApplication"), "sharedApplication");
    if (!app) return nullptr;
    send<bool>(app, "setActivationPolicy:", long(0));
    send(app, "finishLaunching");
    auto result = new Window();
    result->window = send<id>(send<id>((id)objc_getClass("NSWindow"), "alloc"),
        "initWithContentRect:styleMask:backing:defer:", CGRectMake(x,y,width,height), size_t(15), size_t(2), false);
    result->layer = send<id>((id)objc_getClass("CAMetalLayer"), "new");
    if (!result->window || !result->layer) { delete result; return nullptr; }
    send(result->window, "setReleasedWhenClosed:", false);
    static Class observerClass = [] {
        auto cls = objc_allocateClassPair(objc_getClass("NSObject"), "VisionMetalWindowObserver", 0);
        class_addMethod(cls, sel_registerName("visionWindowDidClose:"), reinterpret_cast<IMP>(Window::didClose), "v@:@");
        objc_registerClassPair(cls);
        return cls;
    }();
    result->observer = class_createInstance(observerClass, sizeof(Window*));
    *static_cast<Window**>(object_getIndexedIvars(result->observer)) = result;
    auto center = send<id>((id)objc_getClass("NSNotificationCenter"), "defaultCenter");
    auto closed = send<id>((id)objc_getClass("NSString"), "stringWithUTF8String:", "NSWindowWillCloseNotification");
    send(center, "addObserver:selector:name:object:", result->observer, sel_registerName("visionWindowDidClose:"), closed, result->window);
    auto title = send<id>((id)objc_getClass("NSString"), "stringWithUTF8String:", "Vision Metal");
    send(result->window, "setTitle:", title);
    send(result->layer, "setDevice:", device().hardware);
    send(result->layer, "setPixelFormat:", size_t(80)); // MTLPixelFormatBGRA8Unorm
    send(result->layer, "setFramebufferOnly:", false);
    send(result->layer, "setDrawableSize:", CGSizeMake(width,height));
    auto view = send<id>(result->window, "contentView");
    send(view, "setWantsLayer:", true);
    send(view, "setLayer:", result->layer);

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
    if (visible) send(result->window, "makeKeyAndOrderFront:", (id)nullptr);
    return result;
}

inline void closeWindow(Window* window) { delete window; }

inline bool pollWindow(Window* window) {
    if (!window || !pthread_main_np()) return false;
    Pool pool;
    auto app = send<id>((id)objc_getClass("NSApplication"), "sharedApplication");
    auto date = send<id>((id)objc_getClass("NSDate"), "distantPast");
    auto mode = send<id>((id)objc_getClass("NSString"), "stringWithUTF8String:", "kCFRunLoopDefaultMode");
    while (auto event = send<id>(app, "nextEventMatchingMask:untilDate:inMode:dequeue:", ~size_t(0), date, mode, true))
        send(app, "sendEvent:", event);
    return !window->closed;
}

inline void requestClose(Window* window) {
    Pool pool;
    send(window->window, "performClose:", (id)nullptr);
}

inline bool setWindowMode(Window* window, int mode) {
    if (!window || window->closed || !pthread_main_np()) return false;
    Pool pool;
    auto native = window->window;
    const bool fullscreen = (send<size_t>(native, "styleMask") & (1 << 14)) != 0;
    if (fullscreen != (mode == 3)) send(native, "toggleFullScreen:", (id)nullptr);
    if (mode == 1) send(native, "miniaturize:", (id)nullptr);
    else {
        if (send<bool>(native, "isMiniaturized")) send(native, "deminiaturize:", (id)nullptr);
        send(native, "makeKeyAndOrderFront:", (id)nullptr);
        if (mode != 3 && send<bool>(native, "isZoomed") != (mode == 2)) send(native, "zoom:", (id)nullptr);
    }
    return true;
}

inline void setBounds(Window* window, int x, int y, int width, int height) {
    Pool pool;
    send(window->window, "setContentSize:", CGSizeMake(width,height));
    send(window->window, "setFrameOrigin:", CGPointMake(x,y));
    send(window->layer, "setDrawableSize:", CGSizeMake(width,height));
}

inline bool present(Window* window, Buffer* frame) {
    if (!window || !frame || !pthread_main_np()) return false;
    Pool pool;
    if (!send<bool>(window->window, "isVisible") || send<bool>(window->window, "isMiniaturized")) return true;
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
