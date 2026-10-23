# Plan: Seam carving — Step 1: algorithm

> Status: ✅ Completed
> Parent: [overview](seam-carving-overview.md)
> Prerequisite: None
> Next: Step 2

## TL;DR

Implement deterministic gradient-energy seam removal in SeamCarving; vertical then horizontal, reject enlargement and invalid dimensions.

## Iteration Bootstrap

- Iteration slug: seam-carving
- Required evidence: verification results recorded in plan
- Artifacts to verify: source, tests, documentation assets

## Reference Pattern

`src/vision/algorithms/Harris.hx`

## Steps

### 1. Implement scoped outcome

Implement deterministic gradient-energy seam removal in SeamCarving; vertical then horizontal, reject enlargement and invalid dimensions.

### 2. Verify and record evidence

Commit this completed step and push.

## Verification

haxe compile.hxml

Evidence: Haxe include compile succeeds (4.3.7). Installed missing format/utest dependencies and linked local vision checkout.
