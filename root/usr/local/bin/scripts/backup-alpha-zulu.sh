#!/bin/bash
#
# This script performs a backup from a source folder (ALPHA) to a backup folder (ZULU).
# It uses rsync to perform the backup, excluding files and folders as defined in a configuration file
# (backup-alpha-zulu.conf), and creates logs of the backup process. It also maintains a symlink pointing to the
# latest backup and cleans up older logs and backups automatically.

# The script will exit with an error if any command fails
set -o errexit
# The script will exit with an error if it tries to use an uninitialized variable
set -o nounset
# The script will exit with an error if any command in a pipeline fails
set -o pipefail

# Show usage message
# ------------------
show-help() {
  cat << EOF
Usage: $0 -a <SOURCE_DIR> -z <BACKUP_DIR> -c <CONFIG_DIR> -l <LOG_DIR>

This script performs a backup from a source folder (ALPHA) to a backup folder (ZULU).
It uses rsync to perform the backup, excluding files and folders as defined in a configuration file
(backup-alpha-zulu.conf), and creates logs of the backup process. It also maintains a symlink pointing to the
latest backup and cleans up older logs and backups automatically.

Options:
  -a <SOURCE_DIR>   Source folder (ALPHA) to backup
  -z <BACKUP_DIR>   Backup destination folder (ZULU)
  -c <CONFIG_DIR>   Folder containing the rsync configuration file (backup-alpha-zulu.conf)
  -l <LOG_DIR>      Folder where logs will be stored

  Note:
    - The <BACKUP_DIR> folder must be used exclusively to store backups because the script will delete all folders older than 30 days.
    - The <LOG_DIR> must be used exclusively to store log files because the script will delete all files older than 30 days.

EOF
}

# Script configuration from command-line arguments
# ------------------------------------------------

while getopts "a:z:c:l:" opt; do
  case "${opt}" in
    a)
      ALPHA="${OPTARG}"
      ;;
    z)
      ZULU="${OPTARG}"
      ;;
    c)
      ALPHA_ZULU_CONF="${OPTARG}"
      ;;
    l)
      ALPHA_ZULU_LOG="${OPTARG}"
      ;;
    *)
      echo
      show-help
      exit 1
      ;;
  esac
done

# Ensure all required parameters are provided
if [ -z "${ALPHA:-}" ] || [ -z "${ZULU:-}" ] || [ -z "${ALPHA_ZULU_CONF:-}" ] || [ -z "${ALPHA_ZULU_LOG:-}" ]; then
  echo
  echo "ERROR: Missing required parameters!"
  echo
  show-help
  exit 1
fi

# Script parameters
# -----------------

# Define the backup path
readonly DATETIME="$(date '+%Y%m%d-%H%M')"
readonly BACKUP_PATH="${ZULU}/${DATETIME}"

# Define the log file and the log file path
readonly LOG_FILE="${ALPHA_ZULU_LOG}/backup-alpha-zulu-${DATETIME}.log"

# Define the symlink to the latest backup
readonly LATEST_LINK="${ZULU}/latest"

# Main script
# -----------

# Check if the source and backup folders exist as well as the configuration file
[ -d "${ALPHA}" ] || { echo "Source folder ${ALPHA} does not exist."; exit 1; }
[ -d "${ZULU}" ] || { echo "Backup folder ${ZULU} does not exist."; exit 1; }
[ -d "${ALPHA_ZULU_CONF}" ] || { echo "Configuration folder ${ALPHA_ZULU_CONF} does not exist."; exit 1; }
[ -f "${ALPHA_ZULU_CONF}/backup-alpha-zulu.conf" ] || { echo "Configuration file ${ALPHA_ZULU_CONF}/backup-alpha-zulu.conf with exclude patterns does not exist."; exit 1; }

# Logging setup
mkdir -p "${ALPHA_ZULU_LOG}" || { echo "Failed to create log folder"; exit 1; }
exec > >(tee -i "${LOG_FILE}") 2>&1

echo "Starting backup: $(date)"

# Ensure required commands are available
for cmd in rsync awk df sed tail; do
    command -v "$cmd" > /dev/null || { echo "$cmd not found. Please install it."; exit 1; }
done

# Check if used disk space is greater than 90% and if so, exit with an error
USED_PERCENT=$(df "${ZULU}" | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "${USED_PERCENT}" -ge 90 ]; then
    echo "Disk usage is at ${USED_PERCENT}%. Not enough space for the backup."
    exit 1
fi

# Create the backup folder if it doesn't exist already
mkdir -p "${ZULU}" || { echo "Failed to create backup folder"; exit 1; }

# Perform the rsync backup
trap 'echo "Error during backup. Cleaning up." >> "${LOG_FILE}"; rm -rf "${BACKUP_PATH}"; exit 1' ERR
rsync -av --exclude-from "${ALPHA_ZULU_CONF}/backup-alpha-zulu.conf" --delete \
  "${ALPHA}/" --link-dest "${LATEST_LINK}" "${BACKUP_PATH}"

# Update the latest symlink to point to the new backup
rm -rf "${LATEST_LINK}"
ln -s "${BACKUP_PATH}" "${LATEST_LINK}"

# Delete backup logs older than 30 days. The folder ALPHA_ZULU_LOG must contain only log files,
# otherwise the next command will delete those files when they are older than 30 days
find "${ALPHA_ZULU_LOG}" -type f -mtime +30 -exec rm {} \;

# Delete backups older than 30 days. The folder ZULU must contain only backup folders,
# otherwise the next command will delete those folders when they are older than 30 days
find "${ZULU}" -maxdepth 1 -type d -ctime +30 -exec rm -rf {} \;

echo "Backup completed successfully: $(date)"
