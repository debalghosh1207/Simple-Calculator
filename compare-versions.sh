#!/bin/bash

# Recipe comparison script for devtool upgrades
# Compares different versions of recipes

RECIPE_NAME="simple-calculator"
VERSION1=${1:-"1.0.0"}
VERSION2=${2:-"1.1.0"}

echo "=== Recipe Comparison Tool ==="
echo "Comparing $RECIPE_NAME v$VERSION1 vs v$VERSION2"
echo ""

# Function to analyze recipe
analyze_recipe() {
    local recipe_file=$1
    local version=$2
    
    echo "📄 Recipe: $recipe_file (v$version)"
    echo "----------------------------------------"
    
    if [ ! -f "$recipe_file" ]; then
        echo "❌ Recipe file not found: $recipe_file"
        return 1
    fi
    
    echo "Version: $(grep "PV.*=" $recipe_file | cut -d'"' -f2)"
    echo "Description: $(grep "DESCRIPTION.*=" $recipe_file | cut -d'"' -f2)"
    echo "License: $(grep "LICENSE.*=" $recipe_file | cut -d'"' -f2)"
    
    # Check for specific features
    if grep -q "modulus" $recipe_file; then
        echo "✅ Modulus support: YES"
    else
        echo "❌ Modulus support: NO"
    fi
    
    # Check SRC_URI
    echo "Source URI: $(grep "SRC_URI.*=" $recipe_file | cut -d'"' -f2)"
    
    # Check install steps
    echo "Install steps:"
    grep -A 10 "do_install" $recipe_file | head -5
    
    echo ""
}

# Function to show differences
show_differences() {
    echo "🔍 Key Differences Between Versions"
    echo "=================================="
    
    local recipe1="bitbake-recipes/simple-calculator_$VERSION1.bb"
    local recipe2="bitbake-recipes/simple-calculator_$VERSION2.bb"
    
    if [ -f "$recipe1" ] && [ -f "$recipe2" ]; then
        echo "Unified diff:"
        diff -u "$recipe1" "$recipe2" || echo "Files are identical"
    else
        echo "❌ One or both recipe files not found"
        ls -la bitbake-recipes/simple-calculator_*.bb
    fi
    
    echo ""
}

# Function to check what changed in source code
check_source_changes() {
    echo "📋 Source Code Changes"
    echo "====================="
    
    # This would typically connect to your git repo
    echo "Git changes between v$VERSION1 and v$VERSION2:"
    
    if git log --oneline v$VERSION1..v$VERSION2 2>/dev/null; then
        echo ""
        echo "Files changed:"
        git diff --name-only v$VERSION1 v$VERSION2 2>/dev/null || echo "Git repository not available"
    else
        echo "Git tags not found or not in git repository"
    fi
    
    echo ""
}

# Function to suggest upgrade strategy
suggest_strategy() {
    echo "💡 Recommended devtool Upgrade Strategy"
    echo "======================================"
    
    echo "Based on the version difference ($VERSION1 → $VERSION2):"
    echo ""
    
    # Analyze version jump
    IFS='.' read -ra V1 <<< "$VERSION1"
    IFS='.' read -ra V2 <<< "$VERSION2"
    
    if [ "${V2[0]}" -gt "${V1[0]}" ]; then
        echo "🔴 MAJOR version upgrade detected"
        echo "   - Expect breaking changes"
        echo "   - Thoroughly test all functionality"
        echo "   - Consider gradual rollout"
    elif [ "${V2[1]}" -gt "${V1[1]}" ]; then
        echo "🟡 MINOR version upgrade detected"
        echo "   - New features expected"
        echo "   - Backward compatibility likely"
        echo "   - Test new features thoroughly"
    else
        echo "🟢 PATCH version upgrade detected"
        echo "   - Bug fixes expected"
        echo "   - Low risk upgrade"
        echo "   - Standard testing sufficient"
    fi
    
    echo ""
    echo "Recommended commands:"
    echo "1. devtool upgrade $RECIPE_NAME v$VERSION2"
    echo "2. devtool build $RECIPE_NAME"
    echo "3. devtool deploy-target $RECIPE_NAME root@target"
    echo "4. # Test functionality"
    echo "5. devtool finish $RECIPE_NAME meta-yourlayer"
    echo ""
}

# Main execution
cd "$(dirname "$0")"

analyze_recipe "bitbake-recipes/simple-calculator_$VERSION1.bb" "$VERSION1"
analyze_recipe "bitbake-recipes/simple-calculator_$VERSION2.bb" "$VERSION2"

show_differences
check_source_changes
suggest_strategy

echo "🔧 Additional Tools:"
echo "=================="
echo "./devtool-upgrade.sh $VERSION2    # Automated upgrade"
echo "./devtool-test.sh <target_ip>     # Test upgrade process"
echo "devtool latest-version $RECIPE_NAME # Check for newer versions"
