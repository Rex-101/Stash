# PWA (Progressive Web App) - How STASH Works

## What is a PWA?

STASH is a **Progressive Web App (PWA)**, not a traditional native app. Here's what that means:

### PWA vs Native App

**Traditional Native Apps:**
- Downloaded from App Store/Play Store
- Large file sizes (50MB+)
- Require installation permissions
- Take up device storage
- Need updates through stores

**PWAs (like STASH):**
- Accessed through a web browser first
- Small file size (only essential files)
- "Install" just adds to home screen
- Minimal storage usage
- Auto-update when you visit
- Works like a native app once installed

## How STASH Installation Works

### What Happens When You "Install"

1. **On Mobile:**
   - The INSTALL button adds STASH to your home screen
   - Creates an app icon (like native apps)
   - Opens in full-screen mode (no browser UI)
   - Feels and behaves like a native app
   - Works offline with cached data

2. **On Desktop:**
   - Creates a standalone window
   - Adds to your applications
   - Works independently of the browser
   - Full app experience

### Benefits of PWA Installation

✓ **Always Up-to-Date**: No manual updates needed
✓ **Offline Access**: Works without internet (cached content)
✓ **Fast Loading**: Assets are cached locally
✓ **Native Feel**: Full-screen, no browser bars
✓ **Small Size**: Only ~1-2MB vs 50MB+ for native apps
✓ **Cross-Platform**: Same app on iOS, Android, Desktop

## Installation Process

### iOS (iPhone/iPad)
1. Open STASH in Safari
2. Tap the Share button (📤) at the bottom
3. Scroll down and tap "Add to Home Screen"
4. Tap "Add" in the top right
5. STASH icon appears on your home screen
6. Tap the icon to open STASH as a full app

### Android
1. Open STASH in Chrome
2. Tap the three dots menu (⋮)
3. Tap "Install app" or "Add to Home screen"
4. Confirm installation
5. STASH icon appears on your home screen
6. Opens as a standalone app

### Desktop (Chrome, Edge, Brave)
1. Open STASH in browser
2. Look for install icon (⊕) in address bar
3. Click it, or use Menu → "Install Stash"
4. STASH opens in its own window
5. Can be pinned to taskbar/dock

## Technical Details

### Files Cached for Offline Use:
- HTML structure
- CSS styles
- JavaScript code
- Icons and assets
- Manifest configuration

### What Requires Internet:
- Syncing with Supabase database
- Uploading images to Cloudinary
- Sharing stashes with other users
- Initial login authentication

### Service Worker Features:
- Caches essential files locally
- Provides offline functionality
- Updates automatically in background
- Enables push notifications (future feature)

## Why "Install" Instead of "Download"?

The button says "INSTALL" because:
- PWAs don't download large app packages
- Installation is instant (just adds to home screen)
- The "app" is already loaded in your browser
- You're essentially bookmarking with superpowers

## Is This Really an App?

**YES!** Once installed, STASH:
- Has its own icon on your home screen
- Opens in full-screen (no browser UI)
- Works offline
- Runs independently
- Behaves exactly like a native app
- Saves your login state
- Stores data locally

The only difference is the technology used to build it. To users, it's indistinguishable from a native app!

## Uninstalling STASH

### iOS:
- Long press the STASH icon
- Tap "Remove App"
- Confirm deletion

### Android:
- Long press the STASH icon
- Drag to "Uninstall" or tap app info → Uninstall

### Desktop:
- Right-click STASH window
- Click "Uninstall Stash"
- Or: Browser settings → Installed Apps → Remove

---

**Bottom Line**: PWAs like STASH give you a full app experience without the bloat, storage requirements, or slow updates of traditional apps. When you "install" STASH, you're getting a real app that just happens to be built with web technologies!
