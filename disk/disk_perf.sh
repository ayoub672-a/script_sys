#!/bin/bash

#########################################
#
# Descrption: Script to calcule debit of
# disks on a Linux Server
# Author: Allali Ayoub
# Date: 29/06/2026
#
#########################################

if [[ $UID -ne 0 ]]; then
  echo "Script must be executed with root user !"
  exit 1
fi

NULL_DEVICE="/dev/null"
ZERO_DEVICE="/dev/zero"
DISKS=$(df -PT | grep -vEi 'tmpfs|*boot|*efi' | awk '{print $1,$5,$7}' | tail -n +2)
BLOCK_SIZE="1M"
BLOCK_NUMBER="2048"
DIRECT_FLAG="direct"

while read disk; do

  mounting_point=$(echo "$disk" | awk '{print $3}')
  disk_name=$(echo "$disk" | awk '{print $1}')

  # Test read on disk
  # Read directly from disk not from cache RAM
  read_debit=$(dd if="$disk_name" of="$NULL_DEVICE" bs="$BLOCK_SIZE" count="$BLOCK_NUMBER" iflag="$DIRECT_FLAG" 2>&1 >/dev/null | tail -n 1 | cut -d"," -f4)

  # Test write on disk
  # Write directly from disk, no caching
  size_left=$(echo "$disk" | awk '{print $2}')
  if (( $size_left > 20 * 1024 * 1024  )); then
    write_debit=$(dd if="$ZERO_DEVICE" of="$mounting_point"/test_perf.txt bs="$BLOCK_SIZE" count="$BLOCK_NUMBER" oflag="$DIRECT_FLAG" 2>&1 >/dev/null | tail -n 1 | cut -d"," -f4)
  fi

  echo "####################################################"
  echo " STATISTICS FOR DISK "$disk""
  echo " DEBIT FOR READ: "$read_debit""
  echo " DEBIT FOR WRITE: "$write_debit""

  # Deleting file
  rm -f "$mounting_point"/test_perf.txt

done <<< "$DISKS"
