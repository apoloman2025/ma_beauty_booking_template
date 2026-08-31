#!/bin/bash
set -e

if ! command -v flutter &> /dev/null; then
  echo ">>> Downloading Flutter SDK on Vercel..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 _flutter
  export PATH="$PATH:$(pwd)/_flutter/bin"
fi

flutter --version
flutter config --no-analytics
flutter pub get
flutter build web --release --no-tree-shake-icons
