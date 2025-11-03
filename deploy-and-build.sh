#!/bin/bash

# MyDietCoach - Complete Deployment & Build Script
# This script automates the entire process

echo "🚀 MyDietCoach - Complete Setup"
echo "================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Step 1: Check Railway Backend URL
echo -e "${YELLOW}📋 STEP 1: Backend Deployment${NC}"
echo ""
echo "Please complete these steps in Railway Dashboard:"
echo "1. Go to: https://railway.com/project/4d15ed70-c5d2-4e5a-958d-5a3f3a8a90ba"
echo "2. Click '+ New' → 'GitHub Repo'"
echo "3. Select: MdMurad-102/Mobile_app"
echo "4. Set Root Directory: 'backend'"
echo "5. Add Variables: NODE_ENV=production, PORT=3000, DATABASE_URL=\${{Postgres.DATABASE_URL}}"
echo "6. Generate Domain"
echo ""
read -p "Have you deployed the backend? (y/n) " backend_deployed

if [[ ! $backend_deployed =~ ^[Yy]$ ]]; then
    echo -e "${RED}❌ Please deploy backend first, then run this script again.${NC}"
    exit 1
fi

# Step 2: Get Railway URL
echo ""
echo -e "${YELLOW}📡 STEP 2: Configure Backend URL${NC}"
echo ""
read -p "Enter your Railway backend URL (e.g., https://mobile-app-production.up.railway.app): " railway_url

if [ -z "$railway_url" ]; then
    echo -e "${RED}❌ Railway URL is required!${NC}"
    exit 1
fi

# Remove trailing slash if present
railway_url=${railway_url%/}

# Step 3: Update API URL in the app
echo ""
echo -e "${YELLOW}🔧 STEP 3: Updating API Configuration${NC}"
echo ""

API_FILE="../service/api.ts"

if [ ! -f "$API_FILE" ]; then
    echo -e "${RED}❌ API file not found: $API_FILE${NC}"
    exit 1
fi

# Backup original file
cp "$API_FILE" "$API_FILE.backup"

# Update the production API URL
sed -i.tmp "s|: 'https://.*\..*\..*\..*'.*//.*Production|: '${railway_url}/api'; // Production|g" "$API_FILE"
rm -f "$API_FILE.tmp"

echo -e "${GREEN}✅ API URL updated to: ${railway_url}/api${NC}"

# Step 4: Build APK
echo ""
echo -e "${YELLOW}📱 STEP 4: Building Production APK${NC}"
echo ""
echo "Choose build type:"
echo "1) Debug APK (quick, for testing)"
echo "2) Release APK (production ready)"
read -p "Enter choice [1-2]: " build_choice

cd ..

case $build_choice in
    1)
        echo ""
        echo "Building Debug APK..."
        cd android
        ./gradlew clean
        ./gradlew assembleDebug
        
        if [ $? -eq 0 ]; then
            APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
            echo ""
            echo -e "${GREEN}✅ Debug APK built successfully!${NC}"
            echo "📦 Location: android/$APK_PATH"
            echo ""
            echo "Install with: adb install android/$APK_PATH"
            open app/build/outputs/apk/debug/
        else
            echo -e "${RED}❌ Build failed!${NC}"
            exit 1
        fi
        ;;
    2)
        echo ""
        echo "Building Release APK..."
        cd android
        ./gradlew clean
        ./gradlew assembleRelease
        
        if [ $? -eq 0 ]; then
            APK_PATH="app/build/outputs/apk/release/app-release.apk"
            echo ""
            echo -e "${GREEN}✅ Release APK built successfully!${NC}"
            echo "📦 Location: android/$APK_PATH"
            echo ""
            echo "Install with: adb install android/$APK_PATH"
            open app/build/outputs/apk/release/
        else
            echo -e "${RED}❌ Build failed!${NC}"
            exit 1
        fi
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

# Summary
echo ""
echo -e "${GREEN}🎉 Setup Complete!${NC}"
echo ""
echo "📋 Summary:"
echo "  - Backend URL: ${railway_url}"
echo "  - API Endpoint: ${railway_url}/api"
echo "  - APK: Built and ready"
echo ""
echo "🚀 Next Steps:"
echo "  1. Install APK on Android device"
echo "  2. Test backend connection"
echo "  3. Start using MyDietCoach!"
echo ""
echo "💡 Tip: Your original API file is backed up as service/api.ts.backup"
