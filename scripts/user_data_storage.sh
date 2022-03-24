#!/bin/bash

###################################################
# Copyright (C) IBM Corp. 2021 All Rights Reserved.
# Licensed under the Apache License v2.0
###################################################

DATA_DIR="/${mount_path}"
sleep 4s

# Set HostName
privateIP=$(ip addr show eth0 | awk '$1 == "inet" {gsub(/\/.*$/, "", $2); print $2}')
cluster_cidr_block="$(ip addr show eth0 | awk '$1 == "inet" {gsub(/\/.*$/, "", $2); print $2}'| cut -d'.' -f1,2).0.0/16"
hostName=openshift-nfs-${privateIP//./-}
hostnamectl set-hostname ${hostName}

# Mounting the Volume
found=0
while [ $found -eq 0 ]; do
    for vdx in `lsblk -d -n --output NAME`; do
        desc=$(file -s /dev/$vdx | grep ': data$' | cut -d : -f1)
        if [ "$desc" != "" ]; then
            if [ "$desc" != "/dev/vdb" ]; then
                mkfs -t xfs $desc
                uuid=`blkid -s UUID -o value $desc`
                echo "UUID=$uuid $DATA_DIR xfs defaults,noatime 0 0" >> /etc/fstab
                mkdir -p $DATA_DIR
                mount $DATA_DIR
                chmod 775 $DATA_DIR
                found=1
                break
            fi
        fi
    done
    sleep 5s
done

# Permanent Mounting
echo "$DATA_DIR  ${cluster_cidr_block}(rw,no_root_squash)" > /etc/exports.d/export-nfs.exports
exportfs -ar

# Start the NFS service
systemctl start nfs-server
systemctl enable nfs-server

echo END `date '+%Y-%m-%d %H:%M:%S'`