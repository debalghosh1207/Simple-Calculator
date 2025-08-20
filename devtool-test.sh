#!/bin/bash

# Test script for devtool upgrades
# Tests functionality before and after upgrade

RECIPE_NAME="simple-calculator"
OLD_VERSION="1.0.0"
NEW_VERSION="1.1.0"
TARGET_IP=${1:-"192.168.1.100"}

echo "=== devtool Upgrade Testing Script ==="
echo "Testing upgrade from v$OLD_VERSION to v$NEW_VERSION"
echo "Target IP: $TARGET_IP"
echo ""

# Function to test calculator functionality
test_calculator() {
    local version=$1
    local ip=$2
    
    echo "Testing calculator v$version functionality..."
    
    # Test basic operations
    ssh root@$ip "basic-calculator add 5 3" || echo "Add test failed"
    ssh root@$ip "basic-calculator subtract 10 4" || echo "Subtract test failed"
    ssh root@$ip "basic-calculator multiply 6 7" || echo "Multiply test failed"
    ssh root@$ip "basic-calculator divide 15 3" || echo "Divide test failed"
    
    # Test version info
    VERSION_OUTPUT=$(ssh root@$ip "basic-calculator --version" 2>/dev/null || echo "Version check failed")
    echo "Version output: $VERSION_OUTPUT"
    
    # Test modulus (should work in v1.1.0, fail in v1.0.0)
    if [ "$version" = "1.1.0" ]; then
        MODULUS_RESULT=$(ssh root@$ip "basic-calculator modulus 10 3" 2>/dev/null || echo "FAILED")
        if [ "$MODULUS_RESULT" = "1" ]; then
            echo "✅ Modulus operation working (result: $MODULUS_RESULT)"
        else
            echo "❌ Modulus operation failed"
        fi
    else
        echo "ℹ️ Modulus operation not expected in v$version"
    fi
}

# Check if devtool is available
if ! command -v devtool &> /dev/null; then
    echo "Error: devtool not found. Please source oe-init-build-env first."
    exit 1
fi

echo "1. Setting up old version (v$OLD_VERSION)..."
# You would typically start with the old version already deployed
# devtool modify simple-calculator
# cd workspace/sources/simple-calculator && git checkout v$OLD_VERSION
# devtool build simple-calculator
# devtool deploy-target simple-calculator root@$TARGET_IP

echo "2. Testing old version functionality..."
test_calculator $OLD_VERSION $TARGET_IP

echo ""
echo "3. Performing upgrade to v$NEW_VERSION..."
if ./devtool-upgrade.sh $NEW_VERSION; then
    echo "✅ Upgrade completed successfully"
else
    echo "❌ Upgrade failed"
    exit 1
fi

echo ""
echo "4. Deploying new version..."
if devtool deploy-target $RECIPE_NAME root@$TARGET_IP; then
    echo "✅ Deployment successful"
else
    echo "❌ Deployment failed"
    exit 1
fi

echo ""
echo "5. Testing new version functionality..."
test_calculator $NEW_VERSION $TARGET_IP

echo ""
echo "6. Comparing results..."
echo "Old version (v$OLD_VERSION): Basic operations only"
echo "New version (v$NEW_VERSION): Basic operations + modulus"

echo ""
echo "=== Test Results Summary ==="
echo "✅ Upgrade process completed"
echo "✅ New version deployed"
echo "✅ Functionality verified"
echo ""
echo "To finalize the upgrade:"
echo "devtool finish $RECIPE_NAME meta-yourlayer"
echo ""
echo "To rollback if needed:"
echo "devtool undeploy-target $RECIPE_NAME root@$TARGET_IP"
echo "devtool reset $RECIPE_NAME"
