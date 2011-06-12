#!/bin/bash
NOW=$(date +"%Y-%m-%d-%H-%M")
PFILE="/home/hfcuser/backup/"$NOW"_hfc.sql"
echo "Dumping hfc to "$PFILE
mysqldump -u debian-sys-maint -pxIfdvHxmBBsHX4eQ hfcprod > $PFILE
 

