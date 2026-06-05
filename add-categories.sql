-- Add category support to Stash app
-- Run this in your Supabase SQL Editor

-- Add category column to drops table
ALTER TABLE drops 
ADD COLUMN IF NOT EXISTS category TEXT DEFAULT 'general';

-- Create index for better filtering performance
CREATE INDEX IF NOT EXISTS idx_drops_category ON drops(category);

-- Verify the changes
SELECT column_name, data_type, column_default
FROM information_schema.columns 
WHERE table_name = 'drops' 
AND column_name = 'category';

-- Update existing drops to have a default category
UPDATE drops 
SET category = 'general' 
WHERE category IS NULL;
