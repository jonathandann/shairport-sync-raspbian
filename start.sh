#!/bin/bash

set -e

service dbus start
service avahi-daemon start

shairport-sync -u -m avahi -c /etc/shairport-sync.conf -a "$AIRPLAY_NAME" "$@"
