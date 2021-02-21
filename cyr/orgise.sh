#!/bin/bash

# tryb zależy od ostatniego argumentu


cd "$(dirname "$0")"

# getting the last arg
for i in $@; do :; done
if [ "$i" == "--newp" ]
then
    echo orgise -- new page mode
    case $# in
        1)
            dir="blog/_posts"
            outp="blog/posts"
            szablon=blog/posts/szablon.html
            ;;
        2)
            dir=$1
            outp="blog/posts"
            szablon=blog/posts/szablon.html
            ;;
        3)
            dir=$1
            outp=$2
            szablon=blog/posts/szablon.html
            ;;
        4)
            dir=$1
            outp=$2
            szablon=$3
            ;;
        *)
            echo too many args, ignoring all after the third one
            dir=$1
            outp=$2
            szablon=$3
            ;;
    esac
    echo orgising everything from $dir into new pages in $outp
    for f in $dir/*.org
    do
        echo orgising "$f"
        filename=$(basename -- "$f")
        filename="${filename%.*}"
        newf="${outp}/${filename}.html"
        touch $newf
        cp $szablon $newf
        ruby orgise.rb $f $newf --newp
        cmp --silent $szablon $newf && rm $newf || echo orgised $newf

    done
else
    echo orgise -- append mode
    case $# in
        0)
            dir="blog/_main"
            outp="blog/index.html"
            ;;
        1)
            dir=$1
            outp="blog/index.html"
            ;;
        2)
            dir=$1
            outp=$2
            ;;
        *)
            echo "too many args, ingoring all of them after the second one"
            dir=$1
            outp=$2
            ;;
    esac
    echo appending orgised $dir posts into $outp
    for f in `ls $dir/*.org | sort -V`
    do
        echo orgising "$f"
        ruby orgise.rb $f $outp
    done
fi
