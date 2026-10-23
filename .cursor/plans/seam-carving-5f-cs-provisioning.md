# Plan: Release audit - focused C# provisioning

> Status: Completed
> Parent: [overview](seam-carving-overview.md)

## TL;DR

Superseded C# job spent more than 17 minutes downloading the mono-complete bundle (170 packages, 80.8 MB). Install the compiler/runtime and compression assembly used by the suite instead, and bound provisioning and total job time.

## Reference Pattern

Existing Ubuntu Mono setup in .github/workflows/main.yml; hxcs compiler source selects mcs.

## Steps

### 1. Install the required Mono components

Use mono-runtime, mono-mcs, and libmono-system-io-compression4.0-cil without recommended packages.

### 2. Verify remote C# tests

Require successful C# compile/run in the final matrix and record evidence in closeout.

## Verification

Canceled run 40007517423 proves package downloads were advancing slowly rather than executing tests. hxcs CSharpCompiler source confirms support for mcs. Final CI runtime result remains required.
