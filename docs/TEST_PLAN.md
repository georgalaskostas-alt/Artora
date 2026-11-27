# Test Plan

## Automated
1. Unit: lesson IDs unique, step ordering deterministic, catalog filtering and progress math.
2. Unit: completed lessons persist and reopen correctly.
3. UI: onboarding, browse, open lesson, next/back, complete, return home.
4. Localization: Greek and English strings present, layout adapts.

## Manual
- iPhone small/large display and iPad portrait/landscape.
- VoiceOver, reduced motion, Dynamic Type, color contrast.
- Flight mode lesson browsing and saved progress.
- Camera denied/revoked and user-cancelled flows.

## Research gate (future)
AI comparison must report per-category outcomes on diverse human drawings, including confidence and false-positive/negative cases. It must not imply expert-level correctness without evidence.

## CI
Add xcodebuild validation on a macOS runner once project files are present. No passing build is claimed until CI completes successfully.

## Reference comparison
Test identical, disjoint, near-neighbor and blank masks. On device verify orientation, lighting, scale and position using real paper sketches. Do not interpret pixel coverage as drawing skill.

## Alignment and recommendations
Verify translated masks normalize identically; reject blank masks; exclude completed lessons. Additional device validation: scale, aspect ratio, stray marks, shadows, rotation, and lesson recommendation navigation.

## Gallery
Verify persistence and deletion, empty input rejection, camera/studio saves, corrupted file handling, large collections and device backup behavior.

## Illustrated catalog
Verify one nonempty path per lesson step; manually check that each illustration matches both localized instructions.

## Coaching
Test low, mixed, high and invalid correspondence. Human review must check that advice is helpful, nonjudgmental and robust to photographic artifacts before release.

## Photo lessons
Verify blank rejection, invalid dimensions, cumulative edge masks, image orientation and navigation. Review real photographs for background clutter and pedagogical usefulness.
