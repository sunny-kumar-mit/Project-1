#!/bin/bash

echo "🚀 Starting Flutter web build..."

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please ensure Flutter is installed and in PATH."
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build for web
echo "🏗️ Building for web with CanvasKit..."
flutter build web --release --web-renderer canvaskit --dart-define=FLUTTER_WEB_CANVASKIT_URL=/canvaskit/

echo "✅ Build completed successfully!"
echo "📁 Output directory: build/web"