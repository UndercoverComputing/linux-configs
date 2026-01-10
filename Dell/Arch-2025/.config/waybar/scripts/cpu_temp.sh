#!/bin/bash

# Get Package id 0
pkg=$(sensors | awk '/Package id 0:/ {gsub(/\+|°C/, ""); print int($4)}')

# Get all Core temps
cores=$(sensors | awk '/Core [0-9]+:/ {gsub(/\+|°C/, ""); sum+=$3; n++} END{if(n>0) print int(sum/n); else print 0}')

# Average package and core average
avg=$(( (pkg + cores) / 2 ))

echo " ${avg}°C"
