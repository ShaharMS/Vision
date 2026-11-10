# Plan — Screen drawing API

## Status

✅ All steps completed

Use one public drawing destination for a browser canvas or a standalone desktop window. ImageTools drops its global drawing helper. The existing graphics classes become internal.

## Sub-plans

1. [Introduce Screen and remove ImageTools.addToScreen](screen-1-public-api.md)
2. [Wire the native position and portable desktop host](screen-2-desktop.md)
3. [Rewrite the public drawing examples around Screen](screen-3-examples.md)
