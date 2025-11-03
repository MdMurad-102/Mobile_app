#!/bin/bash

# Deploy MyDietCoach Backend to Railway
# This script helps deploy your backend to Railway.app

echo "🚀 MyDietCoach Backend Deployment to Railway"
echo "=============================================="
echo ""

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null
then
    echo "❌ Railway CLI not found. Installing..."
    npm install -g @railway/cli
    echo "✅ Railway CLI installed"
fi

echo ""
echo "📋 Pre-deployment checklist:"
echo "  - [ ] Created account at railway.app"
echo "  - [ ] Have your database credentials ready"
echo "  - [ ] Tested backend locally"
echo ""

read -p "Continue with deployment? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Deployment cancelled."
    exit 1
fi

# Login to Railway
echo ""
echo "🔐 Logging in to Railway..."
railway login

# Initialize Railway project
echo ""
echo "🎯 Initializing Railway project..."
railway init

# Add PostgreSQL database
echo ""
echo "🗄️  Adding PostgreSQL database..."
railway add --database postgresql

# Set environment variables
echo ""
echo "⚙️  Setting environment variables..."
railway variables set NODE_ENV=production

# Deploy
echo ""
echo "🚀 Deploying to Railway..."
railway up

# Get the deployment URL
echo ""
echo "✅ Deployment complete!"
echo ""
echo "🌐 Your backend URL:"
railway domain

echo ""
echo "📝 Next steps:"
echo "  1. Copy the deployment URL above"
echo "  2. Update service/api.ts with the new URL"
echo "  3. Rebuild your app for production"
echo ""
echo "💡 To view logs: railway logs"
echo "💡 To open dashboard: railway open"
