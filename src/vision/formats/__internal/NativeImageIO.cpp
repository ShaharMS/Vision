#define IMPLEMENT_API
#include <hx/CFFI.h>
#include "NativeImageIO.h"

DEFINE_KIND(vision_window_kind);

static VisionWindow *window_pointer(value handle) {
	return static_cast<VisionWindow *>(val_data(handle));
}

static value open(value *arguments, int count) {
	if (count != 6)
		return alloc_null();
	auto window = vision_window_open(val_int(arguments[0]), val_int(arguments[1]), val_int(arguments[2]), val_int(arguments[3]),
		val_bool(arguments[4]), val_bool(arguments[5]));
	return window ? alloc_abstract(vision_window_kind, window) : alloc_null();
}

static value close(value handle) {
	vision_window_close(window_pointer(handle));
	return alloc_null();
}

static value poll(value handle) {
	return alloc_bool(vision_window_poll(window_pointer(handle)));
}

static value gpu(value handle) {
	return alloc_bool(vision_window_gpu(window_pointer(handle)));
}

static value clear(value handle, value color) {
	vision_window_clear(window_pointer(handle), val_int(color));
	return alloc_null();
}

static value draw(value *arguments, int count) {
	if (count != 8)
		return alloc_bool(false);
	const int length = val_int(arguments[2]);
	auto bytes = val_to_buffer(arguments[1]);
	return alloc_bool(bytes && buffer_size(bytes) == length &&
		vision_window_draw(window_pointer(arguments[0]), reinterpret_cast<uint8_t *>(buffer_data(bytes)), length,
			val_int(arguments[3]), val_int(arguments[4]), val_int(arguments[5]), val_int(arguments[6]), val_int(arguments[7])));
}

static value present(value handle) {
	return alloc_bool(vision_window_present(window_pointer(handle)));
}

static value transform(value data, value size, value offset, value operation, value parameter) {
	const int length = val_int(size);
	auto bytes = val_to_buffer(data);
	return alloc_bool(bytes && buffer_size(bytes) == length &&
		vision_image_transform(reinterpret_cast<uint8_t *>(buffer_data(bytes)), length,
			val_int(offset), val_int(operation), val_int(parameter)));
}

DEFINE_PRIM_MULT(open);
DEFINE_PRIM(close, 1);
DEFINE_PRIM(poll, 1);
DEFINE_PRIM(gpu, 1);
DEFINE_PRIM(clear, 2);
DEFINE_PRIM_MULT(draw);
DEFINE_PRIM(present, 1);
DEFINE_PRIM(transform, 5);
