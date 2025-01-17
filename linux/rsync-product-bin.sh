#!/bin/bash

SRC_BASE_DIR=/Users/moonja
TRG_BASE_DIR=/private/nfs/ansible-repos

for p in `ls /private/nfs/ansible-repos`
do

    for d in `find $SRC_BASE_DIR/$p -name files`
    do
        if [ -d $d ]; then
            rsync -arvvv $d/* $TRG_BASE_DIR/$p/
        fi
    done

done

