# STASH Android APK Build Guide

This guide explains how to build an Android APK for the STASH app.

## Method 1: Automatic Build with GitHub Actions (Recommended)

The easiest way to build your APK is through GitHub Actions:

### Steps:

1. **Push the workflow file to GitHub:**
   ```bash
   git add .github/workflows/build-apk.yml capacitor.config.json APK-BUILD-GUIDE.md
   git commit -m "add Android APK build workflow"
   git push origin main
   ```

2. **Trigger the build:**
   - Go to your GitHub repository: https://github.com/Rex-101/Stash
   - Click on "Actions" tab
   - Select "Build Android APK" workflow
   - Click "Run workflow" → "Run workflow"

3. **Download the APK:**
   - Wait for the build to complete (usually 5-10 minutes)
   - Click on the completed workflow run
   - Scroll down to "Artifacts"
   - Download "stash-android-apk"
   - Extract the ZIP file to get your APK

## Method 2: Build Locally with PWABuilder

### Prerequisites:
- Node.js 18+ installed
- Internet connection

### Steps:

1. **Install PWABuilder CLI:**
   ```bash
   npm install -g @pwabuilder/cli
   ```

2. **Package the APK:**
   ```bash
   pwa package https://stashdrop.vercel.app --platform android --packageId com.rex.stash --name "STASH" --output ./build
   ```

3. **Find your APK:**
   - The APK will be in the `./build` folder
   - Look for `*.apk` or `*.aab` files

## Method 3: Use PWABuilder Website (No Code)

1. Go to https://www.pwabuilder.com/
2. Enter your URL: `https://stashdrop.vercel.app`
3. Click "Start"
4. Click "Package for Stores"
5. Select "Android"
6. Configure options:
   - Package ID: `com.rex.stash`
   - App name: `STASH`
   - Host URL: `https://stashdrop.vercel.app`
7. Click "Generate"
8. Download the APK

## Method 4: Build with Capacitor (Advanced)

### Prerequisites:
- Android Studio installed
- Java JDK 11+ installed

### Steps:

1. **Install Capacitor:**
   ```bash
   npm install @capacitor/core @capacitor/cli
   npm install @capacitor/android
   ```

2. **Initialize Capacitor:**
   ```bash
   npx cap init "STASH" "com.rex.stash" --web-dir .
   ```

3. **Add Android platform:**
   ```bash
   npx cap add android
   ```

4. **Sync files:**
   ```bash
   npx cap sync
   ```

5. **Open in Android Studio:**
   ```bash
   npx cap open android
   ```

6. **Build in Android Studio:**
   - Click "Build" → "Build Bundle(s) / APK(s)" → "Build APK(s)"
   - APK will be in `android/app/build/outputs/apk/debug/`

## APK Configuration

Your app is configured with:
- **Package ID:** `com.rex.stash`
- **App Name:** STASH
- **URL:** https://stashdrop.vercel.app

## Installing the APK

1. Transfer the APK to your Android device
2. Enable "Install from Unknown Sources" in Settings
3. Open the APK file
4. Click "Install"

## Troubleshooting

### PWABuilder Issues:
- Make sure your PWA is accessible online
- Check that `manifest.json` is valid
- Ensure HTTPS is working

### GitHub Actions Issues:
- Check the Actions tab for error logs
- Verify your repository has Actions enabled
- Make sure the workflow file is in `.github/workflows/`

### Signing APK for Play Store:
To publish on Google Play Store, you need to sign your APK:

1. Generate a keystore:
   ```bash
   keytool -genkey -v -keystore stash-release.keystore -alias stash -keyalg RSA -keysize 2048 -validity 10000
   ```

2. Add to `capacitor.config.json`:
   ```json
   "android": {
     "buildOptions": {
       "keystorePath": "path/to/stash-release.keystore",
       "keystorePassword": "your-password",
       "keystoreAlias": "stash",
       "keystoreAliasPassword": "your-alias-password"
     }
   }
   ```

## Notes

- The generated APK is a TWA (Trusted Web Activity) wrapper around your PWA
- Users need internet connection to use the app (loads from your Vercel URL)
- For offline functionality, ensure your service worker caches necessary files
- The app icon comes from your `manifest.json` icons

## Support

For issues:
- PWABuilder: https://github.com/pwa-builder/PWABuilder
- Capacitor: https://capacitorjs.com/docs
