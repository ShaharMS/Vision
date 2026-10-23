# Plan: Seam carving and 2.2.0 readiness

## Status: In progress

Add classic Avidan-Shamir seam removal, generated documentation and release verification. Shrinking only; new image returned; RGB gradient energy; deterministic ties; width removed before height. No release publishing.

## Sub-Plans (execute in order)

1. [Step 1: algorithm](seam-carving-1-algorithm.md)
2. [Step 2: api](seam-carving-2-api.md)
3. [Step 3: tests](seam-carving-3-tests.md)
4. [Step 4: documentation](seam-carving-4-documentation.md)
5. [Step 5: release-readiness](seam-carving-5-release-readiness.md)

Release-audit findings require two focused follow-ups: [Node CI](seam-carving-5a-node-ci.md) and [Node runtime](seam-carving-5b-node-runtime.md), before final readiness closeout.

## Current outcome

Implementation, behavioral tests, generated imagery and publishing are complete. Release-readiness verification found an unresolved cppia host/runtime failure in the existing broad suite. Six standalone seam cases pass on cppia; eleven other target jobs pass. Keep this overview in progress pending the full cppia result or an explicit release-support decision.

Additional audit steps: [Neko](seam-carving-5c-neko-ci.md), [quiet mode](seam-carving-5d-quiet-compile.md), [hxcpp bootstrap](seam-carving-5e-cppia-bootstrap.md), [Mono setup](seam-carving-5f-cs-provisioning.md), [cppia runtime blocker](seam-carving-5g-cppia-runtime.md).
