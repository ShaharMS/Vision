# Timeline

| Sequence | Actor | Event | Related file | Notes |
|----------|-------|-------|--------------|-------|
| 1 | `@Iterate` | `Bootstrap iteration directory` | `.github/iterations/manual-utest-migration/run-ledger.md` | `Selected the first step from the attached manual-utest-migration overview and created the packet set.` |
| 2 | `@Index` | `Indexed bootstrap state for resume` | `.github/agent-progress/manual-utest-migration.md` | `Confirmed the full packet set exists, the active scope is step 1 cutover, and the next action is to capture git baseline state before delegating implementation.` |
| 3 | `@Implement` | `Completed step 1 cutover implementation pass` | `.github/iterations/manual-utest-migration/implementation-handoff.md` | `Promoted tests/generated/src into tests/src, repointed test.hxml/LocalCi/GitHub Actions, added manual-test-inventory.json, updated tests/README.md, and validated with haxe test.hxml plus the documented LocalCi env-var fallback.` |
| 4 | `@Inscribe` | `Committed step 1 cutover on feature branch` | `.github/iterations/manual-utest-migration/commit-packet.md` | `Created feature/manual-utest-migration-1-cutover, packaged the cutover as one commit, and kept the pre-existing untracked .github/plans/manual-utest-migration*.md files out of scope.` |
