<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/ee50fa53-f938-437e-b3c3-165a44d77c8e" /># NutriMind

NutriMind is a Flutter mobile app that helps users track their nutrition through AI-powered food scanning and a conversational chatbot. Users authenticate, scan meals to get nutritional insights, log meals to a history, and chat with an AI assistant for nutrition support  all wrapped in a localized (English/Arabic), animated, mobile-first UI.

## Features

- **Onboarding**  first-run walkthrough screens introducing the app.
- **Authentication**  email/password sign up & sign in, Google Sign-In, sign out, powered by Firebase Auth.
- **Home dashboard**  daily calorie/macro summary with a progress ring and quick action tiles.
- **Food scanner**  capture or pick a food photo, send it to an AI backend for analysis, and view a health score, macros, and nutritional breakdown.
- **Meal history**  locally persisted log of scanned/logged meals (via Hive) with a browsable history screen.
- **AI chat assistant**  text and image-based conversation with an AI nutrition assistant.
- **Profile & settings**  user stats, language picker (easy_localization), and account settings.
- **Localization**  English and Arabic support via `easy_localization` / `flutter_localizations`.

## Tech Stack

- **Framework:** Flutter (Dart SDK ^3.12.1)
- **State management:** flutter_bloc (Cubit)
- **Dependency injection:** get_it
- **Error handling:** dartz (`Either<Failure, T>`) with typed `Failure` classes
- **Backend/Auth/Storage:** Firebase (Auth, Cloud Firestore, Storage)
- **Networking:** Dio, calling n8n webhook workflows for chat and food-scanning AI
- **Local persistence:** Hive (meal log history), SharedPreferences
- **UI:** Google Fonts, flutter_animate, Lottie, flutter_screenutil (responsive sizing)
- **Other:** image_picker, speech_to_text, google_sign_in

## Architecture

The project follows Clean Architecture with strict layer separation, organized by feature:

```
lib/
  core/            # Shared code: theme, routing, DI, network helpers, meal_log module, widgets, utils
  features/
    <feature_name>/
      data/        # Data sources, models, repository implementations
      domain/      # Entities, repository interfaces, use cases (no Flutter imports)
      presentation/ # Screens, widgets, Cubits/states
```

Features: `onboarding`, `auth`, `home`, `scanner`, `chat`, `history`, `profile`, `shell`, `splash`.

- **Presentation** depends only on **domain** (via Cubits calling use cases).
- **Domain** defines repository contracts and use cases, returning `Either<Failure, T>`.
- **Data** implements repositories, mapping exceptions to `Failure`s and talking to Firebase/Dio/Hive.
- Dependencies are wired up in `core/di/injection_container.dart` using `get_it`.

## Getting Started

### Prerequisites

- Flutter SDK (Dart ^3.12.1)
- A configured Firebase project (`lib/firebase_options.dart`, `android/`/`ios/` Firebase config files)

### Setup

```bash
flutter pub get
flutter run
```

### Notes

- Chat and scanner features call n8n webhook endpoints (see `lib/core/constants/api_endpoints.dart`) for AI processing — these require the backend workflows to be reachable.
- Run tests with:

```bash
flutter test
```
