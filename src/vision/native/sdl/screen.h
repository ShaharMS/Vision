#ifndef VISION_SDL_SCREEN_H
#define VISION_SDL_SCREEN_H

#define SDL_MAIN_HANDLED
#include <SDL2/SDL.h>

struct VisionSdlWindow {
	SDL_Window *window;
	bool closed;
	bool exposed;
	VisionSdlWindow *next;
};

inline VisionSdlWindow *&vision_sdl_windows() {
	static VisionSdlWindow *windows = nullptr;
	return windows;
}

static inline VisionSdlWindow *vision_sdl_open(int x, int y, int width, int height, bool visible) {
	SDL_SetMainReady();
	if (SDL_InitSubSystem(SDL_INIT_VIDEO) != 0) return nullptr;
	SDL_Window *window = SDL_CreateWindow("Vision", x, y, width, height,
		visible ? SDL_WINDOW_SHOWN : SDL_WINDOW_HIDDEN);
	if (!window) {
		SDL_QuitSubSystem(SDL_INIT_VIDEO);
		return nullptr;
	}
	VisionSdlWindow *screen = new VisionSdlWindow{window, false, false, vision_sdl_windows()};
	vision_sdl_windows() = screen;
	return screen;
}

static inline void vision_sdl_close(VisionSdlWindow *screen) {
	VisionSdlWindow **entry = &vision_sdl_windows();
	while (*entry != screen) entry = &(*entry)->next;
	*entry = screen->next;
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

static inline void vision_sdl_bounds(VisionSdlWindow *screen, int x, int y, int width, int height) {
	SDL_SetWindowPosition(screen->window, x, y);
	SDL_SetWindowSize(screen->window, width, height);
}

static inline bool vision_sdl_present(VisionSdlWindow *screen, unsigned char *rgba, int width, int height) {
	if (screen->closed) return false;
	SDL_Surface *target = SDL_GetWindowSurface(screen->window);
	if (!target) return false;
	SDL_Surface *source = SDL_CreateRGBSurfaceWithFormatFrom(rgba, width, height, 32, width * 4, SDL_PIXELFORMAT_RGBA32);
	if (!source) return false;
	bool copied = SDL_SetSurfaceBlendMode(source, SDL_BLENDMODE_NONE) == 0 &&
		SDL_BlitScaled(source, nullptr, target, nullptr) == 0;
	SDL_FreeSurface(source);
	return copied && SDL_UpdateWindowSurface(screen->window) == 0;
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

static inline Uint32 vision_sdl_pixel(VisionSdlWindow *screen, int x, int y) {
	SDL_Surface *surface = SDL_GetWindowSurface(screen->window);
	if (!surface || x < 0 || y < 0 || x >= surface->w || y >= surface->h || SDL_LockSurface(surface) != 0)
		return 0;
	const Uint8 *pixel = (const Uint8 *)surface->pixels + y * surface->pitch + x * surface->format->BytesPerPixel;
	Uint32 argb = 0;
	SDL_ConvertPixels(1, 1, surface->format->format, pixel, surface->pitch, SDL_PIXELFORMAT_ARGB8888, &argb, 4);
	SDL_UnlockSurface(surface);
	return argb | 0xff000000u;
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
