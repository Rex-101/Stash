-- ============================================
-- PASSWORD MIGRATION SCRIPT
-- For Stash App - Migrate Plain Text to Hashed
-- ============================================

-- ⚠️ IMPORTANT NOTICE ⚠️
-- 
-- This script is for REFERENCE ONLY.
-- 
-- You CANNOT automatically hash existing plain text passwords
-- because bcrypt is one-way encryption.
-- 
-- ============================================

-- OPTION 1: Force Password Reset (Recommended)
-- ============================================

-- Step 1: Add a new column for hashed passwords
ALTER TABLE users ADD COLUMN password_hash TEXT;

-- Step 2: Mark all existing users as needing password reset
ALTER TABLE users ADD COLUMN needs_password_reset BOOLEAN DEFAULT false;
UPDATE users SET needs_password_reset = true WHERE password_hash IS NULL;

-- Step 3: After all users have reset their passwords, drop old column
-- (Run this ONLY after confirming all users have reset)
-- ALTER TABLE users DROP COLUMN password;
-- ALTER TABLE users RENAME COLUMN password_hash TO password;
-- ALTER TABLE users DROP COLUMN needs_password_reset;


-- ============================================
-- OPTION 2: Delete All Users (If No Real Users Yet)
-- ============================================

-- ⚠️ WARNING: This will delete ALL user data!
-- Only use this if you're still in development/testing

-- Uncomment to delete all data:
-- DELETE FROM shared_drops;
-- DELETE FROM drops;
-- DELETE FROM users;

-- After running this, all new signups will use hashed passwords


-- ============================================
-- OPTION 3: Manual Migration (For Few Users)
-- ============================================

-- If you only have a few test users:
-- 1. Ask each user to sign up again with a new account
-- 2. Manually transfer their drops to the new account
-- 3. Delete old accounts

-- Example transfer query:
-- UPDATE drops SET user_id = 'new_user_id' WHERE user_id = 'old_user_id';


-- ============================================
-- VERIFICATION
-- ============================================

-- Check if any users still have plain text passwords
-- (Hashed passwords start with $2a$ or $2b$)
SELECT id, nickname, 
       CASE 
           WHEN password LIKE '$2a$%' OR password LIKE '$2b$%' THEN 'HASHED'
           ELSE 'PLAIN TEXT'
       END as password_status
FROM users;


-- ============================================
-- RECOMMENDED APPROACH
-- ============================================

-- Since you're likely still in development:
-- 1. Delete all test data (OPTION 2)
-- 2. Deploy the updated code with bcrypt
-- 3. All new signups will automatically use hashed passwords
-- 4. Problem solved! ✅

-- Run this to start fresh:
DELETE FROM shared_drops;
DELETE FROM drops;
DELETE FROM users;

-- Verify tables are empty:
SELECT COUNT(*) as user_count FROM users;
SELECT COUNT(*) as drops_count FROM drops;
SELECT COUNT(*) as shares_count FROM shared_drops;
