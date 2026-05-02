# Hough Harris Feature Detection

- Active plan: `.github/plans/hough-harris-feature-detection-overview.md`
- Plan scope: standardize the Hough family around standard lines, probabilistic segments, weighted and point-set line modes, Hough circles, and a documented Harris response-plus-corner API.
- Publication status: pending docs-only commit of the new plan set before propagating the branch tip through `dev` and `main`.
- Current repo anchor: `src/vision/algorithms/SimpleHough.hx` currently votes on integerized intercept strings and returns `Ray2D`; the public `Vision.hx` surface has no Hough wrapper yet.
- External research baseline: OpenCV parity targets are `HoughLines`, `HoughLinesP`, weighted line voting, point-set Hough lines, `HoughCircles`, `cornerHarris`, and Harris-adjacent corner selection controls such as relative quality thresholds, non-maximum suppression, and minimum-distance pruning.
- Key design choices already recorded in the overview: keep `Vision.hx` as the stable public surface, use `Matrix2D` for raw accumulators/response maps, and treat `SimpleHough` as a compatibility seam instead of the long-term API.
- Recommended iteration slug: `hough-harris-feature-detection`
- Expected verification evidence: filtered `haxe test.hxml` suite runs plus compile-only `haxe tests/ci/local-ci.hxml` runs with `VISION_CI_TARGETS='interp,js'`, `VISION_CI_COMPILE_ONLY='1'`, and `VISION_CI_SKIP_INSTALL='1'`.
- Next action for `@Iterate`: start with `.github/plans/hough-harris-feature-detection-1-foundation.md`, create the iteration packet directory, and keep the public API/compatibility decisions explicit in `decision-log.md` when implementation starts.