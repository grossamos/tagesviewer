# tagesviewer

tagesviewer is a Flutter app for reading [tagesschau.de](https://www.tagesschau.de), the German public broadcaster's news service. It scrapes the tagesschau.de homepage to show a list of current articles, and lets you tap through to read full stories including body text, images, and related articles. No account or API key is needed.

## Building

Requires [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.11.

### Linux

```bash
flutter pub get
flutter run -d linux
```

For a release build:

```bash
flutter build linux
# Binary: build/linux/x64/release/bundle/tagesviewer
```

### Android

Connect a device or start an emulator, then:

```bash
flutter pub get
flutter run
```

For a release APK:

```bash
flutter build apk
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### iOS

Untested. Standard Flutter iOS build process should apply.

## Licence

BSD 4-Clause — see [LICENCE](LICENCE).
