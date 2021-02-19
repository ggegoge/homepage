#!/bin/bash

# argumenty: $1 to folder z "postami", $2 to strona do nadpisania

cd "$(dirname "$0")"
pwd
echo i have $# args

if [ $# -gt 0 ]
then        
    dir=$1
    if [ $# -gt 1 ]
    then
        outp=$2
    fi
else
    echo defaultuję parametry więc
    dir=blog/_posts
    outp=blog/index.html
fi
echo Orgizuję folder $dir do strony $outp

for f in `ls $dir/*.org | sort -V`
do
    echo orgizuję "$f"
    printf "puszczam \033[1;31morgise.rb\033[0m\n"
    ruby orgise.rb $f $outp
done
