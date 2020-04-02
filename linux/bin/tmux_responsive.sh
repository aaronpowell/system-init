#!/bin/sh

SPRING=🌼
SUMMER=🌞
WINTER=🎿
AUTUMN=🍂

case $(date +'%m') in
    12 | 01 | 02 )
        SEASON=$SUMMER
        ;;
    03 | 04 | 05 )
        SEASON=$AUTUMN
        ;;
    06 | 07 | 08 )
        SEASON=$WINTER
        ;;
    09 | 10 | 11 )
        SEASON=$SPRINT
        ;;
esac

WIDTH=${1}

SMALL=80
MEDIUM=107
LARGE=125

if [ "$WIDTH" -ge "$LARGE" ]; then
  DATE="#[fg=colour255,bg=colour241,bold] $SEASON $(date +'%a %d-%m-%y')"
fi

if [ "$WIDTH" -ge "$MEDIUM" ]; then
  TIME="#[fg=colour255,bg=colour241,bold] $(date +'%H:%M')"
fi

if [ "$WIDTH" -ge "$SMALL" ]; then
  CLEAR=""
fi

echo "$DATE $TIME " | sed 's/ *$/ /g'