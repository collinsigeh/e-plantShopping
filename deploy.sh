#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# --- CONFIGURATION ---
# Replace these with your actual GitHub details
GITHUB_USERNAME="collinsigeh"
REPO_NAME="e-plantShopping"
# Change "build" to "dist" if you are using Vite instead of Create React App
BUILD_FOLDER="dist" 

echo "🚀 Starting automated deployment to GitHub Pages..."

# 1. Install gh-pages utility if not already installed
if ! npm list gh-pages --depth=0 >/dev/null 2>&1; then
    echo "📦 Installing gh-pages package as devDependency..."
    npm install gh-pages --save-dev
fi

# 2. Inject homepage property into package.json using Node
echo "🔧 Updating package.json configuration..."
HOMEPAGE_URL="https://${GITHUB_USERNAME}.github.io/${REPO_NAME}"
node -e "
  const fs = require('fs');
  const pkg = require('./package.json');
  pkg.homepage = '${HOMEPAGE_URL}';
  fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
"

# 3. Create the production build
echo "🏗️  Building production assets..."
npm run build

# 4. Deploy using the gh-pages binary
echo "📤 Pushing built assets to gh-pages branch..."
npx gh-pages -d "$BUILD_FOLDER"

echo "✅ Successfully deployed! Your site will live at: ${HOMEPAGE_URL}"
