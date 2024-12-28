#!/bin/bash
# replace \r
# ext4 hdd
if [[ $(id -u) -ne 0 ]]; then
  echo "This script must be executed as root or using sudo."
  exit 99
fi

echo '#################  start ssh  #################'
systemctl enable ssh
systemctl start ssh

echo '#################  apt-get update  #################'
apt-get update -qq -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false

echo '#################  install docker  #################'
curl -sSL https://get.docker.com/ > docker.sh
sed -i 's/apt-get update/apt-get update -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false/' docker.sh
/bin/sh docker.sh
# can use other user run docker; $() = ``
usermod -aG docker $(id -nu 1000)

echo '#################  install docker-compose  #################'
apt-get install -y -qq libffi-dev libssl-dev
apt-get install -y -qq python3 python3-pip
apt-get remove -qq python-configparser
pip3 -q install docker-compose

echo '#################  mount removable devices  #################'
mkdir /public
echo LABEL=`ls /dev/disk/by-label | grep -P "^[^root|^boot]" | head -1` /public ext4 defaults,noatime,nofail 0 0 >> /etc/fstab
mount -a

echo '#################  docker-compose up  #################'
eval mv /boot/docker-compose.yml /home/$(id -un 1000)
eval cd /home/$(id -un 1000)
docker-compose up -d
rm docker-compose.yml
rm /docker.sh

echo '#################  install other  #################'
apt-get install -y unar
apt-get install -y tmux