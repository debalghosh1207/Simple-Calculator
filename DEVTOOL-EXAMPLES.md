# devtool Commands for Simple Calculator Upgrades

## Quick Reference

### Basic devtool upgrade workflow:
```bash
# Source Yocto environment first
source oe-init-build-env

# Method 1: Direct upgrade
devtool upgrade simple-calculator v1.1.0

# Method 2: Modify then upgrade
devtool modify simple-calculator
cd workspace/sources/simple-calculator
git checkout v1.1.0
devtool update-recipe simple-calculator

# Build and test
devtool build simple-calculator
devtool deploy-target simple-calculator root@192.168.1.100

# Finish upgrade
devtool finish simple-calculator meta-yourlayer
```

## Step-by-Step Example: v1.0.0 → v1.1.0

### 1. Initial Setup
```bash
# Start in your Yocto build directory
cd /path/to/your/yocto/build

# Source environment
source ../poky/oe-init-build-env

# Verify devtool is available
which devtool
```

### 2. Current Recipe Analysis
```bash
# Check current recipe
bitbake-layers show-recipes simple-calculator

# Current recipe location
find . -name "simple-calculator*.bb"
```

### 3. Perform Upgrade
```bash
# Option A: Automatic upgrade
devtool upgrade simple-calculator v1.1.0

# Option B: Manual control
devtool modify simple-calculator
```

### 4. If using manual method:
```bash
# Navigate to workspace
cd workspace/sources/simple-calculator/

# Check available versions
git tag -l

# Switch to new version
git fetch
git checkout v1.1.0

# Return to build directory
cd ../../..

# Update recipe
devtool update-recipe simple-calculator
```

### 5. Build and Test
```bash
# Clean build
devtool build simple-calculator -c clean
devtool build simple-calculator

# Check what was built
ls tmp/work/*/simple-calculator/*/image/usr/bin/

# Test version
tmp/work/*/simple-calculator/*/image/usr/bin/basic-calculator --version
tmp/work/*/simple-calculator/*/image/usr/bin/basic-calculator modulus 10 3
```

### 6. Deploy to Target (if you have a target device)
```bash
# Deploy to target
devtool deploy-target simple-calculator root@192.168.1.100

# Test on target
ssh root@192.168.1.100 "basic-calculator --version"
ssh root@192.168.1.100 "basic-calculator modulus 10 3"
```

### 7. Finalize Upgrade
```bash
# If tests pass, finalize the upgrade
devtool finish simple-calculator meta-yourlayer

# The updated recipe will be saved to your layer
```

## Using the Automation Scripts

### Quick Upgrade:
```bash
./devtool-upgrade.sh 1.1.0
```

### Full Testing:
```bash
./devtool-test.sh 192.168.1.100
```

### Compare Versions:
```bash
./compare-versions.sh 1.0.0 1.1.0
```

## Advanced devtool Features

### Working with patches:
```bash
# If you need patches for the upgrade
devtool modify simple-calculator
cd workspace/sources/simple-calculator
# Make changes
git add .
git commit -m "Fix compilation issue"

# Generate patch
devtool update-recipe simple-calculator

# Patch will be automatically created in your layer
```

### Multiple versions:
```bash
# Work on different versions simultaneously
devtool modify simple-calculator --name simple-calculator-stable
devtool modify simple-calculator --name simple-calculator-dev

# Build specific version
devtool build simple-calculator-stable
devtool build simple-calculator-dev
```

### Rollback:
```bash
# If upgrade fails, rollback
devtool reset simple-calculator

# This cleans the workspace and reverts changes
```

## Integration with Your Workflow

### In your CI/CD pipeline:
```bash
#!/bin/bash
# ci-upgrade.sh

source oe-init-build-env

# Get latest version from GitHub
LATEST=$(curl -s https://api.github.com/repos/debalghosh1207/Simple-Calculator/releases/latest | jq -r .tag_name)

# Upgrade to latest
./devtool-upgrade.sh ${LATEST#v}

# Run tests
bitbake simple-calculator -c testimage

# If tests pass, commit the upgrade
if [ $? -eq 0 ]; then
    devtool finish simple-calculator meta-yourlayer
    git add meta-yourlayer/recipes-apps/simple-calculator/
    git commit -m "Upgrade simple-calculator to $LATEST"
fi
```

## Troubleshooting

### Common Issues:

1. **devtool not found:**
   ```bash
   source oe-init-build-env
   ```

2. **Recipe conflicts:**
   ```bash
   devtool reset simple-calculator
   bitbake-layers show-recipes simple-calculator
   ```

3. **Git fetch fails:**
   ```bash
   cd workspace/sources/simple-calculator
   git remote -v
   git fetch origin
   ```

4. **Build failures:**
   ```bash
   devtool build simple-calculator --verbose
   bitbake simple-calculator -c clean
   ```

This workflow gives you complete control over version upgrades while maintaining the benefits of Yocto's devtool system.
