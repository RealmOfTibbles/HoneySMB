#!/bin/bash
docker build -t smbserver .
if [ ! -d "logs" ]
then
  mkdir logs
fi

if [ ! -d "smbDrive" ]
then
    mkdir smbDrive
fi
# can only use 1GB 75% CPU for one core when cpu is restricted its priority is lower then defult 
docker run --memory=1024 --cpus="0.75" --cpu-shares=768 --name SMB -d -p $1:445:445 -p $1:139:139 -v `pwd`/logs:/home/smb/logs/ -v `pwd`/smbDrive:/home/smb/smbDrive/ -i smbserver

if [ $? -ne 0 ]
then
  echo "[*] Docker with name SMB already running"
  echo "[*] Stopping SMB and rerunning"
  docker rm -f SMB
  docker run --memory=1024 --cpus="0.75" --cpu-shares=768 --name SMB -d -p $1:445:445 -p $1:139:139 -v `pwd`/logs:/home/smb/logs/ -v `pwd`/smbDrive:/home/smb/smbDrive/ -i smbserver
fi
