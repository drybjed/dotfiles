#!/bin/sh

if $(type scrot > /dev/null && type convert > /dev/null) ; then
  tmp=$(mktemp -d)
  trap "rm -rf ${tmp}" EXIT

  scrot "${tmp}/locked.png" -e 'convert $f -blur 6x6 $f.blur ; rm -f $f'
fi

# Activate screen saver, turn off screen after 30 seconds of inactivity
xset s on
xset s 30
xset s blank

i3lock --dpms --nofork --color=#111111 --image=${tmp}/locked.png.blur

# Disable screen saver
xset s off

