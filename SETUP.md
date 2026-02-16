# Habit Tracker - Complete Setup & Build Guide

## Quick Start 🚀

```bash
# 1. Navigate to project directory
cd habit_tracker

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

That's it! The app should now run on your connected device or emulator.

## Detailed Setup Instructions

### Step 1: Install Flutter

If you don't have Flutter installed:

1. Download Flutter SDK from https://flutter.dev/docs/get-started/install
2. Extract to a location on your machine
3. Add Flutter to your PATH
4. Run `flutter doctor` to verify installation

### Step 2: Install Dependencies

```bash
flutter pub get
```

This will install all required packages listed in `pubspec.yaml`.

### Step 3: Verify Setup

```bash
flutter doctor
```

Make sure you have:

- ✓ Flutter SDK
- ✓ Android toolchain (for Android development)
- ✓ Xcode (for iOS development - macOS only)
- ✓ Connected device or emulator

### Step 4: Run the App

**Option 1: Using Command Line**

```bash
flutter run
```

**Option 2: Using VS Code**

1. Open the project in VS Code
2. Press F5 or click "Run > Start Debugging"

**Option 3: Using Android Studio**

1. Open the project in Android Studio
2. Click the Run button or press Shift+F10

## Building for Release

### Android APK

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Google Play)
flutter build appbundle --release
```

Output location: `build/app/outputs/flutter-apk/app-release.apk`

### iOS IPA (macOS only)

```bash
# Build for iOS
flutter build ios --release
```

Then use Xcode to create an archive and export IPA.

## Project Configuration

### Android Configuration

File: `android/app/build.gradle`

```gradle
android {
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.yourcompany.habit_tracker"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
}
```

### iOS Configuration

File: `ios/Runner/Info.plist`

Update bundle identifier and app name as needed.

## Troubleshooting

### Common Issues

**1. "Failed to get dependencies"**

```bash
flutter clean
flutter pub get
```

**2. "Waiting for another flutter command to release the startup lock"**

```bash
killall -9 dart
flutter pub get
```

**3. Hive database errors**

- The Hive adapter is already generated in `lib/models/habit.g.dart`
- If you modify the Habit model, regenerate with:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**4. Android build errors**

- Make sure Android SDK is properly installed
- Update gradle if needed
- Check `android/app/build.gradle` for correct SDK versions

**5. iOS build errors (macOS)**

- Run `pod install` in the `ios/` directory
- Update CocoaPods if needed: `sudo gem install cocoapods`

## Code Generation

If you modify the Habit model and need to regenerate the Hive adapter:

```bash
# One-time build
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (automatically rebuilds on changes)
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## Performance Optimization

### Release Build Optimizations

The app is already configured for optimal release builds:

- Tree-shaking to remove unused code
- Obfuscation for code protection
- Minification for smaller app size

### Build Size

Expected sizes:

- Android APK: ~15-25 MB
- iOS IPA: ~25-40 MB

## Database

The app uses **Hive** for local storage:

- Database files are stored in app's documents directory
- Data persists between app restarts
- Automatic backup on device backup (if enabled)

Database location:

- Android: `/data/data/com.yourcompany.habit_tracker/app_flutter/`
- iOS: `~/Library/Application Support/`

## Environment Setup (Optional)

For different environments (dev, staging, prod):

```bash
# Development
flutter run --dart-define=ENV=dev

# Production
flutter run --dart-define=ENV=prod --release
```

## Upgrading Dependencies

To update all dependencies to their latest versions:

```bash
flutter pub upgrade
```

To update Flutter itself:

```bash
flutter upgrade
```

## App Signing (Production)

### Android

1. Create a keystore:

```bash
keytool -genkey -v -keystore ~/habit-tracker-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias habit-tracker
```

2. Create `android/key.properties`:

```
storePassword=<password>
keyPassword=<password>
keyAlias=habit-tracker
storeFile=<path-to-keystore>
```

3. Update `android/app/build.gradle` to use signing config

### iOS

1. Open project in Xcode: `open ios/Runner.xcworkspace`
2. Configure signing team and provisioning profile
3. Archive and submit to App Store

## Development Tools

### Recommended VS Code Extensions

- Flutter
- Dart
- Flutter Widget Snippets
- Error Lens
- GitLens

### Recommended Android Studio Plugins

- Flutter
- Dart
- Flutter Enhancement Suite

## Performance Profiling

```bash
# Run with performance overlay
flutter run --profile

# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

## Clean Build

If you encounter persistent build issues:

```bash
flutter clean
cd android && ./gradlew clean && cd ..
cd ios && rm -rf Pods Podfile.lock && pod install && cd ..
flutter pub get
flutter run
```

## Support

For issues or questions:

1. Check existing GitHub issues
2. Review Flutter documentation: https://flutter.dev/docs
3. Check Hive documentation: https://docs.hivedb.dev/

## Next Steps

After successful setup:

1. Customize app name and bundle ID
2. Add app icon using `flutter_launcher_icons`
3. Add splash screen
4. Configure Firebase (for future cloud features)
5. Set up CI/CD pipeline
6. Submit to app stores

---

Happy coding! 🎯
