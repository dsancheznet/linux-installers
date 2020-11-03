#!/usr/bin/env bash

FILENAME_SVG=$1
DEST_DIR=$2
SUB_DIRS=`ls $DEST_DIR | egrep '^[0-9]{,4}x[0-9]{,4}$'`
FILENAME_PNG=`echo ${FILENAME_SVG/.svg/.png}`

echo "SVG Icon install utility (c)D.Sánchez 2020"

if [ $# -eq 0 ]
  then
    echo "Usage: install_icon.sh SVG_IMAGE.svg DESTINATION_DIRECTORY"
    echo
    echo "This converts the supplied svg file to all versions to which directories exist and moves the svg to the 'scalable' directory"
fi

for S in $SUB_DIRS; do
  echo "Converting $FILENAME_SVG to $FILENAME_PNG ( $S )"
  convert -background none $FILENAME_SVG -resize $S $DEST_DIR/$S/$FILENAME_PNG
done;

if [ -d "$DEST_DIR/scalable/"  ]; then
  echo "Moving SVG to scalable"
  mv $FILENAME_SVG $DEST_DIR/scalable/
fi
