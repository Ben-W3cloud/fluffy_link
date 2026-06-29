#!/bin/bash
set -e

git clone https://github.com/flutter/flutter.git --depth 1 -b stable flutter-sdk

export PATH="$PWD/flutter-sdk/bin:$PATH"

flutter doctor
flutter pub get

flutter build web \
  --release \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY