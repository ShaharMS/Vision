#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#define HL_NAME(name) vision_screen_##name
#include <hl.h>

enum {
    WINDOW_OPEN = 1,
    WINDOW_REPAINT = 2
};

HL_PRIM HWND HL_NAME(open)(int x, int y, int width, int height, bool visible) {
    DWORD style = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX;
    RECT bounds = {0, 0, width, height};
    if (!AdjustWindowRect(&bounds, style, FALSE)) return NULL;

    HWND window = CreateWindowExW(0, L"STATIC", L"Vision", style, x, y,
        bounds.right - bounds.left, bounds.bottom - bounds.top,
        NULL, NULL, GetModuleHandleW(NULL), NULL);
    if (window && visible) ShowWindow(window, SW_SHOW);
    return window;
}

HL_PRIM int HL_NAME(poll)(HWND window) {
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

HL_PRIM bool HL_NAME(present)(HWND window, vbyte *pixels, int length, int width, int height) {
    if (!IsWindow(window) || !pixels || width <= 0 || height <= 0 || length < 0 ||
        (uint64_t)width * height * 4 != (uint64_t)length)
        return false;

    HDC dc = GetDC(window);
    if (!dc) return false;

    BITMAPINFO info = {0};
    info.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
    info.bmiHeader.biWidth = width;
    info.bmiHeader.biHeight = -height;
    info.bmiHeader.biPlanes = 1;
    info.bmiHeader.biBitCount = 32;
    int rows = StretchDIBits(dc, 0, 0, width, height, 0, 0, width, height,
        pixels, &info, DIB_RGB_COLORS, SRCCOPY);
    ReleaseDC(window, dc);
    return rows != 0 && rows != GDI_ERROR;
}

HL_PRIM void HL_NAME(close)(HWND window) {
    if (IsWindow(window)) DestroyWindow(window);
}

#define _WINDOW _ABSTRACT(vision_screen_window)
DEFINE_PRIM(_WINDOW, open, _I32 _I32 _I32 _I32 _BOOL);
DEFINE_PRIM(_I32, poll, _WINDOW);
DEFINE_PRIM(_BOOL, present, _WINDOW _BYTES _I32 _I32 _I32);
DEFINE_PRIM(_VOID, close, _WINDOW);
