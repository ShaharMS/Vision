# Standalone native WebGPU probe

This Windows smoke test calls the same C surface probe from Haxe C++ and HashLink. It creates a hidden Win32 window, selects an adapter for that surface, clears and presents a frame, and releases the resources.

Use an x64 Native Tools prompt with the Windows x64 MSVC build of [wgpu-native v29.0.1.1](https://github.com/gfx-rs/wgpu-native/releases/tag/v29.0.1.1), HashLink 1.16, and hxcpp 4.3.2. Set `VISION_WGPU`, `VISION_HL`, and `VISION_HXCPP` to the extracted or installed roots.

```bat
set "VISION_PROBE_SOURCE=%CD%\tests\ci"
mkdir bin\native-webgpu
pushd bin\native-webgpu
cl /nologo /O2 /std:c11 /c /I"%VISION_WGPU%\include" "%VISION_PROBE_SOURCE%\webgpu-probe.c"
cl /nologo /O2 /std:c11 /LD /I"%VISION_HL%\include" "%VISION_PROBE_SOURCE%\webgpu-probe-hl.c" webgpu-probe.obj "%VISION_WGPU%\lib\wgpu_native.dll.lib" user32.lib /link /out:vision_gpu.hdll
cl /nologo /O2 /LD /I"%VISION_HXCPP%\include" "%VISION_PROBE_SOURCE%\webgpu-probe-cpp.cpp" webgpu-probe.obj "%VISION_WGPU%\lib\wgpu_native.dll.lib" user32.lib /link /out:vision_gpu.ndll
copy "%VISION_WGPU%\lib\wgpu_native.dll" .
popd
haxe -lib vision -cp tests/ci -main NativeWebGpuProbe --hl bin/native-webgpu/probe.hl -D vision_native_probe -D hl-ver=1.16.0
haxe -lib vision -cp tests/ci -main NativeWebGpuProbe --cpp bin/native-webgpu/cpp -D vision_native_probe -D HXCPP_M64
pushd bin\native-webgpu
"%VISION_HL%\hl.exe" probe.hl
copy vision_gpu.ndll cpp
copy wgpu_native.dll cpp
pushd cpp
NativeWebGpuProbe.exe
popd
popd
```

Omit `-D vision_native_probe` to build the same Haxe smoke without a WebGPU dependency. The CPU-only binary checks image creation, pixel editing and readback.
