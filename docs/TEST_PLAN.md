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
