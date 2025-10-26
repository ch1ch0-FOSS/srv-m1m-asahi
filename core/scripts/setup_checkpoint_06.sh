#!/bin/bash
# Checkpoint 6: Storage & Directory Baseline (2025-09-26)

set -e

sudo mkdir -p /mnt/data /mnt/fastdata

for app in nextcloud forgejo mastodon matrix; do
  sudo mkdir -p /mnt/data/srv/$app \
                 /mnt/data/var/lib/$app \
                 /mnt/data/var/log/$app \
                 /mnt/data/etc/$app
done

# Insert correct UUIDs for your devices
sudo mount UUID=<data-uuid> /mnt/data
sudo mount UUID=<fastdata-uuid> /mnt/fastdata
