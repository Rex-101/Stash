# STASH - Your Drop Vault

Save here. Access everywhere.

## 🔒 Security Setup Required

**IMPORTANT:** Before using this app in production, you must set up Row Level Security (RLS) on your Supabase database.

👉 **Follow the guide:** [SECURITY-SETUP-GUIDE.md](SECURITY-SETUP-GUIDE.md)

---

## Features

- 🔐 Secure user authentication
- 💾 Cloud storage with Supabase
- 🔄 Real-time synchronization
- 👥 Share stashes with other users
- 📱 Progressive Web App (PWA)
- 🔔 Real-time notifications
- ✨ Beautiful dark theme

## Tech Stack

- HTML5, CSS3, JavaScript
- Supabase (Backend & Database)
- Service Workers (PWA)
- Real-time subscriptions

## Deployment

Deployed on Vercel: [Your Stash App URL]

## Security Notes

- Anon key is exposed in frontend (this is normal for Supabase)
- RLS policies protect your database
- Passwords should be hashed (currently plain text - needs improvement)

## Built By

[Rex - Rexence](https://www.linkedin.com/in/tochi-ajero-663121388)

---

## Quick Start

1. Clone the repository
2. Set up Supabase database
3. Run security setup SQL (see SECURITY-SETUP-GUIDE.md)
4. Deploy to Vercel or your preferred host

## Database Schema

### users
- id (uuid, primary key)
- nickname (text, unique)
- password (text) - ⚠️ Should be hashed
- created_at (timestamp)

### drops
- id (uuid, primary key)
- text (text)
- label (text, optional)
- user_id (uuid, foreign key)
- created_at (timestamp)

### shared_drops
- id (uuid, primary key)
- drop_id (uuid, foreign key)
- owner_user_id (uuid, foreign key)
- shared_with_user_id (uuid, foreign key)
- created_at (timestamp)

---

## License

MIT License - Feel free to use and modify