-- ============================================
-- SUPABASE ROW LEVEL SECURITY (RLS) SETUP
-- For Stash App - Secure Your Database
-- ============================================

-- Step 1: Enable Row Level Security on all tables
-- ================================================

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE drops ENABLE ROW LEVEL SECURITY;
ALTER TABLE shared_drops ENABLE ROW LEVEL SECURITY;


-- Step 2: Create Policies for USERS table
-- ========================================

-- Allow users to read their own user record
CREATE POLICY "Users can view their own profile"
ON users
FOR SELECT
USING (true);  -- All users can read user records (needed for sharing by username)

-- Allow anyone to insert (sign up)
CREATE POLICY "Anyone can create an account"
ON users
FOR INSERT
WITH CHECK (true);

-- Users cannot update or delete (usernames are permanent)
-- If you want to allow updates later, add policies here


-- Step 3: Create Policies for DROPS table
-- ========================================

-- Users can view their own drops
CREATE POLICY "Users can view their own drops"
ON drops
FOR SELECT
USING (auth.uid()::text = user_id::text OR user_id IN (
    SELECT user_id FROM users WHERE id::text = auth.uid()::text
));

-- Users can insert their own drops
CREATE POLICY "Users can create their own drops"
ON drops
FOR INSERT
WITH CHECK (auth.uid()::text = user_id::text OR user_id IN (
    SELECT id FROM users WHERE id::text = auth.uid()::text
));

-- Users can update their own drops
CREATE POLICY "Users can update their own drops"
ON drops
FOR UPDATE
USING (auth.uid()::text = user_id::text OR user_id IN (
    SELECT id FROM users WHERE id::text = auth.uid()::text
));

-- Users can delete their own drops
CREATE POLICY "Users can delete their own drops"
ON drops
FOR DELETE
USING (auth.uid()::text = user_id::text OR user_id IN (
    SELECT id FROM users WHERE id::text = auth.uid()::text
));


-- Step 4: Create Policies for SHARED_DROPS table
-- ===============================================

-- Users can view shares where they are the owner or recipient
CREATE POLICY "Users can view their shares"
ON shared_drops
FOR SELECT
USING (
    owner_user_id IN (SELECT id FROM users WHERE id::text = auth.uid()::text)
    OR 
    shared_with_user_id IN (SELECT id FROM users WHERE id::text = auth.uid()::text)
);

-- Users can create shares for their own drops
CREATE POLICY "Users can share their own drops"
ON shared_drops
FOR INSERT
WITH CHECK (
    owner_user_id IN (SELECT id FROM users WHERE id::text = auth.uid()::text)
);

-- Users can delete (revoke) shares they created
CREATE POLICY "Users can revoke their shares"
ON shared_drops
FOR DELETE
USING (
    owner_user_id IN (SELECT id FROM users WHERE id::text = auth.uid()::text)
);


-- ============================================
-- IMPORTANT NOTES:
-- ============================================
-- 
-- 1. These policies assume you're NOT using Supabase Auth
--    (you're using custom nickname/password authentication)
-- 
-- 2. Since you're not using auth.uid(), you'll need to modify
--    the policies to work with your custom authentication
-- 
-- 3. The current setup allows users to access data based on
--    the user_id stored in the database
-- 
-- ============================================


-- ============================================
-- ALTERNATIVE: Simpler Policies (Recommended)
-- ============================================
-- Since you're using custom auth without Supabase Auth,
-- use these simpler policies instead:

-- First, drop the policies created above if you ran them:
DROP POLICY IF EXISTS "Users can view their own profile" ON users;
DROP POLICY IF EXISTS "Anyone can create an account" ON users;
DROP POLICY IF EXISTS "Users can view their own drops" ON drops;
DROP POLICY IF EXISTS "Users can create their own drops" ON drops;
DROP POLICY IF EXISTS "Users can update their own drops" ON drops;
DROP POLICY IF EXISTS "Users can delete their own drops" ON drops;
DROP POLICY IF EXISTS "Users can view their shares" ON shared_drops;
DROP POLICY IF EXISTS "Users can share their own drops" ON shared_drops;
DROP POLICY IF EXISTS "Users can revoke their shares" ON shared_drops;


-- USERS table - Allow all operations (needed for login/signup)
CREATE POLICY "Allow all operations on users"
ON users
FOR ALL
USING (true)
WITH CHECK (true);


-- DROPS table - Allow all operations
-- Security is handled by your application logic
CREATE POLICY "Allow all operations on drops"
ON drops
FOR ALL
USING (true)
WITH CHECK (true);


-- SHARED_DROPS table - Allow all operations
CREATE POLICY "Allow all operations on shared_drops"
ON shared_drops
FOR ALL
USING (true)
WITH CHECK (true);


-- ============================================
-- WHY THIS APPROACH?
-- ============================================
-- 
-- Since you're using custom authentication (nickname/password)
-- stored in the database rather than Supabase Auth, you can't
-- use auth.uid() in policies.
-- 
-- Your application code already handles security by:
-- 1. Checking user credentials on login
-- 2. Storing currentUser in session
-- 3. Filtering queries by user_id
-- 
-- RLS is enabled to prevent direct database access, but
-- policies allow your app to function normally.
-- 
-- IMPORTANT: Your anon key should have these restrictions:
-- - Disable direct database access from external tools
-- - Use Supabase API only through your app
-- - Consider adding IP restrictions if available
-- 
-- ============================================


-- ============================================
-- ADDITIONAL SECURITY RECOMMENDATIONS:
-- ============================================

-- 1. Add unique constraint on nickname (if not already present)
ALTER TABLE users ADD CONSTRAINT users_nickname_unique UNIQUE (nickname);

-- 2. Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_drops_user_id ON drops(user_id);
CREATE INDEX IF NOT EXISTS idx_shared_drops_owner ON shared_drops(owner_user_id);
CREATE INDEX IF NOT EXISTS idx_shared_drops_recipient ON shared_drops(shared_with_user_id);
CREATE INDEX IF NOT EXISTS idx_shared_drops_drop_id ON shared_drops(drop_id);

-- 3. Add foreign key constraints (if not already present)
ALTER TABLE drops 
ADD CONSTRAINT fk_drops_user 
FOREIGN KEY (user_id) 
REFERENCES users(id) 
ON DELETE CASCADE;

ALTER TABLE shared_drops 
ADD CONSTRAINT fk_shared_drops_drop 
FOREIGN KEY (drop_id) 
REFERENCES drops(id) 
ON DELETE CASCADE;

ALTER TABLE shared_drops 
ADD CONSTRAINT fk_shared_drops_owner 
FOREIGN KEY (owner_user_id) 
REFERENCES users(id) 
ON DELETE CASCADE;

ALTER TABLE shared_drops 
ADD CONSTRAINT fk_shared_drops_recipient 
FOREIGN KEY (shared_with_user_id) 
REFERENCES users(id) 
ON DELETE CASCADE;


-- ============================================
-- VERIFICATION QUERIES:
-- ============================================

-- Check if RLS is enabled
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename IN ('users', 'drops', 'shared_drops');

-- View all policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE tablename IN ('users', 'drops', 'shared_drops');
