# Plan: Seam carving — Step 3: tests

> Status: Completed
> Parent: [overview](seam-carving-overview.md)
> Prerequisite: Step 2
> Next: Step 4

## TL;DR

Add semantic tests, registry and inventory ownership including optimal paths and horizontal parity.

## Iteration Bootstrap

- Iteration slug: seam-carving
- Required evidence: verification results recorded in plan
- Artifacts to verify: source, tests, documentation assets

## Reference Pattern

`tests/src/tests/HarrisTest.hx`

## Steps

### 1. Implement scoped outcome

Add semantic tests, registry and inventory ownership including optimal paths and horizontal parity.

### 2. Verify and record evidence

Commit this completed step and push.

## Verification

haxe test.hxml; local CI interp/js

Evidence: 6 focused tests pass including exhaustive enumeration on 12 fixtures; full interp suite passes 614/614. Local JS run revealed existing Node configuration gaps; addressed in release-readiness step.
