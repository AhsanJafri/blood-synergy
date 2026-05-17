# Blood Synergy — reproducible Flutter Android builds in Docker (Linux hosts / CI).
#
# Not supported here (Apple / licensing):
#   - iOS and iOS Simulator require macOS + Xcode. Use a Mac or a macOS CI runner.
#
# Base image tags: https://github.com/cirruslabs/docker-images-flutter/pkgs/container/flutter
ARG FLUTTER_VERSION=stable
FROM ghcr.io/cirruslabs/flutter:${FLUTTER_VERSION}

WORKDIR /app

RUN yes | flutter doctor --android-licenses 2>/dev/null || true

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .
RUN flutter pub get

# Debug APK — no release keystore (see android/app/build.gradle.kts).
RUN flutter build apk --debug

# Optional APK copy after build:
#   id=$(docker create bloodsynergy:local) && docker cp "$id":/app/build/app/outputs/flutter-apk/app-debug.apk . && docker rm -v "$id"
CMD ["flutter", "doctor", "-v"]
