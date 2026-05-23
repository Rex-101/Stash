-- Update Rex's password to plain text
-- Run this in your Supabase SQL Editor

-- Update the password for user 'Rex' to a plain text password
-- Replace 'your_new_password' with your actual password

UPDATE users 
SET password = 'your_new_password' 
WHERE nickname = 'Rex';

-- Verify the update
SELECT id, nickname, password, created_at 
FROM users 
WHERE nickname = 'Rex';

-- INSTRUCTIONS:
-- 1. Go to your Supabase dashboard
-- 2. Navigate to SQL Editor
-- 3. Replace 'your_new_password' with your actual password
-- 4. Run the query
-- 5. You should now be able to login with your plain text password
