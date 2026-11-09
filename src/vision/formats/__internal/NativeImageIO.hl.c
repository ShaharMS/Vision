#define HL_NAME(name) vision_native_##name
#include <hl.h>
#include "NativeImageIO.h"

HL_PRIM VisionWindow *HL_NAME(open)(int width, int height, bool visible, bool gpu) {
	return vision_window_open(width, height, visible, gpu);
}

HL_PRIM void HL_NAME(close)(VisionWindow *window) {
	vision_window_close(window);
}

HL_PRIM bool HL_NAME(poll)(VisionWindow *window) {
	return vision_window_poll(window);
}

HL_PRIM bool HL_NAME(gpu)(VisionWindow *window) {
	return vision_window_gpu(window);
}

HL_PRIM void HL_NAME(clear)(VisionWindow *window, int color) {
	vision_window_clear(window, color);
}

HL_PRIM bool HL_NAME(draw)(VisionWindow *window, vbyte *bytes, int length, int offset, int width, int height, int x, int y) {
	return vision_window_draw(window, bytes, length, offset, width, height, x, y);
}

HL_PRIM bool HL_NAME(present)(VisionWindow *window) {
	return vision_window_present(window);
}

HL_PRIM bool HL_NAME(transform)(vbyte *bytes, int length, int offset, int operation, int value) {
	return vision_image_transform(bytes, length, offset, operation, value);
}

#define _WINDOW _ABSTRACT(vision_window)
DEFINE_PRIM(_WINDOW, open, _I32 _I32 _BOOL _BOOL);
DEFINE_PRIM(_VOID, close, _WINDOW);
DEFINE_PRIM(_BOOL, poll, _WINDOW);
DEFINE_PRIM(_BOOL, gpu, _WINDOW);
DEFINE_PRIM(_VOID, clear, _WINDOW _I32);
DEFINE_PRIM(_BOOL, draw, _WINDOW _BYTES _I32 _I32 _I32 _I32 _I32 _I32);
DEFINE_PRIM(_BOOL, present, _WINDOW);
DEFINE_PRIM(_BOOL, transform, _BYTES _I32 _I32 _I32 _I32);
