#!/bin/bash

# Script to test bitbake recipe upgrades
# Usage: ./test-upgrade.sh <old_version> <new_version>

OLD_VERSION=${1:-"1.0.0"}
NEW_VERSION=${2:-"1.1.0"}

echo "Testing upgrade from v${OLD_VERSION} to v${NEW_VERSION}"

# Create recipe for old version
cat > simple-calculator_${OLD_VERSION}.bb << EOF
SUMMARY = "Simple Calculator Application"
DESCRIPTION = "This is a simple calculator application"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://\${S}/LICENSE;md5=07f8772ac7c88b3849022bdf9d3e4452"

inherit cmake

SRC_URI = "git://github.com/debalghosh1207/Simple-Calculator.git;branch=main;protocol=https;tag=v\${PV}"

PV = "${OLD_VERSION}"

do_install:append() {
    install -d \${D}\${bindir}
    install -m 0755 \${B}/basic-calculator \${D}\${bindir}/
    
    install -d \${D}\${datadir}/\${PN}
    echo "\${PV}" > \${D}\${datadir}/\${PN}/version
}

FILES:\${PN} += "\${datadir}/\${PN}/version"
EOF

# Create recipe for new version
cat > simple-calculator_${NEW_VERSION}.bb << EOF
SUMMARY = "Simple Calculator Application"
DESCRIPTION = "This is a simple calculator application"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://\${S}/LICENSE;md5=07f8772ac7c88b3849022bdf9d3e4452"

inherit cmake

SRC_URI = "git://github.com/debalghosh1207/Simple-Calculator.git;branch=main;protocol=https;tag=v\${PV}"

PV = "${NEW_VERSION}"

do_install:append() {
    install -d \${D}\${bindir}
    install -m 0755 \${B}/basic-calculator \${D}\${bindir}/
    
    install -d \${D}\${datadir}/\${PN}
    echo "\${PV}" > \${D}\${datadir}/\${PN}/version
}

FILES:\${PN} += "\${datadir}/\${PN}/version"
EOF

echo "Created recipes for both versions"

# Test building old version
echo "Building old version (${OLD_VERSION})..."
# bitbake simple-calculator -c clean
# bitbake simple-calculator

# Test building new version
echo "Building new version (${NEW_VERSION})..."
# bitbake simple-calculator -c clean
# bitbake simple-calculator

echo "Upgrade test setup complete!"
echo ""
echo "To test the upgrade:"
echo "1. bitbake simple-calculator_${OLD_VERSION} -c clean"
echo "2. bitbake simple-calculator_${OLD_VERSION}"
echo "3. bitbake simple-calculator_${NEW_VERSION} -c clean"
echo "4. bitbake simple-calculator_${NEW_VERSION}"
echo "5. Compare the built packages"
