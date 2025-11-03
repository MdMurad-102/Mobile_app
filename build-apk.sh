#!/bin/bash

# Quick APK Builder for MyDietCoach
# Choose your build method

echo "📱 MyDietCoach APK Builder"
echo "=========================="
echo ""
echo "Select build method:"
echo "1) EAS Build (Cloud) - Recommended, no Android Studio needed"
echo "2) Local Build (Debug APK) - Quick testing"
echo "3) Local Build (Release APK) - Production"
echo "4) Check prerequisites"
echo "5) Exit"
echo ""

read -p "Enter choice [1-5]: " choice

case $choice in
    1)
        echo ""
        echo "🌐 Building with EAS (Cloud Build)..."
        echo ""
        
        # Check if EAS CLI is installed
        if ! command -v eas &> /dev/null
        then
            echo "Installing EAS CLI..."
            npm install -g eas-cli
        fi
        
        echo "Logging in to Expo..."
        eas login
        
        echo ""
        echo "Choose build profile:"
        echo "1) Development (for testing)"
        echo "2) Preview (APK for distribution)"
        echo "3) Production (AAB for Play Store)"
        read -p "Enter choice [1-3]: " build_profile
        
        case $build_profile in
            1)
                eas build --platform android --profile development
                ;;
            2)
                eas build --platform android --profile preview
                ;;
            3)
                eas build --platform android --profile production
                ;;
            *)
                echo "Invalid choice"
                exit 1
                ;;
        esac
        ;;
        
    2)
        echo ""
        echo "🔨 Building Debug APK locally..."
        echo ""
        
        # Check if android folder exists
        if [ ! -d "android" ]; then
            echo "Generating native Android project..."
            npx expo prebuild --platform android
        fi
        
        cd android
        echo "Building..."
        ./gradlew assembleDebug
        
        APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
        if [ -f "$APK_PATH" ]; then
            echo ""
            echo "✅ Build successful!"
            echo "📦 APK location: android/$APK_PATH"
            echo ""
            echo "Install on device: adb install $APK_PATH"
        else
            echo "❌ Build failed"
        fi
        ;;
        
    3)
        echo ""
        echo "🔨 Building Release APK locally..."
        echo ""
        
        # Check if android folder exists
        if [ ! -d "android" ]; then
            echo "Generating native Android project..."
            npx expo prebuild --platform android
        fi
        
        cd android
        echo "Building..."
        ./gradlew assembleRelease
        
        APK_PATH="app/build/outputs/apk/release/app-release.apk"
        if [ -f "$APK_PATH" ]; then
            echo ""
            echo "✅ Build successful!"
            echo "📦 APK location: android/$APK_PATH"
            echo ""
            echo "⚠️  Note: This APK is signed with debug key."
            echo "   For production, generate a release keystore."
        else
            echo "❌ Build failed"
        fi
        ;;
        
    4)
        echo ""
        echo "🔍 Checking prerequisites..."
        echo ""
        
        # Check Node.js
        if command -v node &> /dev/null
        then
            echo "✅ Node.js: $(node --version)"
        else
            echo "❌ Node.js not found"
        fi
        
        # Check npm
        if command -v npm &> /dev/null
        then
            echo "✅ npm: $(npm --version)"
        else
            echo "❌ npm not found"
        fi
        
        # Check Expo CLI
        if command -v expo &> /dev/null
        then
            echo "✅ Expo CLI: $(expo --version)"
        else
            echo "⚠️  Expo CLI not found globally (npx will be used)"
        fi
        
        # Check EAS CLI
        if command -v eas &> /dev/null
        then
            echo "✅ EAS CLI: $(eas --version)"
        else
            echo "⚠️  EAS CLI not found"
        fi
        
        # Check Java (for local builds)
        if command -v java &> /dev/null
        then
            echo "✅ Java: $(java -version 2>&1 | head -n 1)"
        else
            echo "⚠️  Java not found (needed for local builds)"
        fi
        
        # Check ANDROID_HOME
        if [ -n "$ANDROID_HOME" ]; then
            echo "✅ ANDROID_HOME: $ANDROID_HOME"
        else
            echo "⚠️  ANDROID_HOME not set (needed for local builds)"
        fi
        
        echo ""
        echo "📚 Backend Status:"
        
        # Check if backend is running
        if curl -s http://localhost:3000/health > /dev/null; then
            echo "✅ Backend server running at localhost:3000"
        else
            echo "⚠️  Backend server not running"
        fi
        
        echo ""
        echo "Recommendation:"
        echo "- For easiest build: Use Option 1 (EAS Build)"
        echo "- For local testing: Use Option 2 (Debug APK)"
        ;;
        
    5)
        echo "Goodbye!"
        exit 0
        ;;
        
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "✨ Done!"
