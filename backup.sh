# Incremental backup script
# https://linuxconfig.org/how-to-create-incremental-backups-using-rsync-on-linux
#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

readonly BACKUP_DIR="/home/connor/MEGA/archive/backup"
readonly DATETIME="$(date '+%Y-%m-%d_%H:%M:%S')"
readonly BACKUP_PATH="${BACKUP_DIR}/${DATETIME}"
readonly LATEST_LINK="${BACKUP_DIR}/latest"

mkdir -p "${BACKUP_DIR}"

rsync -av --delete \
  /home/connor/.config \
  --link-dest "${LATEST_LINK}" \
  "${BACKUP_PATH}"
rsync -av --delete \
  /home/connor/.bashrc \
  --link-dest "${LATEST_LINK}" \
  "${BACKUP_PATH}"
pacman -Qe > "${BACKUP_PATH}/packages.txt"

rm -rf "${LATEST_LINK}"
ln -s "${BACKUP_PATH}" "${LATEST_LINK}"
