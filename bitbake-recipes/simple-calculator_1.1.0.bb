# Versioned recipe for v1.1.0 with modulus support
SUMMARY = "Simple Calculator Application"
DESCRIPTION = "This is a simple calculator application with modulus support"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=07f8772ac7c88b3849022bdf9d3e4452"

inherit cmake

SRC_URI = "git://github.com/debalghosh1207/Simple-Calculator.git;branch=main;protocol=https;tag=v${PV}"

# Version 1.1.0 includes modulus operation
PV = "1.1.0"

do_install:append() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/basic-calculator ${D}${bindir}/
    
    # Install version info for tracking
    install -d ${D}${datadir}/${PN}
    echo "${PV}" > ${D}${datadir}/${PN}/version
}

FILES:${PN} += "${datadir}/${PN}/version"
