#!/bin/sh

CALENDAR=☼

WIDTH=${1}

SMALL=80
MEDIUM=107
LARGE=125

if [ "$WIDTH" -ge "$LARGE" ]; then
  DATE="#[fg=colour255,bg=colour241,bold] $CALENDAR $(date +'%a %d-%m-%y')"
fi

if [ "$WIDTH" -ge "$MEDIUM" ]; then
  TIME="#[fg=colour255,bg=colour241,bold] $(date +'%H:%M')"
fi

if [ "$WIDTH" -ge "$SMALL" ]; then
  CLEAR=""
fi

echo "$DATE $TIME " | sed 's/ *$/ /g'