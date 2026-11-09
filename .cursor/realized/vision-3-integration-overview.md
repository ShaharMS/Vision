# Plan — Vision 3 backend integration

## Status

✅ All steps completed

Keep the existing image and algorithm calls. Move the backend code into existing package boundaries, attach device storage explicitly where a host is available, and use CPU storage for operations with no eligible implementation. Add native drawing and document the resulting API.

## Sub-plans

1. [Fit the backend files into the existing data, tools and format packages.](vision-3-integration-1-library-layout.md)
2. [Preserve packed bytes and alias behavior while adding an optional device backing.](vision-3-integration-2-image-backing.md)
3. [Route exact whole-image operations through attached storage and retain the current CPU implementations.](vision-3-integration-3-operation-dispatch.md)
4. [Draw ordinary Vision images through a standalone native host and qualify its fallback.](vision-3-integration-4-native-drawing.md)
5. [Show ordinary and accelerated usage through runnable examples and qualify the targets.](vision-3-integration-5-examples-and-tests.md)

## Qualified scope

- The regular Vision calls dispatch whole-image inversion, simple grayscale and black-and-white thresholding to an attached WebGL image or the optional native C library. CPU execution covers views, other algorithms and builds without a matching backend.
- WebGL attachment holds the current pixels on a texture after an operation. CPU reads materialize the latest result, writes invalidate the device copy, and writable packed bytes release the device attachment.
- Windows hxcpp and HashLink can draw and present an ordinary Vision image through WebGPU or GDI. The standalone renderer composites on the CPU before presentation.
- Public data types use the existing ds package. Platform implementation files use the existing formats package. Graphics fixtures and instructions live in tests/ci.
