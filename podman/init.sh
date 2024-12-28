mkdir /public
echo LABEL=`ls /dev/disk/by-label | grep -P "^[^root|^boot]" | head -1` /public ext4 defaults,noatime,nofail 0 0 >> /etc/fstab
mount -a
 
apt-get update -qq -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false
apt-get install -y unar
apt-get install -y tmux
apt-get install -y podman

mkdir /home/pi/aria2-config
mkdir /home/pi/JDownloader-config

sudo podman play kube pod.yaml
cd /etc/systemd/system
sudo podman generate systemd --restart-policy=always --files --name main
sudo systemctl enable pod-main.service

# podman cp /home/pi/noto jd2:/usr/share/fonts/
# podman exec jd2 fc-cache -fv

# Extraction: Subpath => true
# Extraction: Deep Extraction => false
# LinkgrabberSettings: Linkgrabber Auto Confirm => true
# LinkgrabberSettings: Auto Extraction => false
