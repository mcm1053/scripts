# https://linuxconfig.org/how-to-create-incremental-backups-using-rsync-on-linux
# A script to perform incremental backups using rsync
# NEVER RUN WITH SUDO
#!/bin/bash

# Failsafe, stops the script if errors occur
set -Eeuo pipefail

readonly SOURCE_DIR="${HOME}"
readonly BACKUP_DIR="/run/media/connor/backup/"
readonly DATETIME="$(date '+%Y-%m-%d_%H:%M:%S')"
readonly BACKUP_PATH="${BACKUP_DIR}/${DATETIME}"
readonly LATEST_LINK="${BACKUP_DIR}/latest"

mkdir -p "${BACKUP_DIR}"

rsync -av --delete \
  "${SOURCE_DIR}/" \
  --link-dest "${LATEST_LINK}" \
  --exclude=".cache" \
  --exclude=".local" \
  --exclude=".mozilla" \
  --exclude="Documents" \
  --exclude="Games" \
  "${BACKUP_PATH}"

rm -rf "${LATEST_LINK}"
ln -s "${BACKUP_PATH}" "${LATEST_LINK}"

# Backup list of packages
pacman -Qe > /run/media/connor/backup/packages.txt
