#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdbool.h>
#include <stdio.h>
#include <webgpu/webgpu.h>
#include <webgpu/wgpu.h>

static void adapter_ready(WGPURequestAdapterStatus status, WGPUAdapter adapter,
	WGPUStringView message, void *output, void *unused) {
	if (status == WGPURequestAdapterStatus_Success)
		*(WGPUAdapter *)output = adapter;
	else
		fprintf(stderr, "WebGPU adapter request failed: %.*s\n", (int)message.length, message.data);
}

static void device_ready(WGPURequestDeviceStatus status, WGPUDevice device,
	WGPUStringView message, void *output, void *unused) {
	if (status == WGPURequestDeviceStatus_Success)
		*(WGPUDevice *)output = device;
	else
		fprintf(stderr, "WebGPU device request failed: %.*s\n", (int)message.length, message.data);
}

static int clear_surface(HWND window) {
	WGPUInstance instance = wgpuCreateInstance(NULL);
	WGPUSurface surface = NULL;
	WGPUAdapter adapter = NULL;
	WGPUDevice device = NULL;
	WGPUQueue queue = NULL;
	WGPUTextureView view = NULL;
	WGPUCommandEncoder encoder = NULL;
	WGPUCommandBuffer commands = NULL;
	WGPUSurfaceTexture frame = WGPU_SURFACE_TEXTURE_INIT;
	WGPUSurfaceCapabilities caps = WGPU_SURFACE_CAPABILITIES_INIT;
	int status = 2;
	if (!instance)
		goto done;

	WGPUSurfaceSourceWindowsHWND source = WGPU_SURFACE_SOURCE_WINDOWS_HWND_INIT;
	source.hinstance = GetModuleHandleW(NULL);
	source.hwnd = window;
	WGPUSurfaceDescriptor descriptor = WGPU_SURFACE_DESCRIPTOR_INIT;
	descriptor.nextInChain = &source.chain;
	surface = wgpuInstanceCreateSurface(instance, &descriptor);
	if (!surface)
		goto done;

	status = 3;
	WGPURequestAdapterOptions options = WGPU_REQUEST_ADAPTER_OPTIONS_INIT;
	options.compatibleSurface = surface;
	options.powerPreference = WGPUPowerPreference_HighPerformance;
	WGPURequestAdapterCallbackInfo adapter_callback = WGPU_REQUEST_ADAPTER_CALLBACK_INFO_INIT;
	adapter_callback.mode = WGPUCallbackMode_AllowSpontaneous;
	adapter_callback.callback = adapter_ready;
	adapter_callback.userdata1 = &adapter;
	// The pinned wgpu-native release invokes device and adapter requests synchronously.
	wgpuInstanceRequestAdapter(instance, &options, adapter_callback);
	if (!adapter)
		goto done;

	WGPUAdapterInfo info = WGPU_ADAPTER_INFO_INIT;
	if (wgpuAdapterGetInfo(adapter, &info) == WGPUStatus_Success) {
		printf("Adapter: %.*s, backend=%d, type=%d\n", (int)info.device.length, info.device.data, info.backendType, info.adapterType);
		wgpuAdapterInfoFreeMembers(info);
	}

	status = 4;
	WGPURequestDeviceCallbackInfo device_callback = WGPU_REQUEST_DEVICE_CALLBACK_INFO_INIT;
	device_callback.mode = WGPUCallbackMode_AllowSpontaneous;
	device_callback.callback = device_ready;
	device_callback.userdata1 = &device;
	wgpuAdapterRequestDevice(adapter, NULL, device_callback);
	if (!device)
		goto done;

	status = 5;
	if (wgpuSurfaceGetCapabilities(surface, adapter, &caps) != WGPUStatus_Success || caps.formatCount == 0)
		goto done;
	WGPUSurfaceConfiguration config = WGPU_SURFACE_CONFIGURATION_INIT;
	config.device = device;
	config.format = caps.formats[0];
	config.width = config.height = 64;
	config.presentMode = WGPUPresentMode_Fifo;
	wgpuSurfaceConfigure(surface, &config);
	wgpuSurfaceGetCurrentTexture(surface, &frame);
	if (!frame.texture || (frame.status != WGPUSurfaceGetCurrentTextureStatus_SuccessOptimal &&
		frame.status != WGPUSurfaceGetCurrentTextureStatus_SuccessSuboptimal))
		goto done;

	status = 6;
	view = wgpuTextureCreateView(frame.texture, NULL);
	encoder = wgpuDeviceCreateCommandEncoder(device, NULL);
	if (!view || !encoder)
		goto done;
	WGPURenderPassColorAttachment color = WGPU_RENDER_PASS_COLOR_ATTACHMENT_INIT;
	color.view = view;
	color.loadOp = WGPULoadOp_Clear;
	color.storeOp = WGPUStoreOp_Store;
	color.clearValue = (WGPUColor){0, 1, 0, 1};
	WGPURenderPassDescriptor pass_descriptor = WGPU_RENDER_PASS_DESCRIPTOR_INIT;
	pass_descriptor.colorAttachmentCount = 1;
	pass_descriptor.colorAttachments = &color;
	WGPURenderPassEncoder pass = wgpuCommandEncoderBeginRenderPass(encoder, &pass_descriptor);
	if (!pass)
		goto done;
	wgpuRenderPassEncoderEnd(pass);
	wgpuRenderPassEncoderRelease(pass);
	commands = wgpuCommandEncoderFinish(encoder, NULL);
	queue = wgpuDeviceGetQueue(device);
	if (!commands || !queue)
		goto done;
	wgpuQueueSubmit(queue, 1, &commands);
	status = wgpuSurfacePresent(surface) == WGPUStatus_Success ? 0 : 7;
	wgpuDevicePoll(device, true, NULL);

done:
	if (commands) wgpuCommandBufferRelease(commands);
	if (encoder) wgpuCommandEncoderRelease(encoder);
	if (view) wgpuTextureViewRelease(view);
	if (frame.texture) wgpuTextureRelease(frame.texture);
	if (queue) wgpuQueueRelease(queue);
	if (surface) wgpuSurfaceRelease(surface);
	if (caps.formats) wgpuSurfaceCapabilitiesFreeMembers(caps);
	if (device) wgpuDeviceRelease(device);
	if (adapter) wgpuAdapterRelease(adapter);
	if (instance) wgpuInstanceRelease(instance);
	return status;
}

int vision_webgpu_probe(void) {
	HWND window = CreateWindowExW(0, L"STATIC", L"Vision WebGPU probe", WS_POPUP,
		0, 0, 64, 64, NULL, NULL, GetModuleHandleW(NULL), NULL);
	if (!window)
		return 1;
	int result = clear_surface(window);
	DestroyWindow(window);
	return result;
}
