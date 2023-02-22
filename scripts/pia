#!/bin/bash
set -xeuo pipefail

# Install PIA VPN.
PIA_INSTALLER=pia-linux-3.3.1-06924.run
curl -O https://installers.privateinternetaccess.com/download/$PIA_INSTALLER
chmod u+x $PIA_INSTALLER
./$PIA_INSTALLER
rm $PIA_INSTALLER
