-- Fix: Allow NULL values in text column
-- This allows users to upload images without text

-- Remove NOT NULL constraint from text column
ALTER TABLE drops 
ALTER COLUMN text DROP NOT NULL;

-- Verify the change
SELECT column_name, is_nullable, data_type
FROM information_schema.columns 
WHERE table_name = 'drops' 
AND column_name IN ('text', 'image_url');

-- This should show:
-- text: YES (nullable)
-- image_url: YES (nullable)
