# Cloudinary Auto-Delete Setup

Currently, images are removed from your Stash database but remain in Cloudinary storage. Here are your options to automatically clean them up:

---

## Option 1: Manual Cleanup (Current Method)

**Pros:** No setup needed, works now
**Cons:** Images stay in Cloudinary, using storage

### How to manually delete:
1. Go to https://cloudinary.com/console/media_library
2. Find old images
3. Select and delete them manually

---

## Option 2: Enable Cloudinary Auto-Delete (Recommended)

Set up lifecycle rules to automatically delete old images:

### Steps:
1. Go to Cloudinary Dashboard
2. Settings → Upload → Upload presets
3. Edit your `stash_images` preset
4. Add **Auto-tagging**: `auto_delete`
5. Save

Then set up an auto-delete rule:
1. Go to Settings → Upload → Auto Upload Mapping
2. Create rule: Delete images tagged `auto_delete` after 90 days (or your preference)

---

## Option 3: Backend Deletion API (Advanced)

To delete images immediately when removed from Stash, you need a backend:

### Requirements:
- Backend server (Node.js, Python, etc.)
- Cloudinary API key + secret (server-side only!)

### Setup:

1. **Create Supabase Edge Function** (or use Vercel/Netlify Functions):

```javascript
// Supabase Edge Function
import { createClient } from '@supabase/supabase-js'

export async function handler(req) {
  const { publicId } = await req.json()
  
  // Delete from Cloudinary using Admin API
  const cloudinary = require('cloudinary').v2
  cloudinary.config({
    cloud_name: 'dupmhn0bb',
    api_key: 'YOUR_API_KEY',
    api_secret: 'YOUR_API_SECRET' // Never expose this!
  })
  
  await cloudinary.uploader.destroy(publicId)
  
  return new Response(JSON.stringify({ success: true }))
}
```

2. **Update frontend to call this function:**

```javascript
// In deleteImageFromViewer function
const publicId = extractPublicId(currentViewerImageUrl)

// Call your backend
await fetch('YOUR_EDGE_FUNCTION_URL', {
  method: 'POST',
  body: JSON.stringify({ publicId })
})
```

---

## Option 4: Cloudinary Webhooks

Set up webhooks to get notified when images are uploaded/deleted.

---

## My Recommendation:

**For now:** Use **Option 1** (manual cleanup) - it's simple and free tier has plenty of storage.

**Long term:** Implement **Option 2** (auto-delete after X days) - set it and forget it!

**If you need instant deletion:** Implement **Option 3** with Supabase Edge Functions.

---

## Free Tier Limits:

Cloudinary free tier includes:
- **25 GB storage** - that's ~25,000 images at 1MB each
- **25 GB bandwidth/month**

Unless you're uploading hundreds of images daily, manual cleanup once a month is fine!

---

## Current Behavior:

When you delete an image from Stash:
✅ Image removed from database
✅ Image no longer shows in your stashes
❌ Image still in Cloudinary storage (uses your 25GB quota)

To fully delete: Go to Cloudinary Media Library and delete manually.
