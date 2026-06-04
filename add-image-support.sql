-- Migration: Add Image Support to Stash App
-- Run this in your Supabase SQL Editor

-- Add image_url column to drops table
ALTER TABLE drops 
ADD COLUMN IF NOT EXISTS image_url TEXT;

-- Add index for better query performance
CREATE INDEX IF NOT EXISTS idx_drops_image_url 
ON drops(image_url) 
WHERE image_url IS NOT NULL;

-- Verify the changes
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'drops' 
  AND column_name = 'image_url';

-- Show sample data structure
SELECT id, label, 
  CASE 
    WHEN text IS NOT NULL THEN '(has text)' 
    ELSE '(no text)' 
  END as text_status,
  CASE 
    WHEN image_url IS NOT NULL THEN '(has image)' 
    ELSE '(no image)' 
  END as image_status,
  created_at
FROM drops
LIMIT 5;
