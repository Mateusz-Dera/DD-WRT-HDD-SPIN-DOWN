#!/bin/sh

# DD-WRT HDD Spin Down
# Copyright © 2019 Mateusz Dera

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>

echo -e "\e[92;1;48;5;239m =================== \e[0m"
echo -e "\e[92;1;48;5;240m |  HDD SPIN DOWN  | \e[0m"
echo -e "\e[92;1;48;5;241m |  \e[94;1;48;5;241mMateusz Dera  \e[92;1;48;5;241m | \e[0m"
echo -e "\e[92;1;48;5;240m | \e[94;1;48;5;240m Version:\e[92;1;48;5;240m 1.2   | \e[0m"
echo -e "\e[92;1;48;5;239m =================== \e[0m"

if ! [ -d "/jffs/.tmp" ]; then
   mkdir /jffs/.tmp || exit 1
fi
cd /jffs/.tmp || exit 1
curl -kLO https://raw.githubusercontent.com/Mateusz-Dera/DD-WRT-Easy-Optware-ng-Installer/master/install.sh || exit 1
sh ./install.sh -s 
/opt/bin/ipkg update || exit 1
rm -R /jffs/.tmp || exit 1

cd /jffs/opt || exit 1
/opt/bin/ipkg install sdparm || exit 1

cd /jffs/etc/config/ || exit 1

time=18000
device="/dev/sdb"

read -p $'Spin-down time (Default 18000): ' read_time
[ -z "$read_time" ] && echo "18000" || time=$read_time

read -p $'Device (Default /dev/sdb): ' read_device
[ -z "$read_device" ] && echo "/dev/sdb" || device=$read_device

[ -f ./hdd_spin_down.startup ] && rm ./hdd_spin_down.startup

echo -e '#!/bin/sh\n/usr/bin/logger -t START_$(basename $0) "started [$@]"\nSCRLOG=/tmp/$(basename $0).log\ntouch $SCRLOG\nTIME=$(date +"%Y-%m-%d %H:%M:%S")\necho $TIME "$(basename $0) script started [$@]" >> $SCRLOG'  > hdd_spin_down.startup || exit 1
echo -e "sdparm --flexible -6 -l --set SCT=$spin_time $device\nsdparm --flexible -6 -l --set STANDBY=1 $device" >> hdd_spin_down.startup || exit 1
echo -e 'TIME=$(date +"%Y-%m-%d %H:%M:%S")\nif [ "$?" -ne 0 ]\nthen\necho $TIME "Error in script execution! Script: $0" >> $SCRLOG\nelse\necho $TIME "Script execution OK. Script: $0" >> $SCRLOG\nfi\n/usr/bin/logger -t STOP_$(basename $0) "return code $?"\nexit $?' >> hdd_spin_down.startup || exit 1chmod 700 hdd_spin_down.startup || exit 1
chmod 700 hdd_spin_down.startup || exit 1

echo -e "Installation complete!\nRestart router"
