# Plan: Manual Review Integration

> **Status**: 🔄 In progress
> **Prerequisite**: None — this is a standalone workflow update.
> **Next**: None — stop after the workflow and manual review capture are in place.

## TL;DR

Introduce a durable manual-review path that fits the existing Iterate review loop instead of living only in chat. Capture the current `cr.md` review as an ID-based manual review file, then update the agent prompts so future iterations can ingest, normalize, track, and close manual review findings until they are fully resolved.

## Steps

### 1. Capture the current manual CR as durable review data

Create a new repository file named `manual-reviewes.md` that records the review from `cr.md` in a durable, iteration-friendly structure.

Requirements:

- preserve all current review items from `cr.md`
- assign stable manual-review IDs to every actionable finding
- group findings by area without losing the original requested changes
- make the file usable as an input source for future iteration work rather than a one-off summary

### 2. Update the orchestration prompts for manual-review continuity

Update the relevant agent prompts so manual reviews can enter and stay in the execution loop cleanly.

At minimum:

- teach `Iterate` how to detect and route manual reviews alongside `@Inspect` output
- define where manual review findings live and how they should be treated in the loop
- ensure manual review findings get durable IDs, tracking, and closure behavior compatible with the packet flow
- make it explicit that the workflow should keep iterating on manual review findings until they are resolved, rebutted, or formally waived

Update other agents only when needed to keep the flow coherent.

### 3. Stop after workflow integration, not product implementation

Do not start resolving the feature-review findings in `cr.md` as code changes for Vision itself in this pass.

This plan is complete when:

- `manual-reviewes.md` exists with the current review recorded durably
- the agent prompt updates are in place
- the resulting workflow change is reviewed and closed out through the normal Iterate loop

## Verification

- The new `manual-reviewes.md` file exists and every manual review item has an ID.
- The updated agent prompts make it clear how manual reviews enter and remain in the Iterate workflow.
- Touched markdown files are diagnostics-clean.

## Iteration Bootstrap Metadata

- **Recommended iteration slug** — `manual-review-integration`
- **Evidence to preserve** — the captured manual review file, the updated agent prompt files, and clean markdown diagnostics for the touched scope
- **Review focus** — whether manual reviews are durable, ID-based, and unambiguously routed through the same approval or changes-requested loop as other review sources without accidentally starting product work
- **Commit guidance** — keep the durable manual-review file and the agent prompt changes together so the workflow change is reviewable as one coherent pass