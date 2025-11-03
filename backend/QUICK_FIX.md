# Quick Railway Deployment Fix

## The Problem:
Your backend code is running INSIDE the Postgres container, which is why:
- It's on port 5432 (Postgres port)
- It can't connect to the database (trying to connect to itself)

## ✅ Solution: Create Backend Service via Dashboard

### Step 1: Open Railway Dashboard
https://railway.com/project/4d15ed70-c5d2-4e5a-958d-5a3f3a8a90ba

### Step 2: Create New Service
1. Click the **"+ New"** button (top right)
2. Select **"Empty Service"**
3. Name it: **backend**

### Step 3: Deploy Your Code
In the new "backend" service:

1. Click **"Settings"**
2. Go to **"Source"** section
3. Click **"Connect Repo"** (if you have GitHub connected)
   - OR click **"Deploy"** and select **"Empty Project"**

### Step 4: Add Environment Variables
1. Click the **"Variables"** tab
2. Add these variables:
   ```
   NODE_ENV = production
   PORT = 3000
   DATABASE_URL = ${{Postgres.DATABASE_URL}}
   ```
3. Click **"Add"** for each variable

### Step 5: Deploy from Local (Using CLI)
```bash
# Link to the new backend service
railway service backend

# Deploy your code
railway up

# Generate public domain
railway domain
```

### Step 6: Get Your Backend URL
After deployment completes:
```bash
railway domain
```
This will give you a URL like: `https://mydietcoach-production.up.railway.app`

---

## 🚀 Alternative: Use Railway GitHub Integration

If you push your code to GitHub:

1. In Railway dashboard → New Service
2. Select "Deploy from GitHub repo"
3. Choose: MdMurad-102/myDietCoach
4. Set root directory: `/backend`
5. Add environment variables
6. Deploy automatically

This is the EASIEST method!

---

## 📱 After Deployment

Update your mobile app's API URL in `service/api.ts`:
```typescript
const API_URL = __DEV__
    ? 'http://localhost:3000/api'
    : 'https://your-railway-domain.up.railway.app/api';
```

Then rebuild your APK!
