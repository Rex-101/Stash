# Cloudinary Setup Guide for Stash App

This guide will help you set up Cloudinary for image storage in your Stash app.

## Why Cloudinary?

Cloudinary provides:
- Free tier with generous limits (25 GB storage, 25 GB bandwidth/month)
- Automatic image optimization
- CDN delivery for fast loading
- Easy API integration
- No server-side code required

---

## Step 1: Create a Cloudinary Account

1. Go to [https://cloudinary.com/users/register/free](https://cloudinary.com/users/register/free)
2. Sign up for a free account
3. Verify your email address
4. Log in to your dashboard

---

## Step 2: Get Your Cloud Name

1. Once logged in, you'll see your dashboard
2. Look for **Account Details** section
3. Copy your **Cloud Name** (e.g., `dxyz123abc`)
4. Save this - you'll need it for Step 4

---

## Step 3: Create an Upload Preset

1. In the Cloudinary dashboard, go to **Settings** (gear icon in top right)
2. Click on the **Upload** tab in the left sidebar
3. Scroll down to **Upload presets** section
4. Click **Add upload preset**
5. Configure the preset:
   - **Upload preset name**: `stash_images` (or any name you prefer)
   - **Signing Mode**: Select **Unsigned**
   - **Folder**: `stash` (optional - helps organize images)
   - **Unique filename**: Enable this
   - **Overwrite**: Disable
6. Click **Save**
7. Copy the **preset name** - you'll need it for Step 4

**Important:** Make sure to select **Unsigned** mode. This allows your frontend to upload directly without exposing API secrets.

---

## Step 4: Update Your Stash App

1. Open your `index.html` file
2. Find these lines (around line 1366):

```javascript
// Cloudinary Configuration
const CLOUDINARY_CLOUD_NAME = "YOUR_CLOUD_NAME"; // Replace with your Cloudinary cloud name
const CLOUDINARY_UPLOAD_PRESET = "YOUR_UPLOAD_PRESET"; // Replace with your unsigned upload preset
```

3. Replace `YOUR_CLOUD_NAME` with your cloud name from Step 2
4. Replace `YOUR_UPLOAD_PRESET` with your preset name from Step 3

Example:
```javascript
const CLOUDINARY_CLOUD_NAME = "dxyz123abc";
const CLOUDINARY_UPLOAD_PRESET = "stash_images";
```

5. Save the file
6. Commit and push to GitHub

---

## Step 5: Update Database Schema

You need to add an `image_url` column to your Supabase `drops` table:

1. Go to your Supabase dashboard
2. Navigate to **SQL Editor**
3. Run this SQL command:

```sql
-- Add image_url column to drops table
ALTER TABLE drops 
ADD COLUMN image_url TEXT;

-- Verify the column was added
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'drops';
```

4. Click **Run** to execute the query

---

## Step 6: Test Image Upload

1. Go to your deployed Stash app
2. Log in
3. Click **📷 ADD IMAGE** button
4. Select an image (max 5MB)
5. You'll see a preview
6. Add optional text and label
7. Click **STASH IT**
8. The image will upload to Cloudinary and save to your database

---

## Troubleshooting

### Upload fails with "Upload failed" error
- Check that your Cloud Name is correct
- Verify the Upload Preset name matches exactly
- Ensure the preset is set to **Unsigned** mode

### Image too large error
- Maximum file size is 5MB
- Try compressing your image before uploading
- Use tools like TinyPNG or ImageOptim

### Images not displaying
- Check browser console for errors
- Verify the image_url column exists in your database
- Check that images are uploaded to Cloudinary dashboard

### CORS errors
- Cloudinary should allow cross-origin requests by default
- If you see CORS errors, contact Cloudinary support

---

## Free Tier Limits

Cloudinary's free tier includes:
- 25 GB storage
- 25 GB bandwidth per month
- 25,000 transformations per month

This is more than enough for personal use and small teams.

---

## Security Notes

1. **Unsigned uploads are safe** when using upload presets with:
   - Size limits
   - Format restrictions
   - Folder restrictions

2. **Your API key/secret are NOT exposed** - we're using unsigned uploads

3. **Consider rate limiting** if your app becomes popular

4. **Monitor your Cloudinary usage** in the dashboard to avoid overages

---

## Next Steps

- Customize image display in your stash items
- Add image editing features (crop, resize)
- Implement image deletion when stashes are deleted
- Add multiple image support per stash

---

**Need Help?**
- Cloudinary Docs: https://cloudinary.com/documentation
- Supabase Docs: https://supabase.com/docs
