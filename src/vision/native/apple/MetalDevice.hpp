#pragma once
#include <objc/runtime.h>
#include <objc/message.h>
#include <string>
#include <cstdint>
#include <cstring>
#include <atomic>
#include <mutex>

extern "C" id MTLCreateSystemDefaultDevice(void);

namespace vision_metal {
template<class Result = void, class... Args>
Result send(id object, const char* selector, Args... args) {
    return reinterpret_cast<Result(*)(id, SEL, Args...)>(objc_msgSend)(object, sel_registerName(selector), args...);
}

struct Pool {
    id object = send<id>((id)objc_getClass("NSAutoreleasePool"), "new");
    ~Pool() { send(object, "drain"); }
};

struct Grid { size_t x, y, z; };
struct Buffer {
    id object;
    int width, height;
};

struct Device {
    id hardware = nullptr, queue = nullptr, pipeline = nullptr;
    std::mutex mutex;
    std::atomic<int> readbacks{0};
    Device() {
        Pool pool;
        hardware = MTLCreateSystemDefaultDevice();
        if (!hardware) return;
        queue = send<id>(hardware, "newCommandQueue");
        static const char shader[] = R"(
            #include <metal_stdlib>
            using namespace metal;
            struct Parameters {
                int sourceWidth, sourceHeight, width, height, mode;
                uint value;
                int kernelWidth, kernelHeight, x, y, w, h;
                float stepX, stepY, weights[81];
            };
            float4 unpack(uint c) {
                return float4((c >> 8) & 255u, (c >> 16) & 255u, c >> 24, c & 255u);
            }
            uint pack(float4 c) {
                uint4 b = uint4(clamp(c, 0.0f, 255.0f));
                return b.a | (b.r << 8) | (b.g << 16) | (b.b << 24);
            }
            float4 samplePixel(device const uint* source, constant Parameters& p, int2 pos) {
                int2 q = clamp(pos, int2(0), int2(p.sourceWidth - 1, p.sourceHeight - 1));
                return unpack(source[q.y * p.sourceWidth + q.x]);
            }
            kernel void imagePass(device const uint* source [[buffer(0)]],
                    device uint* target [[buffer(1)]], constant Parameters& p [[buffer(2)]],
                    uint2 id [[thread_position_in_grid]]) {
                int2 pos = int2(id);
                if (pos.x >= p.width || pos.y >= p.height) return;
                if (p.mode == 10) {
                    int2 at = pos - int2(p.x,p.y);
                    if (any(at < 0) || at.x >= p.sourceWidth || at.y >= p.sourceHeight) return;
                    float4 incoming = samplePixel(source,p,at);
                    if (p.value) incoming = float4(255-incoming.rgb,255);
                    if (incoming.a == 0) return;
                    int index = pos.y*p.width+pos.x;
                    float4 prior = unpack(target[index]);
                    float a = incoming.a / 255;
                    target[index] = pack(prior.a == 0 ? incoming :
                        float4(mix(prior.rgb,incoming.rgb,a), incoming.a+prior.a*(1-a)));
                    return;
                }
                float4 c = samplePixel(source, p, pos);
                float2 q = float2(pos) * float2(p.stepX, p.stepY);
                switch (p.mode) {
                    case 0: {
                        int2 a = int2(q);
                        float2 f = fract(q);
                        float4 top = mix(samplePixel(source,p,a), samplePixel(source,p,a+int2(1,0)), f.x);
                        float4 bottom = mix(samplePixel(source,p,a+int2(0,1)), samplePixel(source,p,a+1), f.x);
                        c = floor(mix(top, bottom, f.y) + 0.00001f);
                        break;
                    }
                    case 1: c = samplePixel(source,p,int2(q)); break;
                    case 2: case 3: {
                        float3 sum = 0;
                        int i = 0;
                        for (int y = -p.kernelHeight / 2; y <= p.kernelHeight / 2; ++y)
                            for (int x = -p.kernelWidth / 2; x <= p.kernelWidth / 2; ++x)
                                sum += samplePixel(source,p,pos+int2(x,y)).rgb * p.weights[i++];
                        c = p.mode == 2 ? float4(floor(sum + 0.5f), c.a) : float4(floor(sum + 0.00001f),255);
                        break;
                    }
                    case 4: c = float4(255 - c.rgb,255); break;
                    case 5: c = float4(float3(floor((c.r+c.g+c.b)/3)),255); break;
                    case 6: c = float4(float3(max(max(c.r,c.g),c.b) > int(p.value) ? 255 : 0),255); break;
                    case 7:
                        if (pos.x >= p.x && pos.y >= p.y && pos.x < p.x+p.w && pos.y < p.y+p.h) c = unpack(p.value);
                        break;
                    case 8: c = float4(float3(floor(dot(c.rgb,float3(0.2126f,0.7152f,0.0722f)))),255); break;
                }
                target[pos.y*p.width+pos.x] = pack(c);
            })";
        auto string = (id)objc_getClass("NSString");
        auto source = send<id>(string, "stringWithUTF8String:", shader);
        id error = nullptr;
        auto library = send<id>(hardware, "newLibraryWithSource:options:error:", source, (id)nullptr, &error);
        if (!library) return;
        auto name = send<id>(string, "stringWithUTF8String:", "imagePass");
        auto function = send<id>(library, "newFunctionWithName:", name);
        if (function) {
            pipeline = send<id>(hardware, "newComputePipelineStateWithFunction:error:", function, &error);
            send(function, "release");
        }
        send(library, "release");
    }
};

inline Device& device() { static auto instance = new Device(); return *instance; }
inline bool available() { return device().queue && device().pipeline; }
inline int readbackCount() { return device().readbacks.load(); }
inline bool hardware() { return available(); }
inline const char* adapterName() {
    static const auto name = [] {
        Pool pool;
        auto label = send<id>(device().hardware, "name");
        const auto bytes = send<const char*>(label, "UTF8String");
        return std::string(bytes ? bytes : "Unavailable");
    }();
    return name.c_str();
}
inline Buffer* allocate(int width, int height) {
    if (!available() || width <= 0 || height <= 0) return nullptr;
    const auto bytes = size_t(width) * height * 4;
    auto object = send<id>(device().hardware, "newBufferWithLength:options:", bytes, size_t(0));
    return object ? new Buffer{object, width, height} : nullptr;
}
inline void release(Buffer* buffer) {
    if (!buffer) return;
    send(buffer->object, "release");
    delete buffer;
}
inline Buffer* upload(int width, int height, const unsigned char* bytes) {
    auto buffer = allocate(width, height);
    if (buffer) std::memcpy(send<void*>(buffer->object, "contents"), bytes, size_t(width)*height*4);
    return buffer;
}
inline bool download(Buffer* buffer, unsigned char* bytes) {
    if (!buffer) return false;
    std::memcpy(bytes, send<void*>(buffer->object, "contents"), size_t(buffer->width)*buffer->height*4);
    ++device().readbacks;
    return true;
}
inline bool dispatch(Buffer* source, Buffer* result, int width, int height, int mode, int value, double stepX, double stepY,
        int kernelWidth, int kernelHeight, int x, int y, int w, int h, const unsigned char* weights) {
    if (!source || !result || source == result || kernelWidth * kernelHeight > 81) return false;
    struct Parameters {
        int sourceWidth, sourceHeight, width, height, mode;
        uint32_t value;
        int kernelWidth, kernelHeight, x, y, w, h;
        float stepX, stepY, weights[81];
    } p = {source->width, source->height, width, height, mode, uint32_t(value),
           kernelWidth, kernelHeight, x, y, w, h, float(stepX), float(stepY)};
    for (int i = 0; i < kernelWidth * kernelHeight; ++i) {
        double weight;
        std::memcpy(&weight, weights + i * sizeof(double), sizeof(double));
        p.weights[i] = float(weight);
    }
    auto& gpu = device();
    std::lock_guard<std::mutex> lock(gpu.mutex);
    Pool pool;
    auto commands = send<id>(gpu.queue, "commandBuffer");
    auto encoder = send<id>(commands, "computeCommandEncoder");
    if (!encoder) return false;
    send(encoder, "setComputePipelineState:", gpu.pipeline);
    send(encoder, "setBuffer:offset:atIndex:", source->object, size_t(0), size_t(0));
    send(encoder, "setBuffer:offset:atIndex:", result->object, size_t(0), size_t(1));
    send(encoder, "setBytes:length:atIndex:", &p, sizeof(p), size_t(2));
    send(encoder, "dispatchThreadgroups:threadsPerThreadgroup:",
         Grid{size_t(width+15)/16,size_t(height+15)/16,1}, Grid{16,16,1});
    send(encoder, "endEncoding");
    send(commands, "commit");
    send(commands, "waitUntilCompleted");
    return send<size_t>(commands, "status") == 4;
}
inline Buffer* filter(Buffer* source, int width, int height, int mode, int value, double stepX, double stepY,
        int kernelWidth, int kernelHeight, int x, int y, int w, int h, const unsigned char* weights) {
    auto result = allocate(width, height);
    if (dispatch(source, result, width, height, mode, value, stepX, stepY,
            kernelWidth, kernelHeight, x, y, w, h, weights)) return result;
    release(result);
    return nullptr;
}
inline bool composite(Buffer* target, Buffer* source, int x, int y, bool invert) {
    return target && dispatch(source, target, target->width, target->height, 10,
        invert ? 1 : 0, 0, 0, 0, 0, x, y, 0, 0, nullptr);
}
}
