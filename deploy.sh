#!/bin/bash

echo "Building Flutter web app..."
flutter clean
flutter pub get
flutter build web --release --web-renderer canvaskit

echo "Build completed successfully!"
echo "To deploy:"
echo "1. Run: vercel --prod"
echo "2. Or connect your GitHub repo to Vercel for automatic deployments"