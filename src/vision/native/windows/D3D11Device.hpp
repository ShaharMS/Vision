#pragma once

#include <windows.h>
#include <d3d11.h>
#include <d3dcompiler.h>
#include <wrl/client.h>
#include <mutex>
#include <vector>
#include <cstring>
#include <atomic>

namespace vision_d3d11 {
using Microsoft::WRL::ComPtr;

struct Texture {
    ComPtr<ID3D11Texture2D> pixels;
    ComPtr<ID3D11ShaderResourceView> view;
    ComPtr<ID3D11UnorderedAccessView> output;
    int width, height;
};

struct Device {
    ComPtr<ID3D11Device> device;
    ComPtr<ID3D11DeviceContext> context;
    ComPtr<ID3D11ComputeShader> shader;
    ComPtr<ID3D11Buffer> parameters;
    std::mutex mutex;
    std::atomic<int> readbacks{0};

    Device() {
        const D3D_FEATURE_LEVEL levels[] = {D3D_FEATURE_LEVEL_11_0};
        if (FAILED(D3D11CreateDevice(nullptr, D3D_DRIVER_TYPE_HARDWARE, nullptr,
                D3D11_CREATE_DEVICE_BGRA_SUPPORT, levels, 1, D3D11_SDK_VERSION,
                &device, nullptr, &context))) return;
        static const char source[] = R"(
            Texture2D<uint> source : register(t0);
            RWTexture2D<uint> target : register(u0);
            cbuffer Parameters : register(b0) {
                int2 size; int mode; int value;
                float2 step; int2 kernel;
                int4 rect;
                float4 weights[21];
            };
            float4 unpack(uint color) {
                return float4((color >> 16) & 255, (color >> 8) & 255, color & 255, color >> 24);
            }
            uint pack(float4 color) {
                uint4 c = uint4(clamp(color, 0, 255));
                return (c.a << 24) | (c.r << 16) | (c.g << 8) | c.b;
            }
            float4 pixel(int2 p) {
                uint w, h;
                source.GetDimensions(w, h);
                return unpack(source.Load(int3(clamp(p, int2(0, 0), int2(w, h) - 1), 0)));
            }
            [numthreads(16, 16, 1)]
            void main(uint3 id : SV_DispatchThreadID) {
                int2 p = int2(id.xy);
                if (any(p >= size)) return;
                float4 c = pixel(p);
                if (mode == 0) {
                    float2 q = float2(p) * step;
                    int2 a = int2(q);
                    float2 f = frac(q);
                    c = floor(lerp(lerp(pixel(a), pixel(a + int2(1, 0)), f.x),
                        lerp(pixel(a + int2(0, 1)), pixel(a + 1), f.x), f.y) + 0.00001);
                } else if (mode == 1) {
                    c = pixel(int2(float2(p) * step));
                } else if (mode == 2 || mode == 3) {
                    float3 sum = 0;
                    int tap = 0;
                    for (int y = -kernel.y / 2; y <= kernel.y / 2; ++y)
                        for (int x = -kernel.x / 2; x <= kernel.x / 2; ++x) {
                            sum += pixel(p + int2(x,y)).rgb * weights[tap / 4][tap % 4];
                            ++tap;
                        }
                    c = mode == 2 ? float4(floor(sum + 0.5), c.a) : float4(floor(sum + 0.00001), 255);
                } else if (mode == 4) {
                    c = float4(255 - c.rgb, 255);
                } else if (mode == 5) {
                    c = float4(floor((c.r + c.g + c.b) / 3).xxx, 255);
                } else if (mode == 6) {
                    c = float4((max(max(c.r, c.g), c.b) > value ? 255.0 : 0.0).xxx, 255);
                } else if (mode == 7 && all(p >= rect.xy) && all(p < rect.xy + rect.zw)) {
                    c = unpack(asuint(value));
                } else if (mode == 8) {
                    c = float4(floor(dot(c.rgb, float3(0.2126, 0.7152, 0.0722))).xxx, 255);
                }
                target[p] = pack(c);
            })";
        ComPtr<ID3DBlob> code;
        if (FAILED(D3DCompile(source, sizeof(source) - 1, nullptr, nullptr, nullptr,
                "main", "cs_5_0", D3DCOMPILE_OPTIMIZATION_LEVEL3, 0, &code, nullptr))) return;
        if (FAILED(device->CreateComputeShader(code->GetBufferPointer(), code->GetBufferSize(), nullptr, &shader))) return;
        D3D11_BUFFER_DESC desc = {};
        desc.ByteWidth = 384;
        desc.Usage = D3D11_USAGE_DEFAULT;
        desc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
        device->CreateBuffer(&desc, nullptr, &parameters);
    }

    bool available() const { return parameters != nullptr; }
};

inline Device& device() { static Device instance; return instance; }
inline bool available() { return device().available(); }
inline int readbackCount() { return device().readbacks.load(); }
inline void release(Texture* texture) { delete texture; }

inline Texture* allocate(int width, int height, const unsigned int* initial = nullptr) {
    if (width <= 0 || height <= 0 || width > 16384 || height > 16384 || !available()) return nullptr;
    auto result = new Texture();
    result->width = width;
    result->height = height;
    D3D11_TEXTURE2D_DESC desc = {};
    desc.Width = width;
    desc.Height = height;
    desc.MipLevels = desc.ArraySize = desc.SampleDesc.Count = 1;
    desc.Format = DXGI_FORMAT_R32_UINT;
    desc.BindFlags = D3D11_BIND_SHADER_RESOURCE | D3D11_BIND_UNORDERED_ACCESS;
    D3D11_SUBRESOURCE_DATA data = {initial, UINT(width * 4), 0};
    auto& gpu = device();
    if (FAILED(gpu.device->CreateTexture2D(&desc, initial ? &data : nullptr, &result->pixels))
        || FAILED(gpu.device->CreateShaderResourceView(result->pixels.Get(), nullptr, &result->view))
        || FAILED(gpu.device->CreateUnorderedAccessView(result->pixels.Get(), nullptr, &result->output))) {
        delete result;
        return nullptr;
    }
    return result;
}

inline Texture* upload(int width, int height, const unsigned char* bytes) {
    if (width <= 0 || height <= 0 || width > 16384 || height > 16384 || !available()) return nullptr;
    std::vector<unsigned int> pixels(size_t(width) * height);
    for (size_t i = 0; i < pixels.size(); ++i) {
        auto p = bytes + i * 4;
        pixels[i] = (unsigned(p[0]) << 24) | (unsigned(p[1]) << 16) | (unsigned(p[2]) << 8) | p[3];
    }
    return allocate(width, height, pixels.data());
}

inline Texture* filter(Texture* source, int width, int height, int mode, int value, double stepX, double stepY,
        int kernelWidth, int kernelHeight, int x, int y, int w, int h, const unsigned char* weights) {
    if (!source || kernelWidth * kernelHeight > 81) return nullptr;
    auto result = allocate(width, height);
    if (!result) return nullptr;
    struct Parameters {
        int width, height, mode, value;
        float stepX, stepY;
        int kernelWidth, kernelHeight;
        int x, y, w, h;
        float weights[84];
    } params = {width, height, mode, value, float(stepX), float(stepY), kernelWidth, kernelHeight, x, y, w, h};
    for (int i = 0; i < kernelWidth * kernelHeight; ++i) {
        double weight;
        std::memcpy(&weight, weights + i * sizeof(double), sizeof(double));
        params.weights[i] = float(weight);
    }
    auto& gpu = device();
    std::lock_guard<std::mutex> lock(gpu.mutex);
    auto input = source->view.Get();
    auto output = result->output.Get();
    auto buffer = gpu.parameters.Get();
    gpu.context->UpdateSubresource(buffer, 0, nullptr, &params, 0, 0);
    gpu.context->CSSetShader(gpu.shader.Get(), nullptr, 0);
    gpu.context->CSSetShaderResources(0, 1, &input);
    gpu.context->CSSetUnorderedAccessViews(0, 1, &output, nullptr);
    gpu.context->CSSetConstantBuffers(0, 1, &buffer);
    gpu.context->Dispatch((width + 15) / 16, (height + 15) / 16, 1);
    input = nullptr;
    output = nullptr;
    gpu.context->CSSetShaderResources(0, 1, &input);
    gpu.context->CSSetUnorderedAccessViews(0, 1, &output, nullptr);
    return result;
}

inline bool synchronize() {
    auto& gpu = device();
    if (!gpu.available()) return false;
    D3D11_QUERY_DESC desc = {D3D11_QUERY_EVENT, 0};
    ComPtr<ID3D11Query> fence;
    if (FAILED(gpu.device->CreateQuery(&desc, &fence))) return false;
    std::lock_guard<std::mutex> lock(gpu.mutex);
    gpu.context->End(fence.Get());
    HRESULT status;
    while ((status = gpu.context->GetData(fence.Get(), nullptr, 0, 0)) == S_FALSE) Sleep(0);
    return status == S_OK;
}

inline bool download(Texture* source, unsigned char* bytes) {
    if (!source) return false;
    auto& gpu = device();
    D3D11_TEXTURE2D_DESC desc;
    source->pixels->GetDesc(&desc);
    desc.Usage = D3D11_USAGE_STAGING;
    desc.BindFlags = 0;
    desc.CPUAccessFlags = D3D11_CPU_ACCESS_READ;
    ComPtr<ID3D11Texture2D> staging;
    if (FAILED(gpu.device->CreateTexture2D(&desc, nullptr, &staging))) return false;
    std::lock_guard<std::mutex> lock(gpu.mutex);
    gpu.context->CopyResource(staging.Get(), source->pixels.Get());
    D3D11_MAPPED_SUBRESOURCE mapped;
    if (FAILED(gpu.context->Map(staging.Get(), 0, D3D11_MAP_READ, 0, &mapped))) return false;
    for (int y = 0; y < source->height; ++y) {
        const auto row = reinterpret_cast<const unsigned int*>(static_cast<const unsigned char*>(mapped.pData) + size_t(y) * mapped.RowPitch);
        for (int x = 0; x < source->width; ++x) {
            const auto p = row[x];
            *bytes++ = p >> 24;
            *bytes++ = p >> 16;
            *bytes++ = p >> 8;
            *bytes++ = p;
        }
    }
    gpu.context->Unmap(staging.Get(), 0);
    ++gpu.readbacks;
    return true;
}
struct WindowTarget {
    ComPtr<IDXGISwapChain> swap;
    ComPtr<ID3D11Texture2D> presentation;
    ComPtr<ID3D11UnorderedAccessView> output;
    ComPtr<ID3D11ComputeShader> convert;
    int width, height;
};

inline WindowTarget* openWindow(HWND window, int width, int height) {
    if (!available()) return nullptr;
    auto& gpu = device();
    ComPtr<IDXGIDevice> dxgi;
    ComPtr<IDXGIAdapter> adapter;
    ComPtr<IDXGIFactory> factory;
    if (FAILED(gpu.device.As(&dxgi)) || FAILED(dxgi->GetAdapter(&adapter))
        || FAILED(adapter->GetParent(IID_PPV_ARGS(&factory)))) return nullptr;
    auto result = new WindowTarget();
    result->width = width;
    result->height = height;
    DXGI_SWAP_CHAIN_DESC swap = {};
    swap.BufferDesc.Width = width;
    swap.BufferDesc.Height = height;
    swap.BufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    swap.SampleDesc.Count = 1;
    swap.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
    swap.BufferCount = 2;
    swap.OutputWindow = window;
    swap.Windowed = TRUE;
    swap.SwapEffect = DXGI_SWAP_EFFECT_DISCARD;
    D3D11_TEXTURE2D_DESC tex = {};
    tex.Width = width;
    tex.Height = height;
    tex.MipLevels = tex.ArraySize = tex.SampleDesc.Count = 1;
    tex.Format = swap.BufferDesc.Format;
    tex.BindFlags = D3D11_BIND_UNORDERED_ACCESS;
    static const char source[] = R"(
        Texture2D<uint> source : register(t0);
        RWTexture2D<float4> target : register(u0);
        [numthreads(16,16,1)]
        void main(uint3 id : SV_DispatchThreadID) {
            uint w,h;
            target.GetDimensions(w,h);
            if (id.x >= w || id.y >= h) return;
            uint c = source.Load(int3(id.xy,0));
            target[id.xy] = float4((c >> 16) & 255, (c >> 8) & 255, c & 255, 255) / 255.0;
        })";
    ComPtr<ID3DBlob> code;
    if (FAILED(factory->CreateSwapChain(gpu.device.Get(), &swap, &result->swap))
        || FAILED(gpu.device->CreateTexture2D(&tex, nullptr, &result->presentation))
        || FAILED(gpu.device->CreateUnorderedAccessView(result->presentation.Get(), nullptr, &result->output))
        || FAILED(D3DCompile(source, sizeof(source)-1, nullptr, nullptr, nullptr, "main", "cs_5_0", 0, 0, &code, nullptr))
        || FAILED(gpu.device->CreateComputeShader(code->GetBufferPointer(), code->GetBufferSize(), nullptr, &result->convert))) {
        delete result;
        return nullptr;
    }
    return result;
}

inline void closeWindow(WindowTarget* window) { delete window; }

inline bool present(WindowTarget* window, Texture* frame) {
    if (!window || !frame || frame->width != window->width || frame->height != window->height) return false;
    auto& gpu = device();
    std::lock_guard<std::mutex> lock(gpu.mutex);
    auto input = frame->view.Get();
    auto output = window->output.Get();
    gpu.context->CSSetShader(window->convert.Get(), nullptr, 0);
    gpu.context->CSSetShaderResources(0, 1, &input);
    gpu.context->CSSetUnorderedAccessViews(0, 1, &output, nullptr);
    gpu.context->Dispatch((frame->width + 15) / 16, (frame->height + 15) / 16, 1);
    input = nullptr;
    output = nullptr;
    gpu.context->CSSetShaderResources(0, 1, &input);
    gpu.context->CSSetUnorderedAccessViews(0, 1, &output, nullptr);
    ComPtr<ID3D11Texture2D> back;
    if (FAILED(window->swap->GetBuffer(0, IID_PPV_ARGS(&back)))) return false;
    gpu.context->CopyResource(back.Get(), window->presentation.Get());
    return SUCCEEDED(window->swap->Present(0, 0));
}

inline bool draw(Texture* target, Texture* source, int x, int y, bool invert) {
    if (!target || !source || target == source) return false;
    auto& gpu = device();
    std::lock_guard<std::mutex> lock(gpu.mutex);
    struct Parameters { int x, y, invert, pad; } params = {x,y,invert,0};
    static const char code[] = R"(
        Texture2D<uint> source : register(t0);
        RWTexture2D<uint> target : register(u0);
        cbuffer Params : register(b0) { int2 offset; int invert; int padding; }
        [numthreads(16,16,1)]
        void main(uint3 id : SV_DispatchThreadID) {
            uint w,h;
            source.GetDimensions(w,h);
            if (id.x >= w || id.y >= h) return;
            int2 p = int2(id.xy) + offset;
            target.GetDimensions(w,h);
            if (any(p < 0) || p.x >= int(w) || p.y >= int(h)) return;
            uint s = source.Load(int3(id.xy,0));
            if (invert != 0) s = (s ^ 0x00ffffff) | 0xff000000;
            uint a = s >> 24;
            if (a == 0) return;
            if (a == 255) { target[p] = s; return; }
            uint d = target[p];
            uint da = d >> 24;
            if (da == 0) { target[p] = s; return; }
            uint3 src = uint3((s >> 16) & 255, (s >> 8) & 255, s & 255);
            uint3 dst = uint3((d >> 16) & 255, (d >> 8) & 255, d & 255);
            uint3 c = (src * a + dst * (255 - a)) / 255;
            uint alpha = a + (255 - a) * da / 255;
            target[p] = (alpha << 24) | (c.r << 16) | (c.g << 8) | c.b;
        })";
    static ComPtr<ID3D11ComputeShader> shader;
    static ComPtr<ID3D11Buffer> constants;
    if (!shader) {
        ComPtr<ID3DBlob> blob;
        if (FAILED(D3DCompile(code, sizeof(code)-1, nullptr, nullptr, nullptr, "main", "cs_5_0", 0, 0, &blob, nullptr))
            || FAILED(gpu.device->CreateComputeShader(blob->GetBufferPointer(), blob->GetBufferSize(), nullptr, &shader))) return false;
    }
    if (!constants) {
        D3D11_BUFFER_DESC desc = {};
        desc.ByteWidth = 16;
        desc.BindFlags = D3D11_BIND_CONSTANT_BUFFER;
        if (FAILED(gpu.device->CreateBuffer(&desc, nullptr, &constants))) return false;
    }
    auto input = source->view.Get();
    auto output = target->output.Get();
    auto buffer = constants.Get();
    gpu.context->UpdateSubresource(buffer, 0, nullptr, &params, 0, 0);
    gpu.context->CSSetShader(shader.Get(), nullptr, 0);
    gpu.context->CSSetShaderResources(0, 1, &input);
    gpu.context->CSSetUnorderedAccessViews(0, 1, &output, nullptr);
    gpu.context->CSSetConstantBuffers(0, 1, &buffer);
    gpu.context->Dispatch((source->width + 15) / 16, (source->height + 15) / 16, 1);
    input = nullptr;
    output = nullptr;
    gpu.context->CSSetShaderResources(0, 1, &input);
    gpu.context->CSSetUnorderedAccessViews(0, 1, &output, nullptr);
    return true;
}

}
