# Plan: Release audit - cppia runtime diagnosis

> Status: In progress
> Parent: [overview](seam-carving-overview.md)

## TL;DR

With bootstrap repaired, cppia exposes existing Gaussian failures and segfaults after Cramer duplicate handling. Verify seam tests independently and test a no-inline compilation configuration before claiming cppia readiness.

## Reference Pattern

Existing java/JVM no-inline configuration and cppia run command in .github/workflows/main.yml.

## Steps

### 1. Compile cppia without optional compiler inlining

Align local runner target settings with GitHub CI (java, JVM, cppia).

### 2. Run seam slice before broad suite

Run the six new seam cases in a separate process, then require the full suite to pass.

## Verification

Remote run 40010003388 exposed Gaussian failures and exit 139 after Cramer tests; no exclusions or assertion changes are used. The next remote result decides whether this is a usable configuration.
