#ifndef VISION_NATIVE_IMAGE_IO_H
#define VISION_NATIVE_IMAGE_IO_H

#include <stdbool.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct VisionWindow VisionWindow;

VisionWindow *vision_window_open(int x, int y, int width, int height, bool visible, bool prefer_gpu);
void vision_window_close(VisionWindow *window);
bool vision_window_poll(VisionWindow *window);
bool vision_window_gpu(VisionWindow *window);
void vision_window_clear(VisionWindow *window, int color);
bool vision_window_draw(VisionWindow *window, const uint8_t *argb, int length, int offset, int width, int height, int x, int y);
bool vision_window_present(VisionWindow *window);
bool vision_image_transform(uint8_t *argb, int length, int offset, int operation, int value);

#ifdef __cplusplus
}
#endif

#endif
