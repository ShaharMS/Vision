# Vision documentation examples

Start with the [image API guide](image-api.md) for pixel editing, browser drawing, framework adapters, and a standalone Windows window.

## Carve documentation images

Reproduce the examples from the existing Spacebubble Valve image:

```powershell
haxe -cp src -cp tools/docs -lib format --run CarveExamples path/to/valve-original.png bin/carve-examples
```

The source is 150x112. Outputs are 112x112 (38 vertical seams) and 150x84 (28 horizontal seams), generated through `Vision.carve`.

Hosted comparison: https://spacebubble-io.pages.dev/vision/docs/carve.html

Images are stored in ShaharMS/spacebubble.io under `vision/docs/`, alongside the original. Publication and hash/visual verification evidence is recorded in the completed documentation plan.
