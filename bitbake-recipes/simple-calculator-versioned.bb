# Dynamic versioned recipe - automatically uses latest release
SUMMARY = "Simple Calculator Application"
DESCRIPTION = "This is a simple calculator application"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${S}/LICENSE;md5=07f8772ac7c88b3849022bdf9d3e4452"

inherit cmake

# This will use the SRCREV corresponding to the tag specified in PV
SRC_URI = "git://github.com/debalghosh1207/Simple-Calculator.git;branch=main;protocol=https;tag=v${PV}"

# Set to latest release version - update this when upgrading
PV = "1.1.0"

# Optional: Add a python function to auto-detect latest release
python do_fetch_prepend() {
    import json
    import urllib.request
    
    try:
        # Fetch latest release info from GitHub API
        with urllib.request.urlopen('https://api.github.com/repos/debalghosh1207/Simple-Calculator/releases/latest') as response:
            data = json.loads(response.read().decode())
            latest_version = data['tag_name'].lstrip('v')
            
        # Compare with current PV
        current_pv = d.getVar('PV')
        if latest_version != current_pv:
            bb.warn(f"New version available: {latest_version} (current: {current_pv})")
            
    except Exception as e:
        bb.note(f"Could not check for updates: {e}")
}

do_install:append() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/basic-calculator ${D}${bindir}/
    
    # Install version info
    install -d ${D}${datadir}/${PN}
    echo "${PV}" > ${D}${datadir}/${PN}/version
}

FILES:${PN} += "${datadir}/${PN}/version"
