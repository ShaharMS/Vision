# Plan: Vision 2.2.0 - Step 1: draft

> Status: Completed
> Parent: [overview](release-2-2-0-overview.md)
> Prerequisite: None

## TL;DR

Prepare release notes and changelog in the established styles; record merge inputs and package verification.

## Iteration Bootstrap

- Iteration slug: release-2-2-0
- Required evidence: merge SHAs, release note input, CI results, package hash, published release metadata
- Artifacts to verify: changelog, package manifest, release body, tag

## Reference Pattern

CHANGELOG.md and GitHub Vision 2.1.0 release body

## Steps

### 1. Prepare the scoped change

Prepare release notes and changelog in the established styles; record merge inputs and package verification.

### 2. Verify the concrete result

Compare headings, bold bullets, scope against 2.1.0..HEAD; JSON metadata check.

## Verification

Compare headings, bold bullets, scope against 2.1.0..HEAD; JSON metadata check.

Evidence: Preserved all 2.1.0-and-earlier changelog bytes; new entries use module headings and bold bullets. GitHub draft uses the previous release headings, emoji and changelog links. #54 merged at a439049; #53 merged at 3c186e7 after confirming its source tree matches the previously verified feature tree. The user approved the proposed wording and emphasis on 2026-10-24; haxelib.json uses that exact summary.
