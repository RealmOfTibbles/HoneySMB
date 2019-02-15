#!/bin/bash
docker build -t smbserver .

rm -f /opt/Honeypot-SMB-HoneySMB/Done
# can only use 0.5GB 75% CPU for one core when cpu is restricted its priority is lower then defult 
docker run --memory=512m --cpus="0.75" --cpu-shares=768 --name SMB -d -p $1:445:445 -p $1:139:139 -v /opt/Honeypot-SMB-HoneySMB/HoneySMB/logs:/home/smb/logs/ -v /opt/Honeypot-SMB-HoneySMB/HoneySMB/smbDrive:/home/smb/smbDrive/ -i smbserver

if [ $? -ne 0 ]
then
  echo "[*] Docker with name SMB already running"
  echo "[*] Stopping SMB and rerunning"
  docker rm -f SMB
  docker run --memory=512m --cpus="0.75" --cpu-shares=768 --name SMB -d -p $1:445:445 -p $1:139:139 -v /opt/Honeypot-SMB-HoneySMB/HoneySMB/logs:/home/smb/logs/ -v /opt/Honeypot-SMB-HoneySMB/HoneySMB/smbDrive:/home/smb/smbDrive/ -i smbserver
fi

echo "completed" > /opt/Honeypot-SMB-HoneySMB/Done
