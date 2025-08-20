#!/bin/bash

# Demo script showing the complete release and upgrade workflow

echo "=== Simple Calculator Release and Upgrade Demo ==="
echo ""

echo "1. Building the project locally..."
if [ ! -d "build" ]; then
    mkdir build
fi

cd build
cmake ..
make

echo ""
echo "2. Testing the calculator..."
echo "Testing basic operations:"
./basic-calculator add 5 3
echo "5 + 3 = $(./basic-calculator add 5 3)"
echo "Version: $(./basic-calculator --version)"

cd ..

echo ""
echo "3. Release workflow steps:"
echo ""
echo "To create a new release:"
echo "  a) Update version in CMakeLists.txt (currently shows 1.0.0)"
echo "  b) Commit changes: git add CMakeLists.txt && git commit -m 'Bump version to 1.1.0'"
echo "  c) Create tag: git tag v1.1.0"
echo "  d) Push: git push origin main && git push origin v1.1.0"
echo "  e) GitHub Actions will automatically create the release"
echo ""

echo "4. Bitbake recipe upgrade testing:"
echo ""
echo "Available recipes in bitbake-recipes/:"
ls -la bitbake-recipes/

echo ""
echo "To test an upgrade:"
echo "  a) Use: cd bitbake-recipes && ./test-upgrade.sh 1.0.0 1.1.0"
echo "  b) This creates recipes for both versions"
echo "  c) Build both with bitbake and compare"

echo ""
echo "5. Key files created:"
echo "  - .github/workflows/release.yml         (Automated releases)"
echo "  - .github/workflows/version-bump.yml    (Automated version bumping)"
echo "  - version.h.in                          (Version header template)"
echo "  - bitbake-recipes/                      (Various bitbake recipes)"
echo "  - RELEASE-GUIDE.md                      (Detailed documentation)"

echo ""
echo "=== Demo complete! See RELEASE-GUIDE.md for detailed instructions ==="
