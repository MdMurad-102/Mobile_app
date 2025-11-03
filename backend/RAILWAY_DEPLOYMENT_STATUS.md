# 🚀 MyDietCoach Backend - Railway Deployment Guide

## ✅ What's Already Done:
- ✅ Railway account created (mdfarozehassen77@gmail.com)
- ✅ Project created: myDietCoach
- ✅ PostgreSQL database deployed and running

## 📋 Database Credentials (Railway):
```
Public URL: postgresql://postgres:VVgbvBXrUbGsTdtYeLDzxXkbRelDPSrz@nozomi.proxy.rlwy.net:41986/railway
Internal URL: postgresql://postgres:VVgbvBXrUbGsTdtYeLDzxXkbRelDPSrz@postgres.railway.internal:5432/railway
```

## 🎯 Next Steps to Complete Deployment:

### Option 1: Via Railway Dashboard (Easiest)

1. **Go to Railway Dashboard:**
   https://railway.com/project/4d15ed70-c5d2-4e5a-958d-5a3f3a8a90ba

2. **Create Backend Service:**
   - Click "+ New" 
   - Select "Empty Service"
   - Name: "backend"

3. **Deploy from GitHub:**
   - Click on the new "backend" service
   - Click "Settings" → "Source"
   - Connect your GitHub repo: MdMurad-102/myDietCoach
   - Set root directory: `/backend`
   - Deploy

4. **Set Environment Variables:**
   - In backend service, go to "Variables"
   - Add:
     ```
     NODE_ENV=production
     PORT=3000
     DATABASE_URL=${{Postgres.DATABASE_URL}}
     ```
   - Save (it will auto-deploy)

5. **Generate Public URL:**
   - Go to "Settings" → "Networking"
   - Click "Generate Domain"
   - Copy the URL (e.g., https://mydietcoach-backend.up.railway.app)

### Option 2: Via CLI (Current Method)

```bash
# 1. Create backend service via dashboard first (see Option 1, step 2)

# 2. Link to backend service
railway service backend

# 3. Set environment variables
railway variables --set "NODE_ENV=production" --set "PORT=3000"

# 4. Link database
railway service link Postgres

# 5. Deploy
railway up

# 6. Generate domain
railway domain
```

## 📱 Update Your Mobile App

Once deployed, update `service/api.ts`:

```typescript
const API_URL = __DEV__
    ? 'http://localhost:3000/api'
    : 'https://YOUR-RAILWAY-DOMAIN.up.railway.app/api'; // ← Your Railway URL here
```

## 🔍 Troubleshooting

### If deployment fails:
```bash
railway logs
```

### To check status:
```bash
railway status
```

### To open dashboard:
```bash
railway open
```

## ✨ Current Status:
- Database: ✅ Running
- Backend Service: ⏳ Needs to be created as separate service
- Public URL: ⏳ Pending

---

**Recommended:** Use **Option 1 (Dashboard)** - it's more visual and easier!
