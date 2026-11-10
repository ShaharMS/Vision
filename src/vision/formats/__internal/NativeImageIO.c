#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdlib.h>
#include "NativeImageIO.h"

#ifdef VISION_WEBGPU
#include <webgpu/webgpu.h>
#include <webgpu/wgpu.h>
#endif

struct VisionWindow {
	HWND hwnd;
	int width;
	int height;
	uint32_t *frame;
#ifdef VISION_WEBGPU
	WGPUInstance instance;
	WGPUSurface surface;
	WGPUDevice device;
	WGPUQueue queue;
	WGPUTexture pixels;
	WGPURenderPipeline pipeline;
	WGPUBindGroup bindings;
	bool configured;
#endif
};

#ifdef VISION_WEBGPU
static void adapter_ready(WGPURequestAdapterStatus status, WGPUAdapter adapter,
	WGPUStringView message, void *output, void *unused) {
	if (status == WGPURequestAdapterStatus_Success)
		*(WGPUAdapter *)output = adapter;
}

static void device_ready(WGPURequestDeviceStatus status, WGPUDevice device,
	WGPUStringView message, void *output, void *unused) {
	if (status == WGPURequestDeviceStatus_Success)
		*(WGPUDevice *)output = device;
}

static void close_gpu(VisionWindow *window) {
	if (window->configured) wgpuSurfaceUnconfigure(window->surface);
	if (window->bindings) wgpuBindGroupRelease(window->bindings);
	if (window->pipeline) wgpuRenderPipelineRelease(window->pipeline);
	if (window->pixels) wgpuTextureRelease(window->pixels);
	if (window->queue) wgpuQueueRelease(window->queue);
	if (window->surface) wgpuSurfaceRelease(window->surface);
	if (window->device) wgpuDeviceRelease(window->device);
	if (window->instance) wgpuInstanceRelease(window->instance);
	window->configured = false;
	window->bindings = NULL;
	window->pipeline = NULL;
	window->pixels = NULL;
	window->queue = NULL;
	window->surface = NULL;
	window->device = NULL;
	window->instance = NULL;
}

static bool create_gpu_frame(VisionWindow *window, WGPUTextureFormat format) {
	WGPUTextureDescriptor texture = WGPU_TEXTURE_DESCRIPTOR_INIT;
	texture.size = (WGPUExtent3D){window->width, window->height, 1};
	texture.format = format;
	texture.usage = WGPUTextureUsage_CopyDst | WGPUTextureUsage_TextureBinding;
	window->pixels = wgpuDeviceCreateTexture(window->device, &texture);
	if (!window->pixels)
		return false;

	WGPUShaderSourceWGSL wgsl = WGPU_SHADER_SOURCE_WGSL_INIT;
	wgsl.code = (WGPUStringView){
		"@group(0) @binding(0) var frame: texture_2d<f32>;"
		"@vertex fn vertex(@builtin(vertex_index) i: u32) -> @builtin(position) vec4f {"
		"  let points = array(vec2f(-1.0, -1.0), vec2f(3.0, -1.0), vec2f(-1.0, 3.0));"
		"  return vec4f(points[i], 0.0, 1.0);"
		"}"
		"@fragment fn fragment(@builtin(position) p: vec4f) -> @location(0) vec4f {"
		"  return textureLoad(frame, vec2i(p.xy), 0);"
		"}", WGPU_STRLEN
	};
	WGPUShaderModuleDescriptor module_descriptor = WGPU_SHADER_MODULE_DESCRIPTOR_INIT;
	module_descriptor.nextInChain = &wgsl.chain;
	WGPUShaderModule module = wgpuDeviceCreateShaderModule(window->device, &module_descriptor);
	if (!module)
		return false;

	WGPUColorTargetState target = WGPU_COLOR_TARGET_STATE_INIT;
	target.format = format;
	WGPUFragmentState fragment = WGPU_FRAGMENT_STATE_INIT;
	fragment.module = module;
	fragment.entryPoint = (WGPUStringView){"fragment", WGPU_STRLEN};
	fragment.targetCount = 1;
	fragment.targets = &target;
	WGPURenderPipelineDescriptor pipeline = WGPU_RENDER_PIPELINE_DESCRIPTOR_INIT;
	pipeline.vertex.module = module;
	pipeline.vertex.entryPoint = (WGPUStringView){"vertex", WGPU_STRLEN};
	pipeline.fragment = &fragment;
	window->pipeline = wgpuDeviceCreateRenderPipeline(window->device, &pipeline);
	wgpuShaderModuleRelease(module);
	if (!window->pipeline)
		return false;

	WGPUBindGroupLayout layout = wgpuRenderPipelineGetBindGroupLayout(window->pipeline, 0);
	WGPUTextureView view = wgpuTextureCreateView(window->pixels, NULL);
	if (layout && view) {
		WGPUBindGroupEntry entry = WGPU_BIND_GROUP_ENTRY_INIT;
		entry.textureView = view;
		WGPUBindGroupDescriptor descriptor = WGPU_BIND_GROUP_DESCRIPTOR_INIT;
		descriptor.layout = layout;
		descriptor.entryCount = 1;
		descriptor.entries = &entry;
		window->bindings = wgpuDeviceCreateBindGroup(window->device, &descriptor);
	}
	if (view) wgpuTextureViewRelease(view);
	if (layout) wgpuBindGroupLayoutRelease(layout);
	return window->bindings != NULL;
}

static bool open_gpu(VisionWindow *window) {
	window->instance = wgpuCreateInstance(NULL);
	if (!window->instance)
		return false;

	WGPUSurfaceSourceWindowsHWND source = WGPU_SURFACE_SOURCE_WINDOWS_HWND_INIT;
	source.hinstance = GetModuleHandleW(NULL);
	source.hwnd = window->hwnd;
	WGPUSurfaceDescriptor descriptor = WGPU_SURFACE_DESCRIPTOR_INIT;
	descriptor.nextInChain = &source.chain;
	window->surface = wgpuInstanceCreateSurface(window->instance, &descriptor);
	if (!window->surface)
		return false;

	WGPUAdapter adapter = NULL;
	WGPURequestAdapterOptions options = WGPU_REQUEST_ADAPTER_OPTIONS_INIT;
	options.compatibleSurface = window->surface;
	WGPURequestAdapterCallbackInfo adapter_callback = WGPU_REQUEST_ADAPTER_CALLBACK_INFO_INIT;
	adapter_callback.mode = WGPUCallbackMode_AllowSpontaneous;
	adapter_callback.callback = adapter_ready;
	adapter_callback.userdata1 = &adapter;
	// The pinned wgpu-native ABI completes these requests during the call.
	wgpuInstanceRequestAdapter(window->instance, &options, adapter_callback);
	if (!adapter)
		return false;

	WGPUSurfaceCapabilities caps = WGPU_SURFACE_CAPABILITIES_INIT;
	WGPUTextureFormat format = WGPUTextureFormat_Undefined;
	if (wgpuSurfaceGetCapabilities(window->surface, adapter, &caps) == WGPUStatus_Success) {
		for (size_t i = 0; i < caps.formatCount; ++i) {
			if (caps.formats[i] == WGPUTextureFormat_BGRA8Unorm || caps.formats[i] == WGPUTextureFormat_BGRA8UnormSrgb) {
				format = caps.formats[i];
				break;
			}
		}
		wgpuSurfaceCapabilitiesFreeMembers(caps);
	}
	if (format != WGPUTextureFormat_Undefined) {
		WGPURequestDeviceCallbackInfo device_callback = WGPU_REQUEST_DEVICE_CALLBACK_INFO_INIT;
		device_callback.mode = WGPUCallbackMode_AllowSpontaneous;
		device_callback.callback = device_ready;
		device_callback.userdata1 = &window->device;
		wgpuAdapterRequestDevice(adapter, NULL, device_callback);
	}
	wgpuAdapterRelease(adapter);
	if (!window->device)
		return false;

	window->queue = wgpuDeviceGetQueue(window->device);
	if (!window->queue || !create_gpu_frame(window, format))
		return false;
	WGPUSurfaceConfiguration config = WGPU_SURFACE_CONFIGURATION_INIT;
	config.device = window->device;
	config.usage = WGPUTextureUsage_RenderAttachment;
	config.format = format;
	config.width = window->width;
	config.height = window->height;
	config.presentMode = WGPUPresentMode_Fifo;
	wgpuSurfaceConfigure(window->surface, &config);
	window->configured = true;
	return true;
}

static bool present_gpu(VisionWindow *window) {
	WGPUSurfaceTexture frame = WGPU_SURFACE_TEXTURE_INIT;
	wgpuSurfaceGetCurrentTexture(window->surface, &frame);
	bool success = false;
	if (frame.texture && (frame.status == WGPUSurfaceGetCurrentTextureStatus_SuccessOptimal ||
		frame.status == WGPUSurfaceGetCurrentTextureStatus_SuccessSuboptimal)) {
		WGPUTexelCopyTextureInfo target = WGPU_TEXEL_COPY_TEXTURE_INFO_INIT;
		target.texture = window->pixels;
		WGPUTexelCopyBufferLayout layout = WGPU_TEXEL_COPY_BUFFER_LAYOUT_INIT;
		layout.bytesPerRow = window->width * 4;
		layout.rowsPerImage = window->height;
		WGPUExtent3D extent = {window->width, window->height, 1};
		wgpuQueueWriteTexture(window->queue, &target, window->frame,
			(size_t)window->width * window->height * 4, &layout, &extent);
		WGPUTextureView view = wgpuTextureCreateView(frame.texture, NULL);
		WGPUCommandEncoder encoder = wgpuDeviceCreateCommandEncoder(window->device, NULL);
		if (view && encoder) {
			WGPURenderPassColorAttachment color = WGPU_RENDER_PASS_COLOR_ATTACHMENT_INIT;
			color.view = view;
			color.loadOp = WGPULoadOp_Clear;
			color.storeOp = WGPUStoreOp_Store;
			WGPURenderPassDescriptor descriptor = WGPU_RENDER_PASS_DESCRIPTOR_INIT;
			descriptor.colorAttachmentCount = 1;
			descriptor.colorAttachments = &color;
			WGPURenderPassEncoder pass = wgpuCommandEncoderBeginRenderPass(encoder, &descriptor);
			if (pass) {
				wgpuRenderPassEncoderSetPipeline(pass, window->pipeline);
				wgpuRenderPassEncoderSetBindGroup(pass, 0, window->bindings, 0, NULL);
				wgpuRenderPassEncoderDraw(pass, 3, 1, 0, 0);
				wgpuRenderPassEncoderEnd(pass);
				wgpuRenderPassEncoderRelease(pass);
				WGPUCommandBuffer commands = wgpuCommandEncoderFinish(encoder, NULL);
				if (commands) {
					wgpuQueueSubmit(window->queue, 1, &commands);
					wgpuCommandBufferRelease(commands);
					success = wgpuSurfacePresent(window->surface) == WGPUStatus_Success;
				}
			}
		}
		if (encoder) wgpuCommandEncoderRelease(encoder);
		if (view) wgpuTextureViewRelease(view);
	}
	if (frame.texture) wgpuTextureRelease(frame.texture);
	return success;
}
#endif

static const wchar_t *screen_class = L"VisionScreen";

static LRESULT CALLBACK screen_message(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam) {
	VisionWindow *window = (VisionWindow *)GetWindowLongPtrW(hwnd, GWLP_USERDATA);
	switch (message) {
		case WM_NCCREATE:
			SetWindowLongPtrW(hwnd, GWLP_USERDATA, (LONG_PTR)((CREATESTRUCTW *)lparam)->lpCreateParams);
			break;
		case WM_ERASEBKGND:
			return 1;
		case WM_PAINT:
			if (window && window->hwnd) {
				PAINTSTRUCT paint;
				BeginPaint(hwnd, &paint);
				vision_window_present(window);
				EndPaint(hwnd, &paint);
				return 0;
			}
			break;
		case WM_NCDESTROY:
			if (window) window->hwnd = NULL;
			SetWindowLongPtrW(hwnd, GWLP_USERDATA, 0);
			break;
	}
	return DefWindowProcW(hwnd, message, wparam, lparam);
}

VisionWindow *vision_window_open(int x, int y, int width, int height, bool visible, bool prefer_gpu) {
	if (width <= 0 || height <= 0 || width > 16384 || height > 16384)
		return NULL;
	WNDCLASSW window_class = {0};
	window_class.lpfnWndProc = screen_message;
	window_class.hInstance = GetModuleHandleW(NULL);
	window_class.hCursor = LoadCursor(NULL, IDC_ARROW);
	window_class.lpszClassName = screen_class;
	if (!RegisterClassW(&window_class) && GetLastError() != ERROR_CLASS_ALREADY_EXISTS)
		return NULL;

	VisionWindow *window = calloc(1, sizeof(*window));
	if (!window)
		return NULL;
	window->width = width;
	window->height = height;
	window->frame = calloc((size_t)width * height, sizeof(*window->frame));
	if (window->frame) {
		DWORD style = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX;
		RECT bounds = {0, 0, width, height};
		AdjustWindowRect(&bounds, style, FALSE);
		window->hwnd = CreateWindowExW(0, screen_class, L"Vision", style,
			x, y, bounds.right - bounds.left, bounds.bottom - bounds.top,
			NULL, NULL, window_class.hInstance, window);
	}
	if (!window->hwnd) {
		vision_window_close(window);
		return NULL;
	}
	vision_window_clear(window, 0);
#ifdef VISION_WEBGPU
	if (prefer_gpu && !open_gpu(window))
		close_gpu(window);
#endif
	if (visible) ShowWindow(window->hwnd, SW_SHOW);
	return window;
}

void vision_window_close(VisionWindow *window) {
	if (!window)
		return;
#ifdef VISION_WEBGPU
	close_gpu(window);
#endif
	if (IsWindow(window->hwnd)) DestroyWindow(window->hwnd);
	free(window->frame);
	free(window);
}

bool vision_window_poll(VisionWindow *window) {
	MSG message;
	while (PeekMessageW(&message, NULL, 0, 0, PM_REMOVE)) {
		TranslateMessage(&message);
		DispatchMessageW(&message);
	}
	return IsWindow(window->hwnd);
}

bool vision_window_gpu(VisionWindow *window) {
#ifdef VISION_WEBGPU
	return window->configured;
#else
	return false;
#endif
}

void vision_window_clear(VisionWindow *window, int color) {
	const uint32_t opaque = (uint32_t)color | UINT32_C(0xff000000);
	for (size_t i = 0, count = (size_t)window->width * window->height; i < count; ++i)
		window->frame[i] = opaque;
}

static unsigned blend(unsigned source, unsigned destination, unsigned alpha) {
	return (source * alpha + destination * (255 - alpha) + 127) / 255;
}

bool vision_window_draw(VisionWindow *window, const uint8_t *argb, int length, int offset, int width, int height, int x, int y) {
	if (!argb || offset < 0 || offset > length || width <= 0 || height <= 0 ||
		(uint64_t)width * height * 4 != (uint64_t)(length - offset))
		return false;
	argb += offset;
	const int64_t right = (int64_t)x + width;
	const int64_t bottom = (int64_t)y + height;
	const int end_x = right < window->width ? (int)right : window->width;
	const int end_y = bottom < window->height ? (int)bottom : window->height;
	for (int row = y > 0 ? y : 0; row < end_y; ++row) {
		for (int col = x > 0 ? x : 0; col < end_x; ++col) {
			const uint8_t *source = argb + ((size_t)(row - y) * width + (size_t)(col - x)) * 4;
			uint32_t *destination = &window->frame[(size_t)row * window->width + col];
			const unsigned a = source[0];
			const unsigned r = blend(source[1], (*destination >> 16) & 255, a);
			const unsigned g = blend(source[2], (*destination >> 8) & 255, a);
			const unsigned b = blend(source[3], *destination & 255, a);
			*destination = UINT32_C(0xff000000) | (r << 16) | (g << 8) | b;
		}
	}
	return true;
}

bool vision_window_present(VisionWindow *window) {
	if (!IsWindow(window->hwnd))
		return false;
#ifdef VISION_WEBGPU
	if (window->configured) {
		if (present_gpu(window))
			return true;
		close_gpu(window);
	}
#endif
	BITMAPINFO info = {0};
	info.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
	info.bmiHeader.biWidth = window->width;
	info.bmiHeader.biHeight = -window->height;
	info.bmiHeader.biPlanes = 1;
	info.bmiHeader.biBitCount = 32;
	info.bmiHeader.biCompression = BI_RGB;
	HDC dc = GetDC(window->hwnd);
	if (!dc)
		return false;
	int result = StretchDIBits(dc, 0, 0, window->width, window->height,
		0, 0, window->width, window->height, window->frame, &info, DIB_RGB_COLORS, SRCCOPY);
	ReleaseDC(window->hwnd, dc);
	return result != GDI_ERROR && result != 0;
}
