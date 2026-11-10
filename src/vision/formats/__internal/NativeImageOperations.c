#include "NativeImageIO.h"

// These selectors match ImageStorage.ImageOperation.
enum ImageOperation { INVERT = 1, SIMPLE_GRAYSCALE, BLACK_AND_WHITE };

bool vision_image_transform(uint8_t *argb, int length, int offset, int operation, int value) {
	if (!argb || offset < 0 || offset > length || (length - offset) % 4 != 0)
		return false;
	if (operation == INVERT) {
		for (int i = offset; i < length; i += 4) {
			argb[i] = 255;
			argb[i + 1] ^= 255;
			argb[i + 2] ^= 255;
			argb[i + 3] ^= 255;
		}
		return true;
	}
	if (operation == SIMPLE_GRAYSCALE) {
		for (int i = offset; i < length; i += 4) {
			const uint8_t gray = (uint8_t)((argb[i + 1] + argb[i + 2] + argb[i + 3]) / 3);
			argb[i] = 255;
			argb[i + 1] = gray;
			argb[i + 2] = gray;
			argb[i + 3] = gray;
		}
		return true;
	}
	if (operation == BLACK_AND_WHITE) {
		for (int i = offset; i < length; i += 4) {
			const uint8_t level = (argb[i + 1] > value || argb[i + 2] > value || argb[i + 3] > value) ? 255 : 0;
			argb[i] = 255;
			argb[i + 1] = level;
			argb[i + 2] = level;
			argb[i + 3] = level;
		}
		return true;
	}
	return false;
}
