set -x

GEM_IP=22.95.170.78
echo $GEM_IP

ssh root@$GEM_IP "reboot now"
ping $GEM_IP
