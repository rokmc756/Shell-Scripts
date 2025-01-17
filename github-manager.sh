#!/bin/bash
#
# It provides features to move package files for installation into backup directories
# in order to prevent uploading them and push only source codes into github.com and
# roll them back into origianl directory in order to install them by ansible-playbook.
#
# Initial date: 2021,07,24
# Author: Jack Moon, <rokmc756@gmail.com>


# BASE_DIR=/Users/moonja
BASE_DIR=/home/jomoon
BACKUP_DIR=$BASE_DIR/$PROJECT_NAME".backup"

function makedir() {
    echo "Making directory..."
    sleep 3
    mkdir -v -p $BASE_DIR/$PROJECT_NAME
}

# Echo usage if something isn't right.
function usage() {
    echo "Usage: $0 [-p <project_name>] [-r <push|rollback>] -c 'comment']" 1>&2; exit 1;
}

function push_github() {

    BACKUP_DIR="$BASE_DIR/$PROJECT_NAME.backup"
    ORIGIN_DIR="$BASE_DIR/$PROJECT_NAME"

    [ -z "${COMMENT}" ] && usage ${COMMENT}

    cd $ORIGIN_DIR

    for files_dir in `find ./ -name files`
    do

        echo $BACKUP_DIR/$files_dir

        if [ ! -d $BACKUP_DIR/$files_dir ]; then
            echo "$BACKUP_DIR/$files_dir not exists! Making $BACKUP_DIR/$files_dir directory"
            mkdir -p $BACKUP_DIR/$files_dir
        else
            echo "$BACKUP_DIR/$files_dir exists"
        fi

        # On Linux
        find $files_dir -regextype posix-egrep -regex ".*\.(gz|zip|rpm|deb|gppkg|Z|jar|tgz|tar|mov|ova)" -exec mv -v {} $BACKUP_DIR/$files_dir \;
        find $BACKUP_DIR/$files_dir -regextype posix-egrep -regex ".*\.(gz|zip|deb|rpm|gppkg|Z|jar|tgz|tar|mov|ova)"

        # On Mac
        # find -E $files_dir -regex ".*\.(gz|zip|rpm|deb|gppkg|Z|jar|tgz|tar|mov|ova)" -exec mv -v {} $BACKUP_DIR/$files_dir \;
        # find -E $BACKUP_DIR/$files_dir -regex ".*\.(gz|zip|deb|rpm|gppkg|Z|jar|tgz|tar|mov|ova)"

    done

    # gpfarmer is needed to change password before push source codes
    echo "" > $BASE_DIR/$PROJECT_NAME/ansible.log

    git add .
    git commit -m "$COMMENT"
    git push origin main

}

function rollback_files() {

    BACKUP_DIR="$BASE_DIR/$PROJECT_NAME.backup"
    ORIGIN_DIR="$BASE_DIR/$PROJECT_NAME"

    [ -z "${COMMENT}" ] && usage ${COMMENT}

    if [ ! -d $BACKUP_DIR ]; then
        echo 2222
        mkdir -p $BACKUP_DIR
    fi

    cd $BACKUP_DIR

    for files_dir in `find ./ -name files`
    do
        echo "$BACKUP_DIR/$files_dir"
        if [ ! -d $ORIGIN_DIR/$files_dir ]; then
            echo "$ORIGIN_DIR/$files_dir not exists! Making $ORIGIN_DIR/$files_dir directory"
            mkdir -p $ORIGIN_DIR/$files_dir
        else
            echo "$ORIGIN_DIR/$files_dir exists"
        fi

        # On Linux
        find $files_dir -regextype posix-egrep -regex ".*\.(gz|zip|deb|rpm|gppkg|Z|jar|tgz|tar|mov|ova)" -exec mv -v {} $ORIGIN_DIR/$files_dir \;
        find $ORIGIN_DIR/$files_dir -regextype posix-egrep -regex ".*\.(gz|zip|deb|rpm|gppkg|Z|jar|tgz|tar|mov|ova)"

        # On Mac
        # find -E $files_dir -regex ".*\.(gz|zip|deb|rpm|gppkg|Z|jar|tgz|tar|mov|ova)" -exec mv -v {} $ORIGIN_DIR/$files_dir \;
        # find -E $ORIGIN_DIR/$files_dir -regex ".*\.(gz|zip|deb|rpm|gppkg|Z|jar|tgz|tar|mov|ova)"

    done

    # gpfarmer is needed to change password before running playbook

}

while getopts ":p:r:c:" arg; do
    case "${arg}" in
        p)
            PROJECT_NAME=${OPTARG}
            [[ ! -d $BASE_DIR/$PROJECT_NAME ]] && makedir
            ;;
        r)
            ACTION=${OPTARG}
            [[ "${ACTION}" != "push" && "${ACTION}" != "rollback" ]] && usage
            ;;
        c)
            COMMENT=${OPTARG}
            ;;
        :)
            echo "ERROR: Option -$OPTARG requires an argument"
            usage
            ;;
        \?)
            echo "ERROR: Invalid option -$OPTARG"
            usage
            ;;
    esac
done

shift $((OPTIND-1))

if [ -z "${PROJECT_NAME}" ] || [ -z "${ACTION}" ] || [ -z "${COMMENT}" ] ; then
    usage
fi

#echo $PROJECT_NAME
#echo $ACTION

case "$ACTION" in
    push)
        push_github $PRJECT_NAME $ACTION
        ;;
    rollback)
        echo 6666
        rollback_files $PRJECT_NAME $ACTION
        ;;
    \?)
        echo "ERROR: Invalid action -$ACTION"
        usage
        ;;
esac

