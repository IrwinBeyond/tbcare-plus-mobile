# TBCare+

TBCare+ is a tuberculosis early-detection expert system mobile app built with **Flutter**. It provides symptom-based screening, certainty-factor assessment, and personalized health insights.

## Features

- **Authentication** — Login, registration, guest mode with Supabase JWT
- **Quick Check & Full Assessment** — Two-tier TB screening with wizard-guided forms
- **Expert System Scoring** — Cross-TB-type certainty factor calculation
- **Assessment History** — Session-grouped history with detailed symptom insights
- **Profile Management** — Edit profile, change password, profile picture upload

## Tech Stack

- **Framework**: Flutter (Dart 3.12+)
- **Auth**: Supabase JWT
- **HTTP**: `http` package
- **Storage**: `shared_preferences`
- **File Picker**: `file_picker`

## Getting Started

### Prerequisites

- Flutter SDK 3.22+
- Android Studio or Xcode

### Setup

```bash
git clone https://github.com/rizalmaulanaairlangga/tbcare-plus-mobile.git
cd tbcare-plus-mobile
flutter pub get
```

### Backend Configuration

Edit `lib/core/constants/app_constants.dart` to point to your backend. The default is the production Azure App Service URL. For local development, set `_useLocal = true`:

```dart
static const bool _useLocal = true; // Uses http://localhost:5181
```

### Run

```bash
flutter run
```

## Build Release

```bash
flutter build apk --split-per-abi
```

APKs output to `build/app/outputs/flutter-apk/`.

For keystore setup, see the [Flutter Android deployment guide](https://docs.flutter.dev/deployment/android).

## Project Structure

```
lib/
├── core/
│   ├── constants/    # API endpoints, config
│   ├── models/       # Data models, JSON serializers
│   ├── services/     # Storage, auth, API services
│   ├── theme/        # Colors, text styles, theme
│   └── widgets/      # Shared widgets (HomeHeader, AppTopBar)
├── features/
│   ├── auth/         # Cover, login, register pages
│   ├── home/         # Home dashboard
│   ├── assessment/   # Quick check & full assessment wizards
│   ├── result/       # Assessment results with scoring
│   ├── history/      # History list, detail, symptom insights
│   ├── profile/      # Profile view, edit, change password
│   └── about/        # About & help page
└── routes/           # Named route definitions
```
