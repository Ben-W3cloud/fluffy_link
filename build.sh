#!/bin/bash
set -e

echo "Cleaning previous builds..."
flutter clean

echo "Getting dependencies..."
flutter pub get

# 1. Load local .env variables into the shell environment if the file exists
if [ -f .env ]; then
    export $(cat .env | grep -v '#' | xargs)
fi

echo "Building Flutter Web for Release with Environment Variables..."

# 2. Compile and hardcode the variables into your output JavaScript files
flutter build web --release \
  --dart-define=API_KEY="$API_KEY" \
  --dart-define=API_URL="$apiUrl"

echo "Build complete! Variables securely baked into build/web/"
