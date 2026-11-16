#ifndef VISION_SDL_SCREEN_H
#define VISION_SDL_SCREEN_H

#define SDL_MAIN_HANDLED
#include <SDL2/SDL.h>
#include <cstring>

struct VisionSdlWindow {
	SDL_Window *window;
	SDL_Renderer *renderer;
	SDL_Texture *frame;
	SDL_Texture *sprite;
	int spriteWidth;
	int spriteHeight;
	int width;
	int height;
	bool closed;
	bool exposed;
	VisionSdlWindow *next;
};

inline VisionSdlWindow *&vision_sdl_windows() {
	static VisionSdlWindow *windows = nullptr;
	return windows;
}

static inline SDL_Renderer *vision_sdl_renderer(SDL_Window *window, bool preferGpu) {
	if (preferGpu) {
#ifdef __APPLE__
		for (int index = 0; index < SDL_GetNumRenderDrivers(); ++index) {
			SDL_RendererInfo info;
			if (SDL_GetRenderDriverInfo(index, &info) == 0 && std::strcmp(info.name, "metal") == 0) {
				SDL_Renderer *metal = SDL_CreateRenderer(window, index, SDL_RENDERER_ACCELERATED | SDL_RENDERER_TARGETTEXTURE);
				if (metal) return metal;
			}
		}
#endif
		SDL_Renderer *accelerated = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_TARGETTEXTURE);
		if (accelerated) return accelerated;
	}
	return SDL_CreateRenderer(window, -1, SDL_RENDERER_SOFTWARE | SDL_RENDERER_TARGETTEXTURE);
}

static inline bool vision_sdl_fill(SDL_Renderer *renderer, Uint32 color) {
	return SDL_SetRenderDrawColor(renderer, (color >> 16) & 255, (color >> 8) & 255, color & 255, 255) == 0 &&
		SDL_RenderClear(renderer) == 0;
}

static inline SDL_Texture *vision_sdl_frame(SDL_Renderer *renderer, int width, int height) {
	SDL_Texture *texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_TARGET, width, height);
	if (!texture) return nullptr;
	if (SDL_SetTextureBlendMode(texture, SDL_BLENDMODE_NONE) == 0 &&
		SDL_SetRenderTarget(renderer, texture) == 0 && vision_sdl_fill(renderer, 0)) return texture;
	SDL_DestroyTexture(texture);
	return nullptr;
}

static inline VisionSdlWindow *vision_sdl_open(int x, int y, int width, int height, bool visible, bool preferGpu) {
	SDL_SetMainReady();
	if (SDL_InitSubSystem(SDL_INIT_VIDEO) != 0) return nullptr;
	SDL_Window *window = SDL_CreateWindow("Vision", x, y, width, height,
		visible ? SDL_WINDOW_SHOWN : SDL_WINDOW_HIDDEN);
	SDL_Renderer *renderer = window ? vision_sdl_renderer(window, preferGpu) : nullptr;
	SDL_Texture *frame = renderer ? vision_sdl_frame(renderer, width, height) : nullptr;
	if (!frame) {
		if (renderer) SDL_DestroyRenderer(renderer);
		if (window) SDL_DestroyWindow(window);
		SDL_QuitSubSystem(SDL_INIT_VIDEO);
		return nullptr;
	}
	VisionSdlWindow *screen = new VisionSdlWindow{
		window, renderer, frame, nullptr, 0, 0, width, height, false, false, vision_sdl_windows()
	};
	vision_sdl_windows() = screen;
	return screen;
}

static inline void vision_sdl_close(VisionSdlWindow *screen) {
	VisionSdlWindow **entry = &vision_sdl_windows();
	while (*entry != screen) entry = &(*entry)->next;
	*entry = screen->next;
	SDL_DestroyRenderer(screen->renderer);
	SDL_DestroyWindow(screen->window);
	delete screen;
	SDL_QuitSubSystem(SDL_INIT_VIDEO);
}

static inline int vision_sdl_poll(VisionSdlWindow *screen) {
	SDL_Event event;
	while (SDL_PollEvent(&event)) {
		for (VisionSdlWindow *entry = vision_sdl_windows(); entry; entry = entry->next) {
			if (event.type == SDL_QUIT) entry->closed = true;
			if (event.type == SDL_WINDOWEVENT && event.window.windowID == SDL_GetWindowID(entry->window)) {
				if (event.window.event == SDL_WINDOWEVENT_CLOSE) {
					entry->closed = true;
					SDL_HideWindow(entry->window);
				}
				if (event.window.event == SDL_WINDOWEVENT_EXPOSED || event.window.event == SDL_WINDOWEVENT_SIZE_CHANGED)
					entry->exposed = true;
			}
		}
	}
	if (screen->closed) return 0;
	bool exposed = screen->exposed;
	screen->exposed = false;
	return exposed ? 2 : 1;
}

static inline bool vision_sdl_bounds(VisionSdlWindow *screen, int x, int y, int width, int height) {
	if (width != screen->width || height != screen->height) {
		SDL_Texture *replacement = vision_sdl_frame(screen->renderer, width, height);
		if (!replacement) {
			SDL_SetRenderTarget(screen->renderer, screen->frame);
			return false;
		}
		SDL_Rect overlap = {0, 0, SDL_min(width, screen->width), SDL_min(height, screen->height)};
		if (SDL_RenderCopy(screen->renderer, screen->frame, &overlap, &overlap) != 0) {
			SDL_SetRenderTarget(screen->renderer, screen->frame);
			SDL_DestroyTexture(replacement);
			return false;
		}
		SDL_DestroyTexture(screen->frame);
		screen->frame = replacement;
		screen->width = width;
		screen->height = height;
		SDL_SetWindowSize(screen->window, width, height);
	}
	SDL_SetWindowPosition(screen->window, x, y);
	return true;
}

static inline bool vision_sdl_clear(VisionSdlWindow *screen, Uint32 color) {
	return vision_sdl_fill(screen->renderer, color);
}

static inline bool vision_sdl_draw(VisionSdlWindow *screen, const unsigned char *argb, int width, int height, int x, int y) {
	if (!screen->sprite || width != screen->spriteWidth || height != screen->spriteHeight) {
		SDL_Texture *replacement = SDL_CreateTexture(screen->renderer, SDL_PIXELFORMAT_ARGB32,
			SDL_TEXTUREACCESS_STREAMING, width, height);
		if (!replacement) return false;
		if (SDL_SetTextureBlendMode(replacement, SDL_BLENDMODE_BLEND) != 0) {
			SDL_DestroyTexture(replacement);
			return false;
		}
		if (screen->sprite) SDL_DestroyTexture(screen->sprite);
		screen->sprite = replacement;
		screen->spriteWidth = width;
		screen->spriteHeight = height;
	}
	SDL_Rect target = {x, y, width, height};
	return SDL_UpdateTexture(screen->sprite, nullptr, argb, width * 4) == 0 &&
		SDL_RenderCopy(screen->renderer, screen->sprite, nullptr, &target) == 0;
}

static inline bool vision_sdl_present(VisionSdlWindow *screen) {
	if (screen->closed || SDL_SetRenderTarget(screen->renderer, nullptr) != 0) return false;
	bool copied = SDL_RenderCopy(screen->renderer, screen->frame, nullptr, nullptr) == 0;
	if (copied) SDL_RenderPresent(screen->renderer);
	return SDL_SetRenderTarget(screen->renderer, screen->frame) == 0 && copied;
}

static inline bool vision_sdl_capture(VisionSdlWindow *screen, unsigned char *argb) {
	return SDL_RenderReadPixels(screen->renderer, nullptr, SDL_PIXELFORMAT_ARGB32, argb, screen->width * 4) == 0;
}

#ifdef VISION_SCREEN_TESTS
static inline Uint32 vision_sdl_window_id(VisionSdlWindow *screen) {
	return SDL_GetWindowID(screen->window);
}

static inline bool vision_sdl_window_exists(Uint32 id) {
	return SDL_GetWindowFromID(id) != nullptr;
}

static inline bool vision_sdl_matches_size(VisionSdlWindow *screen, int width, int height) {
	int w, h;
	SDL_GetWindowSize(screen->window, &w, &h);
	return w == width && h == height;
}

static inline bool vision_sdl_is_shown(VisionSdlWindow *screen) {
	return (SDL_GetWindowFlags(screen->window) & SDL_WINDOW_SHOWN) != 0;
}

static inline const char *vision_sdl_renderer_name(VisionSdlWindow *screen) {
	SDL_RendererInfo info;
	return SDL_GetRendererInfo(screen->renderer, &info) == 0 ? info.name : "";
}

static inline bool vision_sdl_accelerated(VisionSdlWindow *screen) {
	SDL_RendererInfo info;
	return SDL_GetRendererInfo(screen->renderer, &info) == 0 && (info.flags & SDL_RENDERER_ACCELERATED) != 0;
}

static inline Uint32 vision_sdl_pixel(VisionSdlWindow *screen, int x, int y) {
	SDL_Rect area = {x, y, 1, 1};
	Uint32 argb = 0;
	if (SDL_RenderReadPixels(screen->renderer, &area, SDL_PIXELFORMAT_ARGB8888, &argb, 4) != 0) return 0;
	return argb;
}

static inline bool vision_sdl_request_close(VisionSdlWindow *screen) {
	SDL_Event event = {};
	event.type = SDL_WINDOWEVENT;
	event.window.windowID = SDL_GetWindowID(screen->window);
	event.window.event = SDL_WINDOWEVENT_CLOSE;
	return SDL_PushEvent(&event) == 1;
}
#endif

#endif
