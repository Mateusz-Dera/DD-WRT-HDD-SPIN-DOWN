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
echo -e "\e[92;1;48;5;240m | \e[94;1;48;5;240m Version:\e[92;1;48;5;240m 1.0   | \e[0m"
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

echo -e "#!/bin/sh\nsdparm --flexible -6 -l --set SCT=$time $device\nsdparm --flexible -6 -l --set STANDBY=1 $device" > hdd_spin_down.startup || exit 1
chmod 700 hdd_spin_down.startup || exit 1

while true; do
    read -p $'Do you want to reboot your device? (y/n): ' yn
    case $yn in
        [Yy]* ) reboot;;
        [Nn]* ) exit 0;;
        * ) echo -e "Please answer \e[31myes \e[0mor \e[31mno\e[0m.";;
    esac
done
