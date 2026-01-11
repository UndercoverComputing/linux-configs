#!/usr/bin/env bash

# Requires gnome-keyring & libsecret
# Start GNOME Keyring
eval $(/usr/bin/gnome-keyring-daemon --start)
export SSH_AUTH_SOCK
export GPG_AGENT_INFO