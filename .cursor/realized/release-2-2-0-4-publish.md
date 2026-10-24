# Plan: Vision 2.2.0 - Step 4: publish

> Status: ✅ Completed
> Parent: [overview](release-2-2-0-overview.md)
> Prerequisite: Step 3

## TL;DR

Publish Vision 2.2.0 on GitHub with established headings and user-approved notes; hand final haxelib command to user.

## Iteration Bootstrap

- Iteration slug: release-2-2-0
- Required evidence: merge SHAs, release note input, CI results, package hash, published release metadata
- Artifacts to verify: changelog, package manifest, release body, tag

## Reference Pattern

GitHub Vision 2.1.0 release

## Steps

### 1. Prepare the scoped change

Publish Vision 2.2.0 on GitHub with established headings and user-approved notes; hand final haxelib command to user.

### 2. Verify the concrete result

Tag targets release main commit; published body and assets match; haxelib submission command printed but not executed.

## Verification

Tag targets release main commit; published body and assets match; haxelib submission command printed but not executed.

## Completed evidence

Published [Vision 2.2.0](https://github.com/ShaharMS/Vision/releases/tag/2.2.0) at 2026-10-24T13:22:45Z (2026-10-24, Asia/Jerusalem). It is the latest full release, not a draft or prerelease. Lightweight tag `2.2.0` resolves to `2adc54e7b3a59e227a9d983b1e40a81d7e7f195d`, matching the previous tag convention.

The approved body uses the same New Features / Bugfixes & Tweaks headings, emoji, bold bullets and changelog links as Vision 2.1.0. Assets are vision-2.2.0.zip and its SHA256 checksum. The public release API and uploaded/downloaded asset bytes were verified.

### User-run final Haxelib command

```powershell
haxelib submit "C:\Users\shaha\Documents\GitHub\Vision\release\2.2.0\vision-2.2.0.zip"
```

The command was prepared in release/2.2.0/HAXELIB-SUBMIT.txt but was not executed. The user enters the Haxelib password interactively. No credential was requested or stored by this release task.
