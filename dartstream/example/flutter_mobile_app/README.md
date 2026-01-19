Flutter Mobile App

This Flutter app supports iOS, Web, and Android. This guide shows how to set up and run it from scratch on macOS or Windows.

1. Prerequisites
macOS
* Homebrew (package manager)
* Flutter SDK
* Xcode (for iOS)
* CocoaPods (for iOS dependencies)
* Chrome (for web)
* Android Studio (optional, for Android)
Windows
* Flutter SDK
* Chrome (for web)
* Android Studio (for Android)

2. Install Tools
2.1 macOS

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install flutter
brew install cocoapods
sudo xcodebuild -license accept
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
Add Flutter and CocoaPods to PATH (if needed):

echo 'export PATH="$PATH:/opt/homebrew/bin:/opt/homebrew/opt/ruby/bin"' >> ~/.zshrc
source ~/.zshrc
2.2 Windows
* Install Flutter: https://docs.flutter.dev/get-started/install/windows
* Install Android Studio: https://developer.android.com/studio
* Install Chrome (for web testing)

3. Get the App Code
Clone the repo or copy the project folder:

cd dartstream-opensource/dartstream/example/flutter_mobile_app

4. Prepare Flutter Project

flutter clean       # remove old build artifacts
flutter pub get     # install dependencies

5. iOS Setup (macOS Only)

cd ios
pod install         # install iOS dependencies
cd ..
⚠️ Notes:
* Ensure pod is in your PATH (export PATH="/opt/homebrew/bin:$PATH" if needed).
* Info.plist allows HTTP requests in development.

6. Launch iOS Simulator (macOS Only)

flutter emulators --launch apple_ios_simulator
flutter devices
flutter run -d ios

7. Run on Web

flutter run -d chrome

8. Run on Android

flutter devices
flutter run -d <android_device_id>

9. Quick Full Command Sequence (macOS)

# One-command setup and run for macOS
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install flutter cocoapods
sudo xcodebuild -license accept
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
export PATH="$PATH:/opt/homebrew/bin:/opt/homebrew/opt/ruby/bin"

cd dartstream-opensource/dartstream/example/flutter_mobile_app
flutter clean
flutter pub get
cd ios && pod install && cd ..

# Run on iOS simulator
flutter emulators --launch apple_ios_simulator
flutter run -d ios

# Or run on web
flutter run -d chrome

# Or Android
flutter run -d <android_device_id>

10. Quick Setup for Windows

cd dartstream-opensource/dartstream/example/flutter_mobile_app
flutter clean
flutter pub get

# Run web
flutter run -d chrome

# Run Android
flutter devices
flutter run -d <android_device_id>
⚠️ iOS is not supported on Windows.

11. Common Issues
Problem	Solution
No devices found	Launch emulator: flutter emulators --launch apple_ios_simulator (macOS) or Android emulator (Windows/macOS)
pod: command not found	Add CocoaPods to PATH: export PATH="/opt/homebrew/bin:$PATH" (macOS)
HTTP requests fail on iOS	Dev HTTP allowed in Info.plist; ensure backend is reachable
Flutter packages outdated	Run flutter pub get and check flutter pub outdated
✅ Following this README, anyone can set up and run your Flutter app on macOS or Windows.
