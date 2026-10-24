# Plan: Vision 2.2.0 release

## Status: In progress

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
