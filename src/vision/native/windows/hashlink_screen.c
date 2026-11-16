#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#define HL_NAME(name) vision_screen_##name
#include <hl.h>

enum {
    WINDOW_OPEN = 1,
    WINDOW_REPAINT = 2
};

HL_PRIM HWND HL_NAME(open)(int x, int y, int width, int height, bool visible) {
    DWORD style = WS_OVERLAPPEDWINDOW;
    RECT bounds = {0, 0, width, height};
    if (!AdjustWindowRect(&bounds, style, FALSE)) return NULL;

    HWND window = CreateWindowExW(0, L"STATIC", L"Vision", style, x, y,
        bounds.right - bounds.left, bounds.bottom - bounds.top,
        NULL, NULL, GetModuleHandleW(NULL), NULL);
    if (window && visible) ShowWindow(window, SW_SHOW);
    return window;
}

HL_PRIM bool HL_NAME(set_bounds)(HWND window, int x, int y, int width, int height) {
    if (!IsWindow(window)) return false;
    RECT bounds = {0, 0, width, height};
    DWORD style = (DWORD)GetWindowLongPtrW(window, GWL_STYLE);
    if (!AdjustWindowRect(&bounds, style, FALSE)) return false;
    return SetWindowPos(window, NULL, x, y, bounds.right - bounds.left,
        bounds.bottom - bounds.top, SWP_NOZORDER | SWP_NOACTIVATE) != 0;
}

HL_PRIM bool HL_NAME(set_window_mode)(HWND window, int mode, bool was_fullscreen,
    int x, int y, int width, int height) {
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
    RECT client = {0};
    GetClientRect(window, &client);
    int rows = StretchDIBits(dc, 0, 0, client.right, client.bottom, 0, 0, width, height,
        pixels, &info, DIB_RGB_COLORS, SRCCOPY);
    ReleaseDC(window, dc);
    return rows != 0 && rows != GDI_ERROR;
}

HL_PRIM void HL_NAME(close)(HWND window) {
    if (IsWindow(window)) DestroyWindow(window);
}

#define _WINDOW _ABSTRACT(vision_screen_window)
DEFINE_PRIM(_WINDOW, open, _I32 _I32 _I32 _I32 _BOOL);
DEFINE_PRIM(_BOOL, set_bounds, _WINDOW _I32 _I32 _I32 _I32);
DEFINE_PRIM(_BOOL, set_window_mode, _WINDOW _I32 _BOOL _I32 _I32 _I32 _I32);
DEFINE_PRIM(_I32, poll, _WINDOW);
DEFINE_PRIM(_BOOL, present, _WINDOW _BYTES _I32 _I32 _I32);
DEFINE_PRIM(_VOID, close, _WINDOW);
