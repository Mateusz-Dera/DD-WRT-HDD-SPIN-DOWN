# DD-WRT-HDD-spin-down
- HDD spin down script for DD-WRT

# Info
  - Spin down HDD after time (if not used)
  - Tested on Netgear R6400v2 (DD-WRT v3.0-r37305)
  - This script install DD-WRT Easy Optware-ng Installer (If it's needed)
  - https://github.com/Mateusz-Dera/DD-WRT-Easy-Optware-ng-Installer

# USB Requirements
 - Mounted JFFS partition
 - Optional SWAP partition

# Installation
 - Run: cd /jffs    
 - Run: curl -kLO https://raw.githubusercontent.com/Mateusz-Dera/DD-WRT-HDD-Spin-Down/master/install.sh && sh ./install.sh
 - Restart router
