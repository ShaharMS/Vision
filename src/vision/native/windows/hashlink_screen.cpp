#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#define HL_NAME(name) vision_screen_##name
#include <hl.h>
#include "D3D11Device.hpp"

enum {
    WINDOW_OPEN = 1,
    WINDOW_REPAINT = 2
};

struct ImageResource {
    void (*finalize)(ImageResource*);
    vision_d3d11::Texture* texture;
};

static void releaseImage(ImageResource* image) {
    if (!image || !image->texture) return;
    vision_d3d11::release(image->texture);
    image->texture = nullptr;
}

static ImageResource* ownImage(vision_d3d11::Texture* texture) {
    if (!texture) return nullptr;
    auto image = static_cast<ImageResource*>(hl_gc_alloc_finalizer(sizeof(ImageResource)));
    image->finalize = releaseImage;
    image->texture = texture;
    return image;
}

struct ScreenWindow {
    HWND native;
    vision_d3d11::WindowTarget* target;
};

HL_PRIM ScreenWindow* HL_NAME(open)(int x, int y, int width, int height, bool visible) {
    DWORD style = WS_OVERLAPPEDWINDOW;
    RECT bounds = {0, 0, width, height};
    if (!AdjustWindowRect(&bounds, style, FALSE)) return NULL;

    HWND window = CreateWindowExW(0, L"STATIC", L"Vision", style, x, y,
        bounds.right - bounds.left, bounds.bottom - bounds.top,
        NULL, NULL, GetModuleHandleW(NULL), NULL);
    if (!window) return nullptr;
    auto target = vision_d3d11::openWindow(window, width, height);
    if (!target) {
        DestroyWindow(window);
        return nullptr;
    }
    if (visible) ShowWindow(window, SW_SHOW);
    return new ScreenWindow{window, target};
}

HL_PRIM bool HL_NAME(set_bounds)(ScreenWindow* screen, int x, int y, int width, int height) {
    auto window = screen->native;
    if (!IsWindow(window)) return false;
    RECT bounds = {0, 0, width, height};
    DWORD style = (DWORD)GetWindowLongPtrW(window, GWL_STYLE);
    if (!AdjustWindowRect(&bounds, style, FALSE)) return false;
    if (!SetWindowPos(window, NULL, x, y, bounds.right - bounds.left,
        bounds.bottom - bounds.top, SWP_NOZORDER | SWP_NOACTIVATE)) return false;
    return (width == screen->target->width && height == screen->target->height)
        || vision_d3d11::resizeWindow(screen->target, width, height);
}

HL_PRIM bool HL_NAME(set_window_mode)(ScreenWindow* screen, int mode, bool was_fullscreen,
    int x, int y, int width, int height) {
    auto window = screen->native;
    if (!IsWindow(window)) return false;
    if (mode == 3) {
        MONITORINFO monitor = {sizeof(MONITORINFO)};
        if (!GetMonitorInfoW(MonitorFromWindow(window, MONITOR_DEFAULTTONEAREST), &monitor))
            return false;
        ShowWindow(window, SW_RESTORE);
        SetWindowLongW(window, GWL_STYLE, WS_POPUP | WS_VISIBLE);
        RECT rect = monitor.rcMonitor;
        return SetWindowPos(window, NULL, rect.left, rect.top, rect.right - rect.left,
            rect.bottom - rect.top, SWP_NOZORDER | SWP_FRAMECHANGED | SWP_SHOWWINDOW) != 0;
    }
    if (was_fullscreen) {
        SetWindowLongW(window, GWL_STYLE, WS_OVERLAPPEDWINDOW | WS_VISIBLE);
        RECT rect = {0, 0, width, height};
        if (!AdjustWindowRect(&rect, WS_OVERLAPPEDWINDOW, FALSE) ||
            !SetWindowPos(window, NULL, x, y, rect.right - rect.left, rect.bottom - rect.top,
                SWP_NOZORDER | SWP_FRAMECHANGED)) return false;
    }
    ShowWindow(window, mode == 2 ? SW_MAXIMIZE : mode == 1 ? SW_MINIMIZE : SW_RESTORE);
    return true;
}

HL_PRIM int HL_NAME(poll)(ScreenWindow* screen) {
    auto window = screen->native;
    int status = 0;
    MSG message;
    while (PeekMessageW(&message, NULL, 0, 0, PM_REMOVE)) {
        TranslateMessage(&message);
        DispatchMessageW(&message);
        if (message.hwnd == window && message.message == WM_PAINT)
            status |= WINDOW_REPAINT;
    }
    return IsWindow(window) ? status | WINDOW_OPEN : 0;
}

HL_PRIM bool HL_NAME(present)(ScreenWindow* screen, ImageResource* image) {
    return IsWindow(screen->native) && image && vision_d3d11::present(screen->target, image->texture);
}

HL_PRIM void HL_NAME(close)(ScreenWindow* screen) {
    vision_d3d11::closeWindow(screen->target);
    if (IsWindow(screen->native)) DestroyWindow(screen->native);
    delete screen;
}

HL_PRIM bool HL_NAME(available)() { return vision_d3d11::available(); }
HL_PRIM bool HL_NAME(synchronize)() { return vision_d3d11::synchronize(); }
HL_PRIM int HL_NAME(readback_count)() { return vision_d3d11::readbackCount(); }
HL_PRIM void HL_NAME(release)(ImageResource* image) { releaseImage(image); }

HL_PRIM ImageResource* HL_NAME(upload)(int width, int height, vbyte* bytes, int offset) {
    return ownImage(vision_d3d11::upload(width, height, bytes + offset));
}

HL_PRIM bool HL_NAME(download)(ImageResource* image, vbyte* bytes, int offset) {
    return vision_d3d11::download(image->texture, bytes + offset);
}

HL_PRIM bool HL_NAME(draw)(ImageResource* target, ImageResource* source, int x, int y, bool invert) {
    return vision_d3d11::draw(target->texture, source->texture, x, y, invert);
}

HL_PRIM ImageResource* HL_NAME(filter)(ImageResource* image, int width, int height, int mode, int value,
    double stepX, double stepY, int kernelWidth, int kernelHeight, int x, int y, int w, int h, vbyte* weights) {
    return ownImage(vision_d3d11::filter(image->texture, width, height, mode, value, stepX, stepY,
        kernelWidth, kernelHeight, x, y, w, h, weights));
}

#define _WINDOW _ABSTRACT(vision_screen_window)
#define _IMAGE _ABSTRACT(vision_d3d11_image)
DEFINE_PRIM(_WINDOW, open, _I32 _I32 _I32 _I32 _BOOL);
DEFINE_PRIM(_BOOL, set_bounds, _WINDOW _I32 _I32 _I32 _I32);
DEFINE_PRIM(_BOOL, set_window_mode, _WINDOW _I32 _BOOL _I32 _I32 _I32 _I32);
DEFINE_PRIM(_I32, poll, _WINDOW);
DEFINE_PRIM(_BOOL, present, _WINDOW _IMAGE);
DEFINE_PRIM(_VOID, close, _WINDOW);
DEFINE_PRIM(_BOOL, available, _NO_ARG);
DEFINE_PRIM(_BOOL, synchronize, _NO_ARG);
DEFINE_PRIM(_I32, readback_count, _NO_ARG);
DEFINE_PRIM(_VOID, release, _IMAGE);
DEFINE_PRIM(_IMAGE, upload, _I32 _I32 _BYTES _I32);
DEFINE_PRIM(_BOOL, download, _IMAGE _BYTES _I32);
DEFINE_PRIM(_BOOL, draw, _IMAGE _IMAGE _I32 _I32 _BOOL);
DEFINE_PRIM(_IMAGE, filter, _IMAGE _I32 _I32 _I32 _I32 _F64 _F64 _I32 _I32 _I32 _I32 _I32 _I32 _BYTES);
