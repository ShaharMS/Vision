# Framework drawing smoke tests

Run the commands from the Vision repository root. The OpenFL and Heaps examples are small executable tests.

- Install Lime, OpenFL and hxcpp. Run `haxelib run openfl build tests/framework/project.xml windows -64` and run `bin/framework/openfl/windows/bin/VisionOpenFlSmoke.exe`. It checks the bitmap's contents and storage reuse during a frame event.
- Install Heaps and hlsdl. Compile with `haxe -lib vision -lib heaps -lib hlsdl -cp tests/framework -main HeapsDrawing --hl bin/framework/heaps.hl`. Run `hl bin/framework/heaps.hl` with SDL and the HashLink native libraries available. The test checks texture identity and captures pixels from the GPU texture before and after an edit.
- Compile the Flash smoke with `haxe -lib vision -cp tests/framework -main TargetSmoke --swf bin/framework/target.swf -D swf-header=64:64:30:000000`. In a Flash-compatible runtime a green frame indicates the image and bitmap shape checks passed.
- Generate HashLink/C with `haxe -lib vision -cp tests/framework -main TargetSmoke --hl bin/framework/hlc/main.c -D no-compilation -D hl-ver=1.16.0`. Link `main.c` against the matching HashLink C library and headers, with the generated directory on the include path. The executable prints `Image smoke passed` on success.
