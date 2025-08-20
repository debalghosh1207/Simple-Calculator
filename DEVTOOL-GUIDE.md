# Using devtool for Version Management

This guide shows how to use Yocto's `devtool` to manage version upgrades for the Simple Calculator recipe.

## Prerequisites

1. **Set up Yocto environment:**
   ```bash
   source oe-init-build-env
   ```

2. **Ensure devtool is available:**
   ```bash
   which devtool  # Should show the devtool path
   ```

## Method 1: Using devtool upgrade

### Step 1: Upgrade to a new version
```bash
# Upgrade from current version to a new release
devtool upgrade simple-calculator v1.1.0

# Or upgrade to latest release automatically
devtool upgrade simple-calculator
```

### Step 2: Review the changes
```bash
# devtool will show you what changed
devtool status

# Check the workspace
ls workspace/sources/simple-calculator/

# Review the updated recipe
cat workspace/recipes/simple-calculator/simple-calculator_1.1.0.bb
```

### Step 3: Test the upgrade
```bash
# Build the upgraded version
devtool build simple-calculator

# Test the built package
devtool deploy-target simple-calculator root@your-target-ip
```

### Step 4: Finish the upgrade
```bash
# If everything works, finish the upgrade
devtool finish simple-calculator meta-yourlayer
```

## Method 2: Manual upgrade with devtool modify

### Step 1: Extract current recipe for modification
```bash
# Extract the recipe to workspace for modification
devtool modify simple-calculator
```

### Step 2: Update to new version manually
```bash
cd workspace/sources/simple-calculator/

# Check current version
git log --oneline

# Update to new version
git fetch
git checkout v1.1.0

# Or make your own changes
# ... make modifications ...
git add .
git commit -m "Custom modifications for v1.1.0"
```

### Step 3: Update recipe version
```bash
# devtool will help update the recipe
devtool update-recipe simple-calculator

# Or manually edit the recipe
vi workspace/recipes/simple-calculator/simple-calculator_1.0.0.bb
# Change PV = "1.0.0" to PV = "1.1.0"
```

### Step 4: Test and finish
```bash
devtool build simple-calculator
devtool finish simple-calculator meta-yourlayer
```

## Method 3: Using devtool with specific commits

### Upgrade to specific commit/tag
```bash
# Extract recipe and point to specific commit
devtool modify simple-calculator

cd workspace/sources/simple-calculator/
git checkout cd020de  # Specific commit hash

# Update recipe to reflect the change
devtool update-recipe simple-calculator
```

## Method 4: Automated upgrade with recipetool

### Check for new versions
```bash
# Use recipetool to check for updates
recipetool newappend simple-calculator --version=1.1.0

# Or use devtool to check latest upstream
devtool latest-version simple-calculator
```

## Advanced devtool Usage

### Working with multiple versions
```bash
# Create separate workspaces for different versions
devtool modify simple-calculator --name simple-calculator-dev
devtool modify simple-calculator --name simple-calculator-stable

# Switch between them
devtool modify simple-calculator-dev
# ... work on development version ...
devtool finish simple-calculator-dev meta-yourlayer

devtool modify simple-calculator-stable  
# ... work on stable version ...
devtool finish simple-calculator-stable meta-yourlayer
```

### Testing upgrades
```bash
# Build and compare versions
devtool build simple-calculator-old
devtool build simple-calculator-new

# Deploy to target for testing
devtool deploy-target simple-calculator-old root@target
# Test functionality
devtool undeploy-target simple-calculator-old root@target

devtool deploy-target simple-calculator-new root@target  
# Test new functionality
```

## Integration with your workflow

### Automated devtool upgrade script
See `devtool-upgrade.sh` for automation of the upgrade process.

### CI/CD Integration
```bash
# In your CI pipeline
source oe-init-build-env
devtool upgrade simple-calculator v${NEW_VERSION}
devtool build simple-calculator
devtool finish simple-calculator meta-yourlayer
```

## Troubleshooting

### Common issues:

1. **Recipe not found:**
   ```bash
   # Ensure recipe is in your layer
   bitbake-layers show-recipes simple-calculator
   ```

2. **Workspace conflicts:**
   ```bash
   # Clean workspace
   devtool reset simple-calculator
   ```

3. **Git conflicts during upgrade:**
   ```bash
   cd workspace/sources/simple-calculator/
   git status
   git reset --hard HEAD
   devtool reset simple-calculator
   ```

4. **Build failures after upgrade:**
   ```bash
   # Check what changed
   devtool build simple-calculator --verbose
   
   # Compare with working version
   devtool modify simple-calculator-working
   diff -u workspace/sources/simple-calculator-working/ workspace/sources/simple-calculator/
   ```

## Best Practices

1. **Always test in workspace first:**
   ```bash
   devtool modify → make changes → devtool build → test → devtool finish
   ```

2. **Use version-specific recipe names:**
   ```bash
   # Better than generic names
   simple-calculator_1.0.0.bb
   simple-calculator_1.1.0.bb
   ```

3. **Keep upgrade history:**
   ```bash
   # Document changes in recipe
   # Added modulus operation in v1.1.0
   # Fixed division by zero in v1.0.1
   ```

4. **Automate where possible:**
   ```bash
   # Use scripts for repetitive upgrades
   ./devtool-upgrade.sh simple-calculator 1.1.0
   ```
