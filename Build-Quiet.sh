#!/bin/bash
if [ "$EUID" -ne 0 ]
then
  echo "[*] Please run as root"
  exit
fi

docker build -t smbserver .

if [ ! -d "logs" ]
then
  mkdir logs
fi

if [ ! -d "smbDrive" ]
then
    mkdir smbDrive
fi

docker run --name SMB -d -p $1:445:445 -p $1:139:139 -v `pwd`/logs:/home/smb/logs/ -v `pwd`/smbDrive:/home/smb/smbDrive/ -i smbserver

if [ $? -ne 0 ]
then
  echo "[*] Docker with name SMB already running"
  echo "[*] Stopping SMB and rerunning"
  docker rm -f SMB
  docker run --name SMB -d -p $1:445:445 -p $1:139:139 -v `pwd`/logs:/home/smb/logs/ -v `pwd`/smbDrive:/home/smb/smbDrive/ -i smbserver
fi

echo -e "[*]Setting up environment for extracting info from Log";
 
