# 🚀 APK Build Guide for MyDietCoach

## Prerequisites Checklist

- [ ] Node.js and npm installed
- [ ] Expo CLI installed
- [ ] Backend deployed to cloud (Railway, Render, Heroku, etc.)
- [ ] Production API URL configured in `service/api.ts`

---

## Option 1: Build with EAS Build (Recommended - Cloud Build)

### Step 1: Install EAS CLI
```bash
npm install -g eas-cli
```

### Step 2: Login to Expo
```bash
eas login
```

### Step 3: Configure EAS Build
```bash
eas build:configure
```

### Step 4: Build APK
```bash
# Build APK for Android (development client)
eas build --platform android --profile preview

# Or for production APK
eas build --platform android --profile production
```

### Step 5: Download APK
- Check build status on Expo dashboard
- Download APK when ready
- Install on Android device

**Pros:**
- ✅ No Android Studio required
- ✅ Builds in cloud
- ✅ Easy to use
- ✅ Free tier available

**Cons:**
- ⏱️ Build queue time
- 🌐 Requires internet

---

## Option 2: Build Locally with Android Studio

### Step 1: Prerequisites
1. Install Android Studio
2. Install Android SDK (API 34)
3. Set ANDROID_HOME environment variable
4. Accept Android licenses:
   ```bash
   cd ~/Library/Android/sdk/tools/bin
   ./sdkmanager --licenses
   ```

### Step 2: Prebuild Native Projects
```bash
npx expo prebuild --platform android
```

### Step 3: Build APK
```bash
cd android
./gradlew assembleRelease
```

### Step 4: Find Your APK
Location: `android/app/build/outputs/apk/release/app-release.apk`

**Pros:**
- ✅ No build limits
- ✅ Works offline
- ✅ Full control

**Cons:**
- ❌ Requires Android Studio setup
- ❌ More complex
- ❌ Large download (~3GB)

---

## Option 3: Quick Test Build (Debug APK)

For testing purposes, build a debug APK:

```bash
# Prebuild if needed
npx expo prebuild --platform android

# Build debug APK
cd android
./gradlew assembleDebug
```

Debug APK location: `android/app/build/outputs/apk/debug/app-debug.apk`

---

## 🔥 CRITICAL: Backend Configuration for Production

### Current Issue
Your app points to `localhost:3000` in production, which won't work on real devices!

### Step 1: Deploy Backend

**Recommended Services (Free Tier Available):**

1. **Railway** (Easiest)
   ```bash
   # Install Railway CLI
   npm install -g railway
   
   # Login and deploy
   cd backend
   railway login
   railway init
   railway up
   ```

2. **Render**
   - Create account at render.com
   - Connect GitHub repo
   - Add PostgreSQL database
   - Deploy backend

3. **Heroku**
   ```bash
   # Install Heroku CLI
   brew install heroku/brew/heroku
   
   # Deploy
   cd backend
   heroku login
   heroku create mydietcoach-api
   heroku addons:create heroku-postgresql:essential-0
   git push heroku main
   ```

### Step 2: Update API URL

Edit `service/api.ts`:
```typescript
const API_URL = __DEV__
    ? 'http://localhost:3000/api'  // Development
    : 'https://your-deployed-backend.railway.app/api'; // Production
```

### Step 3: Update Environment Variables

In your deployed backend, set:
```
DATABASE_URL=postgresql://user:pass@host:5432/dbname
NODE_ENV=production
PORT=3000
```

---

## 📝 Before Building Production APK

### 1. Update Package Identifier (Optional)
Edit `app.json`:
```json
{
  "android": {
    "package": "com.yourcompany.mydietcoach"
  }
}
```

### 2. Generate Release Keystore (For Production)

Currently using debug keystore. For production:

```bash
cd android/app
keytool -genkeypair -v -storetype PKCS12 -keystore mydietcoach-release.keystore -alias mydietcoach -keyalg RSA -keysize 2048 -validity 10000
```

Update `android/app/build.gradle`:
```groovy
signingConfigs {
    release {
        storeFile file('mydietcoach-release.keystore')
        storePassword 'YOUR_STORE_PASSWORD'
        keyAlias 'mydietcoach'
        keyPassword 'YOUR_KEY_PASSWORD'
    }
}
```

### 3. Update Version
Edit `app.json`:
```json
{
  "version": "1.0.0",
  "android": {
    "versionCode": 1
  }
}
```

---

## 🧪 Testing Your APK

1. **Enable "Install from Unknown Sources"** on Android device
2. Transfer APK to device
3. Install and test
4. Check if backend connection works
5. Test all features

---

## 🐛 Troubleshooting

### Build Fails
```bash
# Clear cache and rebuild
cd android
./gradlew clean
./gradlew assembleRelease
```

### Cannot Connect to Backend
- Check if backend is deployed and accessible
- Verify API_URL in `service/api.ts`
- Check network permissions in app

### APK Won't Install
- Check Android version compatibility (minSdkVersion: 23 = Android 6.0+)
- Enable "Unknown Sources" in device settings
- Try debug APK first

---

## 📊 Current Configuration Summary

| Component | Status | Notes |
|-----------|--------|-------|
| Frontend Setup | ✅ Ready | Expo + React Native configured |
| Android Config | ✅ Ready | Build files present |
| Backend Server | ⚠️ Local Only | Needs cloud deployment |
| Production API | ❌ Not Set | Update required |
| Keystore | ⚠️ Debug Only | Generate release keystore |
| Firebase | ✅ Optional | Already configured in dependencies |

---

## 🎯 Recommended Path

### For Quick Testing:
1. Use **Option 3** (Debug APK) - No backend needed for initial testing
2. Test locally connected to your computer's backend

### For Production Release:
1. Deploy backend to Railway/Render
2. Update production API URL
3. Generate release keystore
4. Build with **EAS Build (Option 1)**
5. Test thoroughly before distribution

---

## 📞 Need Help?

Common commands:
```bash
# Check Expo status
npx expo doctor

# Check Android setup
npx expo prebuild --platform android --clean

# Test build without installing
cd android && ./gradlew assembleRelease --dry-run
```

---

**Last Updated:** Based on project analysis on November 3, 2025
