#!/bin/sh

# The default HOME is not persistent, so override
# it to a path on the onboard flash. Otherwise our
# pairing data will be lost each reboot.
APPDIR=$(realpath "$(dirname "$0")")
cd "$APPDIR" || exit 1

# Renice PE_Single_CPU which seems to host A/V stuff
renice -10 -p $(pidof PE_Single_CPU)

export HOME=/usr/local/ultimate-gaming-client
export LD_LIBRARY_PATH="$APPDIR/lib:$LD_LIBRARY_PATH"

# Renice the app itself to avoid preemption by background tasks
# Write output to a logfile in /tmp
if [ -t 1 ]; then
  exec nice -n -10 ./bin/ultimate-gaming-client
else
  exec nice -n -10 ./bin/ultimate-gaming-client >/tmp/ultimate-gaming-client.log 2>&1
fi
