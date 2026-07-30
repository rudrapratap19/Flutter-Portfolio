#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Downloading Flutter SDK..."
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable
fi

echo "Adding Flutter to PATH..."
export PATH="$PATH:`pwd`/flutter/bin"

echo "Running flutter doctor..."
flutter doctor -v

echo "Building Flutter web app..."
flutter build web --release
