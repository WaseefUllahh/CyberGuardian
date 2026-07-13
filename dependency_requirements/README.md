# Dependency Requirements and Run Guide

## Required tools
- Flutter SDK 3.11.4 or newer
- Dart SDK matching the Flutter version
- Android Studio or VS Code with Flutter extension
- Git
- Optional: Firebase CLI if you plan to sync Firebase configuration

## Project requirements
- Open the project folder at the Flutter root:
  - c:\Users\wajer danger\flutter_application_1\flutter_application_1
- Ensure the Flutter SDK is on your PATH
- Run the following commands from the project root

## Setup commands
```bash
flutter pub get
flutter pub upgrade
```

## Run commands
```bash
flutter clean
flutter pub get
flutter run
```

## Optional platform-specific checks
```bash
flutter doctor
flutter devices
```

## Notes
- The app depends on Firebase services, so Android/iOS config must be present and valid.
- If you see missing plugin errors, rerun `flutter pub get`.
- If you change dependencies, update the lockfile by running `flutter pub get`.
