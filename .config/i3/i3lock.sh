#!/bin/sh

if $(type scrot > /dev/null && type convert > /dev/null) ; then
  tmp=$(mktemp -d)
  trap "rm -rf ${tmp}" EXIT

  scrot "${tmp}/locked.png" -e 'convert $f -blur 6x6 $f.blur ; rm -f $f'
fi

i3lock --nofork --color=#111111 --image=${tmp}/locked.png.blur

