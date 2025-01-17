#!/bin/bash

# Git repository validation:
if [[ ! "$(ls -a)" =~ ".git" ]];
    then echo "This directory does not contain a git repository.";

else
    # Output directory generation/reset:
    OUTPUT="downloaded_versions"

    echo "The scripts will be saved in \"$OUTPUT\"" && echo
    if [[ -d $OUTPUT ]]; then
        echo "Removing old versions..." && echo
        rm -rf $OUTPUT
    fi

    mkdir $OUTPUT

    # Repository contents' iteration:
    for element in $(tree -fiI "*__" -I "*pyc" -I "$OUTPUT" --noreport | xargs | tr " " "\n"); do

        # Container(s) path definition:
        element=${element:2}  # Leading "./" removal.

        # File name extraction:
        if [[ $element =~ "/" ]]; then
            name=${element#${element%\/*}}  # Name fetching.
            name=${name:1}  # Leading "/" removal.
        else
            name=$element
        fi

        # Null entry filter:
        if [[ $element != "" ]]; then

            # File detection:
            if [[ ! $element =~ "." ]]; then

                # Subdirectory generation:
                if [[ ! -d $OUTPUT/$element ]]; then
                    mkdir $OUTPUT/$element
                    parent=$element
                fi

            # File data saving:
            else
                # Parent directory reset:
                [[ ! $element =~ $parent ]] && parent=${parent%\/*}

                echo "Saving versions for \"$element\"..."

                # File subdirectory generation:
                [[ ! -d $OUTPUT/$parent${name%.*} ]] && mkdir $OUTPUT/$parent/${name%.*}

                git log --format=%H -- $element | xargs -n1 bash -c 'git show $0:'"$element"' > '"$OUTPUT/$parent/${name%.*}"'/$(GIT_PAGER= TZ=UTC git log -n1 --date="format-local:%Y%m%dT%H%M%S" --pretty="format:%cd-%h" --abbrev=7 $0)-'"$name";
            fi
        fi

    done

    echo && echo "Done!" && echo
    tree $OUTPUT
fi
