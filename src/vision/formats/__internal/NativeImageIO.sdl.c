#include <SDL.h>
#include <limits.h>
#include <stdlib.h>
#include "NativeImageIO.h"

struct VisionWindow {
	SDL_Window *window;
	SDL_Renderer *renderer;
	SDL_Texture *texture;
	SDL_Surface *frame;
	bool accelerated;
	bool open;
	struct VisionWindow *next;
};

static VisionWindow *windows;

VisionWindow *vision_window_open(int x, int y, int width, int height, bool visible, bool prefer_gpu) {
	if (width <= 0 || height <= 0 || width > 16384 || height > 16384 || SDL_InitSubSystem(SDL_INIT_VIDEO) != 0)
		return NULL;
	VisionWindow *screen = calloc(1, sizeof(*screen));
	if (!screen) {
		SDL_QuitSubSystem(SDL_INIT_VIDEO);
		return NULL;
	}
	screen->window = SDL_CreateWindow("Vision", x, y, width, height, visible ? 0 : SDL_WINDOW_HIDDEN);
	if (!screen->window) {
		vision_window_close(screen);
		return NULL;
	}
	if (prefer_gpu) {
		screen->renderer = SDL_CreateRenderer(screen->window, -1, SDL_RENDERER_ACCELERATED);
		screen->accelerated = screen->renderer != NULL;
	}
	if (!screen->renderer)
		screen->renderer = SDL_CreateRenderer(screen->window, -1, SDL_RENDERER_SOFTWARE);
	if (screen->renderer)
		screen->texture = SDL_CreateTexture(screen->renderer, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, width, height);
	screen->frame = SDL_CreateRGBSurfaceWithFormat(0, width, height, 32, SDL_PIXELFORMAT_ARGB8888);
	if (!screen->texture || !screen->frame) {
		vision_window_close(screen);
		return NULL;
	}
	screen->open = true;
	screen->next = windows;
	windows = screen;
	vision_window_clear(screen, 0);
	return screen;
}

void vision_window_close(VisionWindow *screen) {
	if (!screen)
		return;
	VisionWindow **entry = &windows;
	while (*entry && *entry != screen)
		entry = &(*entry)->next;
	if (*entry)
		*entry = screen->next;
	if (screen->frame) SDL_FreeSurface(screen->frame);
	if (screen->texture) SDL_DestroyTexture(screen->texture);
	if (screen->renderer) SDL_DestroyRenderer(screen->renderer);
	if (screen->window) SDL_DestroyWindow(screen->window);
	free(screen);
	SDL_QuitSubSystem(SDL_INIT_VIDEO);
}

bool vision_window_poll(VisionWindow *screen) {
	SDL_Event event;
	while (SDL_PollEvent(&event)) {
		if (event.type == SDL_QUIT) {
			for (VisionWindow *entry = windows; entry; entry = entry->next)
				entry->open = false;
		} else if (event.type == SDL_WINDOWEVENT && event.window.event == SDL_WINDOWEVENT_CLOSE) {
			for (VisionWindow *entry = windows; entry; entry = entry->next) {
				if (SDL_GetWindowID(entry->window) == event.window.windowID) {
					entry->open = false;
					SDL_HideWindow(entry->window);
				}
			}
		}
	}
	return screen->open;
}

bool vision_window_gpu(VisionWindow *screen) {
	return screen->accelerated;
}

void vision_window_clear(VisionWindow *screen, int color) {
	SDL_FillRect(screen->frame, NULL, (uint32_t)color | UINT32_C(0xff000000));
}

bool vision_window_draw(VisionWindow *screen, const uint8_t *argb, int length, int offset, int width, int height, int x, int y) {
	if (!argb || offset < 0 || offset > length || width <= 0 || height <= 0 || width > INT_MAX / 4 ||
		(uint64_t)width * height * 4 != (uint64_t)(length - offset))
		return false;
	SDL_Surface *image = SDL_CreateRGBSurfaceWithFormatFrom((void *)(argb + offset), width, height, 32, width * 4, SDL_PIXELFORMAT_ARGB32);
	if (!image)
		return false;
	SDL_Rect position = {x, y, 0, 0};
	bool success = SDL_SetSurfaceBlendMode(image, SDL_BLENDMODE_BLEND) == 0 &&
		SDL_BlitSurface(image, NULL, screen->frame, &position) == 0;
	SDL_FreeSurface(image);
	return success;
}

bool vision_window_present(VisionWindow *screen) {
	if (!screen->open || SDL_UpdateTexture(screen->texture, NULL, screen->frame->pixels, screen->frame->pitch) != 0 ||
		SDL_RenderCopy(screen->renderer, screen->texture, NULL, NULL) != 0)
		return false;
	SDL_RenderPresent(screen->renderer);
	return true;
}
