# Artora — Master Plan

Updated: 2026-11-25

## Vision
An original drawing-learning experience on iPhone and iPad. Teach drawing on physical paper, progress from simple shapes to richer projects, then provide accurate, comprehensible optional feedback.

## Constraints
- Do not copy Simply Draw branding, artwork, lessons, screenshots, UI layouts or proprietary content.
- Respect users' privacy, especially children. Obtain explicit camera permission and consent before any cloud image transfer.
- Accessibility (VoiceOver, Dynamic Type, contrast), full Greek and English localization.
- Distinguish measured performance from unvalidated AI claims.

## Product milestones
P0 Foundation: repository documentation, SwiftUI application structure, local sample lessons, basic tests.
P1 Premium onboarding and home: age-neutral learner profile, lesson categories, progress cards, five original UI concepts.
P2 Guided lessons: incremental steps, instructions, lesson completion, offline content.
P3 Camera prototype: capture/import and perspective correction with permission, on-device image handling.
P4 Assessment R&D: reference alignment, shape/proportion metrics, confidence and clear limitations; benchmark against labeled real drawings.
P5 Digital studio: PencilKit canvas and Pencil support.
P6 Personalization: recommended learning paths, accessible UX, optional bilingual audio.
P7 Content engine, subscriptions and release readiness.

## Release gates
- No production claim of reliable grading without human-reviewed benchmark.
- No minor-directed analytics, ads or cloud upload without dedicated privacy review.
- Human-created or licensed lesson assets with provenance.
- Tests, accessibility and device QA before App Store submission.

## Initial acceptance
- App launches to an original localized lesson catalog.
- A user can open a lesson, navigate steps and mark it complete.
- State persists locally; basic unit tests verify lesson progress.
