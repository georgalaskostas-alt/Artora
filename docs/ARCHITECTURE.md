# Architecture (proposed)

- **UI:** SwiftUI, iOS/iPadOS.
- **Domain:** Lesson, LessonStep, LessonProgress, LearnerSettings; testable pure business rules.
- **Persistence:** SwiftData when minimum deployment target is finalized; prototype can use local lightweight storage.
- **Drawing:** PencilKit in a later milestone.
- **Capture:** AVFoundation/PhotosPicker, permissions and user control.
- **Vision:** Apple Vision/Core Image for on-device preprocessing, followed by evaluated comparison models.
- **AI:** Core ML if quality and device performance permit; opt-in remote inference later, never as implicit default.
- **Localization:** String Catalog (.xcstrings) for Greek/English.
- **Billing:** StoreKit 2 only after education value and trial flows are validated.
- **Security:** No secrets in repo, no silent recording, no unconsented uploads.

Proposed module boundaries:
App -> Presentation -> Domain <- Infrastructure.

Architecture decisions are provisional until a real Xcode build and device validation are completed.
