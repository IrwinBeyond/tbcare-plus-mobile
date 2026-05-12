# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- New **History Detail Page** to display comprehensive assessment results.
- Interactive symptom cards in history detail with expandable explanations.
- Filtered symptom insights to show only user-selected symptoms.
- Scattered aura animations and refined risk level cards on the **Cover Page**.
- Assets directory registration for `assets/images/` in `pubspec.yaml`.
- Navigation route for `history-detail`.

### Changed
- Refined **Home Page** UI by fixing Switch colors and removing redundant "See All" text.
- Updated **Profile Page** navigation index for consistency.
- Simplified **Profile Page** UI by removing unnecessary decorative elements.
- Updated route configuration to handle arguments for history details.

### Removed
- Page transition animations globally to provide instant page appearance.
- Custom slide transitions in HomeHeader and GuestBottomNav.
- Redundant "View Symptom Insights" button from Result Page (integrated into history).
- Decorative blur circles in Profile Page for a cleaner look.
