# Release and Versioning Guide

This document explains how to use GitHub release versioning with this Simple Calculator project and test bitbake recipe upgrades.

## Project Structure

The project now includes:
- **Version management** in CMakeLists.txt
- **Automated GitHub releases** via GitHub Actions
- **Multiple bitbake recipes** for different use cases
- **Upgrade testing scripts**

## Version Management

### Current Version System
- Semantic versioning (MAJOR.MINOR.PATCH)
- Version defined in `CMakeLists.txt`
- Version header generated at build time
- Version information accessible via `--version` flag

### Creating a New Release

#### Method 1: Manual Tagging
```bash
# Update version in CMakeLists.txt manually
# Commit changes
git add CMakeLists.txt
git commit -m "Bump version to 1.1.0"

# Create and push tag
git tag v1.1.0
git push origin v1.1.0
```

#### Method 2: Automated Version Bump
1. Go to your GitHub repository
2. Navigate to Actions tab
3. Select "Version Bump" workflow
4. Click "Run workflow"
5. Choose version type (patch/minor/major)
6. Run the workflow

This will automatically:
- Update CMakeLists.txt with new version
- Commit the changes
- Create and push a new tag
- Trigger the release workflow

## Bitbake Recipes

### 1. Development Recipe (`simple-calculator_git.bb`)
- Uses `AUTOREV` for latest commits
- Good for development and testing
- Always builds from the latest main branch

### 2. Fixed Version Recipe (`simple-calculator_1.0.0.bb`)
- Uses specific version tag
- Reproducible builds
- Production ready

### 3. Dynamic Version Recipe (`simple-calculator-versioned.bb`)
- Uses version tags but can check for updates
- Warns about newer versions available
- Good for CI/CD pipelines

## Testing Recipe Upgrades

### Using the Test Script
```bash
cd bitbake-recipes
chmod +x test-upgrade.sh
./test-upgrade.sh 1.0.0 1.1.0
```

### Manual Testing Steps

1. **Build old version:**
   ```bash
   bitbake simple-calculator_1.0.0 -c clean
   bitbake simple-calculator_1.0.0
   ```

2. **Test old version:**
   ```bash
   # On target
   basic-calculator --version  # Should show 1.0.0
   basic-calculator add 5 3    # Should work
   ```

3. **Build new version:**
   ```bash
   bitbake simple-calculator_1.1.0 -c clean
   bitbake simple-calculator_1.1.0
   ```

4. **Test new version:**
   ```bash
   # On target
   basic-calculator --version  # Should show 1.1.0
   basic-calculator add 5 3    # Should work
   ```

5. **Compare packages:**
   ```bash
   # Compare package sizes, contents, dependencies
   opkg compare-versions simple-calculator_1.0.0 simple-calculator_1.1.0
   ```

### Upgrade Testing Checklist

- [ ] Old version builds successfully
- [ ] Old version runs correctly on target
- [ ] New version builds successfully
- [ ] New version runs correctly on target
- [ ] Version information is correct in both
- [ ] No regression in functionality
- [ ] Package size is reasonable
- [ ] Dependencies are satisfied

## Integration with Your Build System

### Update Your Recipe
Replace your current recipe with one of the versioned recipes:

```bitbake
# For production use
SUMMARY = "Simple Calculator Application"
DESCRIPTION = "This is a simple calculator application"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=07f8772ac7c88b3849022bdf9d3e4452"

inherit cmake

SRC_URI = "git://github.com/debalghosh1207/Simple-Calculator.git;branch=main;protocol=https;tag=v${PV}"

# Update this version when you want to upgrade
PV = "1.0.0"

do_install:append() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/basic-calculator ${D}${bindir}/
    
    # Install version info for tracking
    install -d ${D}${datadir}/${PN}
    echo "${PV}" > ${D}${datadir}/${PN}/version
}

FILES:${PN} += "${datadir}/${PN}/version"
```

### Upgrading Process

1. **Check for new releases:**
   - Visit: https://github.com/debalghosh1207/Simple-Calculator/releases
   - Or use GitHub API: `curl -s https://api.github.com/repos/debalghosh1207/Simple-Calculator/releases/latest`

2. **Update recipe:**
   - Change `PV = "1.0.0"` to `PV = "1.1.0"`
   - Test build in development environment

3. **Test upgrade:**
   - Use the test script or manual steps above
   - Verify functionality on target

4. **Deploy:**
   - Update your layer/recipe collection
   - Build and deploy to production

## Automation Possibilities

### CI/CD Integration
```yaml
# Example pipeline step
- name: Check for calculator updates
  run: |
    LATEST=$(curl -s https://api.github.com/repos/debalghosh1207/Simple-Calculator/releases/latest | jq -r .tag_name)
    CURRENT=$(grep "PV.*=" recipes/simple-calculator.bb | cut -d'"' -f2)
    if [ "v$CURRENT" != "$LATEST" ]; then
      echo "Update available: $LATEST (current: v$CURRENT)"
      # Trigger upgrade process
    fi
```

### Automated Testing
```bash
# Add to your test suite
test_calculator_version() {
    VERSION=$(basic-calculator --version | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')
    EXPECTED="1.1.0"
    [ "$VERSION" = "$EXPECTED" ] || fail "Version mismatch: got $VERSION, expected $EXPECTED"
}
```

## Troubleshooting

### Common Issues

1. **Tag not found:**
   - Ensure the tag exists: `git tag -l`
   - Check tag format: should be `v1.0.0` not `1.0.0`

2. **Build fails:**
   - Clean cache: `bitbake simple-calculator -c cleanall`
   - Check network access for git clone

3. **Version mismatch:**
   - Verify CMakeLists.txt version matches tag
   - Rebuild to pick up new version header

4. **GitHub Actions failing:**
   - Check repository secrets and permissions
   - Verify workflow syntax
