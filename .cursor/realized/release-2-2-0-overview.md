# Plan: Vision 2.2.0 release

## Status: ✅ All steps completed

Merge the qualified feature work, restore the historical changelog/release-note styles, publish the GitHub release, and prepare the exact Haxelib submission command for the user. On 2026-10-24 the user approved the proposed release-note wording and emphasis: Seam carving, Hough line/circle detection, Harris corners, higher-quality resizing, modern image I/O, and cross-target reliability. The final Haxelib command must not run here.

## Sub-plans

1. [draft](release-2-2-0-1-draft.md)
2. [integration](release-2-2-0-2-integration.md)
3. [package](release-2-2-0-3-package.md)
4. [publish](release-2-2-0-4-publish.md)

## Decisions

- Preserve merge commits and per-step history.
- Merge chain: #54 into Hough/Harris, #53 into dev, release documentation into dev, then dev into main.
- GitHub tag/name: 2.2.0 / Vision 2.2.0, matching previous releases.
- GitHub body uses New Features and Bugfixes & Tweaks with the existing emoji and changelog links.
- No Haxelib upload, credential entry, or password request.

## Released result

- GitHub: https://github.com/ShaharMS/Vision/releases/tag/2.2.0.
- Tag/release commit: 2.2.0 / 2adc54e7b3a59e227a9d983b1e40a81d7e7f195d.
- Main release CI: all twelve jobs pass in run 40097512192.
- Package SHA256: dfebc39e8f79e2e5885de9f13d1fe36a3c974bc51e725ae248ded22ecb447cc2.
- User-approved notes preserve the historical release style.
- Haxelib submission is intentionally delegated to the user; exact command and verified package are ready.
