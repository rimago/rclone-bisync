#!/bin/bash

set -x
set -e

SLEEP_SEC=300


if [ "$RCLONE_SOURCE_PATH" == "" ]; then
  echo "error: RCLONE_SOURCE_PATH not set"
  exit 1
fi

if [ "$RCLONE_DEST_PATH" == "" ]; then
  echo "error: RCLONE_DEST_PATH not set"
  exit 1
fi

if [ "$RCLONE_SLEEP_SEC" != "" ]; then
  SLEEP_SEC=$RCLONE_SLEEP_SEC
fi

if [ "$UMASK" != "" ]; then
  umask $UMASK
fi

# Add crontab
while true
do
  rclone sync $RCLONE_SOURCE_PATH $RCLONE_DEST_PATH
  sleep $SLEEP_SEC 
done
