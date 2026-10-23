# Plan: Seam carving — Step 4: documentation

> Status: Completed
> Parent: [overview](seam-carving-overview.md)
> Prerequisite: Step 3
> Next: Step 5

## TL;DR

Generate Valve examples using the actual API, publish to Spacebubble and verify bytes and browser rendering.

## Iteration Bootstrap

- Iteration slug: seam-carving
- Required evidence: verification results recorded in plan
- Artifacts to verify: source, tests, documentation assets

## Reference Pattern

`src/vision/Vision.hx`

## Steps

### 1. Implement scoped outcome

Generate Valve examples using the actual API, publish to Spacebubble and verify bytes and browser rendering.

### 2. Verify and record evidence

Commit this completed step and push.

## Verification

Reproduce PNGs; verify hosted images visually

Evidence: CarveExamples generated 112x112 and 150x84 PNGs from the 150x112 Valve source. Published to ShaharMS/spacebubble.io commits e9bc05b / 7f0ad4d. Production GET returns image/png with byte-identical SHA256 845898d65d6786f5e866f78b93bf9de841d75a448b366c7a5f96d278207aebbf (width), ada8c1fd4ed13c54199cccb2e20c321b4a0415b4be673ac7c54412c1fba2d140 (height). Browser comparison visually confirms all three images loaded; label encoding fixed in follow-up.
