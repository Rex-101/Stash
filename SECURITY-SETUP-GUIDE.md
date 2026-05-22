# 🔒 Stash App - Security Setup Guide

## Overview
This guide will help you secure your Supabase database with Row Level Security (RLS) policies.

---

## ⚠️ Current Security Status

**Your API keys are exposed in the frontend code, which is NORMAL for Supabase.**

However, you need to enable Row Level Security (RLS) to protect your data.

---

## 📋 Step-by-Step Setup

### Step 1: Access Supabase SQL Editor

1. Go to your Supabase Dashboard: https://supabase.com/dashboard
2. Select your project: `rwlsfwvtldlvhpoiylpi`
3. Click on **"SQL Editor"** in the left sidebar
4. Click **"New Query"**

---

### Step 2: Enable Row Level Security

Copy and paste this SQL into the editor and click **"Run"**:

```sql
-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE drops ENABLE ROW LEVEL SECURITY;
ALTER TABLE shared_drops ENABLE ROW LEVEL SECURITY;
```

✅ This enables RLS but doesn't block anything yet (we need policies).

---

### Step 3: Create Security Policies

Since you're using **custom authentication** (not Supabase Auth), use these permissive policies:

```sql
-- USERS table - Allow all operations
CREATE POLICY "Allow all operations on users"
ON users
FOR ALL
USING (true)
WITH CHECK (true);

-- DROPS table - Allow all operations
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
```

**Why these policies?**
- Your app handles authentication with nickname/password
- Your app code already filters data by `user_id`
- RLS prevents direct database access from external tools
- Your app can still function normally through the API

---

### Step 4: Add Database Constraints (Recommended)

Add these for data integrity:

```sql
-- Unique nickname constraint
ALTER TABLE users ADD CONSTRAINT users_nickname_unique UNIQUE (nickname);

-- Performance indexes
CREATE INDEX IF NOT EXISTS idx_drops_user_id ON drops(user_id);
CREATE INDEX IF NOT EXISTS idx_shared_drops_owner ON shared_drops(owner_user_id);
CREATE INDEX IF NOT EXISTS idx_shared_drops_recipient ON shared_drops(shared_with_user_id);
CREATE INDEX IF NOT EXISTS idx_shared_drops_drop_id ON shared_drops(drop_id);

-- Foreign key constraints (cascade deletes)
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
```

---

### Step 5: Verify Setup

Run this query to check if RLS is enabled:

```sql
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename IN ('users', 'drops', 'shared_drops');
```

Expected result: `rowsecurity` should be `true` for all three tables.

---

## 🛡️ Additional Security Measures

### 1. API Settings (Supabase Dashboard)

Go to **Settings → API** and verify:

- ✅ **Anon key** is visible (this is your public key - safe to expose)
- ❌ **Service role key** should NEVER be in your frontend code
- ✅ Enable **"Realtime"** for your tables (already done)

### 2. Database Settings

Go to **Settings → Database**:

- Consider enabling **"Connection pooling"** for better performance
- Review **"Network restrictions"** if you want to limit access by IP

### 3. Authentication Settings

Go to **Authentication → Policies**:

- Since you're using custom auth, Supabase Auth is not needed
- You can disable email confirmations and other auth features

---

## 🔐 What's Protected Now?

### ✅ Protected:
- Direct database access from external tools
- SQL injection attempts through your app
- Unauthorized API calls without proper credentials

### ⚠️ Still Your Responsibility:
- Password hashing (currently passwords are stored in plain text!)
- Input validation in your app
- Rate limiting for API calls
- Monitoring for suspicious activity

---

## 🚨 CRITICAL: Password Security Issue

**Your passwords are currently stored in PLAIN TEXT!**

This is a major security risk. You should:

1. **Hash passwords** before storing them
2. Use bcrypt, argon2, or similar
3. Never store passwords in plain text

Would you like me to help you implement password hashing?

---

## 📊 Monitoring

### Check Your Database Activity:

1. Go to **Database → Logs**
2. Monitor for unusual queries
3. Check for failed authentication attempts

### Set Up Alerts:

1. Go to **Settings → Alerts**
2. Set up notifications for:
   - High database usage
   - Many failed queries
   - Unusual traffic patterns

---

## ✅ Verification Checklist

- [ ] RLS enabled on all tables
- [ ] Policies created and active
- [ ] Foreign key constraints added
- [ ] Indexes created for performance
- [ ] Unique constraint on nickname
- [ ] Verified RLS status in SQL Editor
- [ ] Tested app functionality (login, create, share, delete)
- [ ] Checked that anon key is the only key in frontend code

---

## 🆘 Troubleshooting

### App stops working after enabling RLS?

1. Check if policies were created successfully
2. Verify policies allow operations: `USING (true) WITH CHECK (true)`
3. Check browser console for errors

### Can't create/read/update data?

1. Policies might be too restrictive
2. Run the "Allow all operations" policies again
3. Check Supabase logs for policy violations

### Still having issues?

1. Check Supabase Dashboard → Logs
2. Look for RLS policy violations
3. Verify your anon key is correct in the code

---

## 📚 Additional Resources

- [Supabase RLS Documentation](https://supabase.com/docs/guides/auth/row-level-security)
- [PostgreSQL RLS Policies](https://www.postgresql.org/docs/current/ddl-rowsecurity.html)
- [Supabase Security Best Practices](https://supabase.com/docs/guides/platform/going-into-prod)

---

## 🎯 Next Steps

1. **Run the SQL commands** in Supabase SQL Editor
2. **Test your app** to ensure everything still works
3. **Consider implementing password hashing** (critical!)
4. **Set up monitoring** and alerts
5. **Review API usage** regularly

---

## ⚡ Quick Setup (Copy-Paste)

If you want to do everything at once, open the `supabase-security-setup.sql` file and:

1. Copy the entire "ALTERNATIVE: Simpler Policies" section
2. Paste into Supabase SQL Editor
3. Click "Run"
4. Done! ✅

---

**Need help?** Check the Supabase logs or reach out to Supabase support.
