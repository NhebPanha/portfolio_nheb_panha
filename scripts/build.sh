#!/usr/bin/env bash
# Builds the Flutter Web app into build/web (served by the Cloudflare worker as static assets).
# Installs a pinned Flutter SDK first when `flutter` isn't available (e.g. on Cloudflare's build machines).
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-3.47.5}"

if ! command -v flutter >/dev/null 2>&1; then
  FLUTTER_HOME="${FLUTTER_HOME:-$HOME/flutter}"
  if [ ! -x "$FLUTTER_HOME/bin/flutter" ]; then
    echo "Flutter not found. Installing Flutter $FLUTTER_VERSION into $FLUTTER_HOME ..."
    git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git "$FLUTTER_HOME"
  fi
  export PATH="$FLUTTER_HOME/bin:$PATH"
fi

flutter config --no-analytics >/dev/null 2>&1 || true
flutter --version
flutter pub get
flutter build web --release --no-wasm-dry-run
