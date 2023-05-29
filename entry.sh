#!/bin/bash

set -x
set -e

SLEEP_SEC=300


if [ "$REMOTE_PATH" == "" ]; then
  echo "error: REMOTE_PATH not set"
  exit 1
fi

if [ "$RCLONE_SLEEP_SEC" != "" ]; then
  SLEEP_SEC=$RCLONE_SLEEP_SEC
fi

if [ "$UMASK" != "" ]; then
  umask $UMASK
fi

if [ "$RCLONE_RESYNC" == "true" ]; then
  rclone bisync $REMOTE_PATH /data --resync
fi

# Add crontab
while true
do
  rclone bisync $REMOTE_PATH /data
  sleep $SLEEP_SEC 
done
