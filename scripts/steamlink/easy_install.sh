#!/bin/sh

TARGET="$1"
cmake --build . --target "steamlink-install-${TARGET}"

ssh steamlink 'killall -STOP shell.sh'
ssh steamlink 'killall shell'
ssh -t steamlink /home/apps/ultimate-gaming-client/ultimate-gaming-client.sh
ssh steamlink 'killall -CONT shell.sh'