#!/bin/bash

# Automated devtool upgrade script for Simple Calculator
# Usage: ./devtool-upgrade.sh <new_version>
# Example: ./devtool-upgrade.sh 1.1.0

set -e

RECIPE_NAME="simple-calculator"
NEW_VERSION=${1:-""}

if [ -z "$NEW_VERSION" ]; then
    echo "Usage: $0 <new_version>"
    echo "Example: $0 1.1.0"
    exit 1
fi

echo "=== devtool Upgrade Process for $RECIPE_NAME to v$NEW_VERSION ==="

# Check if we're in a Yocto environment
if ! command -v devtool &> /dev/null; then
    echo "Error: devtool not found. Please source oe-init-build-env first."
    echo "Run: source oe-init-build-env"
    exit 1
fi

echo "1. Checking current recipe status..."
devtool status | grep $RECIPE_NAME || echo "No active devtool workspace for $RECIPE_NAME"

echo "2. Upgrading $RECIPE_NAME to v$NEW_VERSION..."
if devtool upgrade $RECIPE_NAME v$NEW_VERSION; then
    echo "✅ Upgrade successful!"
else
    echo "❌ Upgrade failed. Trying alternative approach..."
    
    # Alternative: modify and manually update
    echo "3. Using devtool modify approach..."
    devtool modify $RECIPE_NAME
    
    cd workspace/sources/$RECIPE_NAME/
    echo "4. Fetching latest changes..."
    git fetch origin
    
    echo "5. Checking out v$NEW_VERSION..."
    if git checkout v$NEW_VERSION; then
        echo "✅ Checked out v$NEW_VERSION"
    else
        echo "❌ Tag v$NEW_VERSION not found. Available tags:"
        git tag -l | grep "^v" | tail -10
        exit 1
    fi
    
    cd - > /dev/null
    
    echo "6. Updating recipe..."
    devtool update-recipe $RECIPE_NAME
fi

echo "7. Building upgraded version..."
if devtool build $RECIPE_NAME; then
    echo "✅ Build successful!"
else
    echo "❌ Build failed. Check the logs."
    exit 1
fi

echo "8. Checking build results..."
BUILD_DIR=$(bitbake -e $RECIPE_NAME | grep "^WORKDIR=" | cut -d'"' -f2)
if [ -f "$BUILD_DIR/image/usr/bin/basic-calculator" ]; then
    echo "✅ Binary built successfully: $BUILD_DIR/image/usr/bin/basic-calculator"
    
    # Test version
    echo "9. Testing version..."
    if $BUILD_DIR/image/usr/bin/basic-calculator --version | grep -q "$NEW_VERSION"; then
        echo "✅ Version check passed!"
    else
        echo "⚠️ Version check failed. Expected v$NEW_VERSION"
    fi
else
    echo "❌ Binary not found in expected location"
fi

echo ""
echo "=== Upgrade Summary ==="
echo "Recipe: $RECIPE_NAME"
echo "New Version: v$NEW_VERSION"
echo "Status: Ready for testing"
echo ""
echo "Next steps:"
echo "1. Test the upgrade: devtool deploy-target $RECIPE_NAME root@your-target"
echo "2. If tests pass: devtool finish $RECIPE_NAME meta-yourlayer"
echo "3. If tests fail: devtool reset $RECIPE_NAME"
echo ""
echo "Current devtool status:"
devtool status
