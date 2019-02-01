#!/bin/bash
if [ "$EUID" -ne 0 ]
then
    echo "[!] Please run as root"
    exit
fi

docker -v
# if ansable failed to pull docker pull "manually"
if [ $? -ne 0 ]
then
    echo "[!] Docker Install Not found Atempting Install"
    dnf install docker -y
#    curl -fsSL https://get.docker.com/ | sh
    systemctl enable docker
    systemctl start
else
    echo "[*] Docker Already Installed "
fi

# Start the build sequence 
# defaults should have been changed from ansible for 
#   smb.conf, shares.conf,
#

docker build -t smbserver  - < Dockerfile

if [ $? -ne 0 ]
then
  echo "[!] Unable to build docker"
  exit
fi

if [ ! -d "logs" ]
then
  mkdir logs
fi

if [ ! -d "smbDrive" ]
then
    mkdir smbDrive
fi

#echo -e "[*]Enter the IP to bind the server to[0.0.0.0.] \c";read server_ip;
#if [[ -z "${server_ip// }" ]];then server_ip="0.0.0.0" ;fi

echo "[!] ip given " + $1

if [$1 ]
docker run --name SMB -d -p $1:445:445 -p $1:139:139 -v `pwd`/logs:/home/smb/logs/ -v `pwd`/smbDrive:/home/smb/smbDrive/ -i smbserver

if [ $? -ne 0 ]
then
  echo "[!] Docker with name SMB already running"
  echo "[-] Stopping SMB and rerunning"
  docker rm -f SMB
  docker run --name SMB -d -p $1:445:445 -p $1:139:139 -v `pwd`/logs:/home/smb/logs/ -v `pwd`/smbDrive:/home/smb/smbDrive/ -i smbserver
fi

#echo -e "[*]Setting up environment for extracting info from Log";
