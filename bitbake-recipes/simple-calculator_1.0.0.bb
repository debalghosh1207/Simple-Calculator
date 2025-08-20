SUMMARY = "Simple Calculator Application"
DESCRIPTION = "This is a simple calculator application"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=07f8772ac7c88b3849022bdf9d3e4452"

inherit cmake

SRC_URI = "git://github.com/debalghosh1207/Simple-Calculator.git;branch=main;protocol=https;tag=v${PV}"

PV = "1.0.0"

do_install:append() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/basic-calculator ${D}${bindir}/
    
    install -d ${D}${datadir}/${PN}
    echo "${PV}" > ${D}${datadir}/${PN}/version
}

FILES:${PN} += "${datadir}/${PN}/version"
