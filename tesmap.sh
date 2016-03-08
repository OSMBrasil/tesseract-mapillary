#!/bin/bash
#
# The MIT License (MIT)
#
# Copyright (c) 2016 Alexandre Magno ‒ alexandre.mbm@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

YOUTUBE_VIDEO_ID=Qkg32qsbmC8

TYPE=1

# Variables

URL="https://www.youtube.com/watch?v=$YOUTUBE_VIDEO_ID"
DIR="$TYPE"
FILE="São Paulo a Maceió - Inicio da Viagem Parte 1-Qkg32qsbmC8.mp4"
#FILE=$(youtube-dl --get-filename $URL)

DIM="864x486+208+117"
DIM_COORD_VIDEO1="183x97+861+15"
DIM_COORD_VIDEO2="115x65+980+825"
DIM_DATES="196x87+1056+21"

DIM_COORD_VIDEO=DIM_COORD_VIDEO$TYPE
DIM_COORD_VIDEO=${!DIM_COORD_VIDEO}

# Check dependencies

function is_ok() {
    which $1 > /dev/null 2>&1
    return $?
}

function passing() {
    is_ok $1 || ( echo "Lacks command: $1" && exit 1 )
}

function dependencies_check()
{
    passing "youtube-dl"
    passing "ffmpeg"
    passing "convert"
    passing "tesseract"
}

dependencies_check

# On Arch:
#
# pacman -S youtube-dl
# pacman -S tesseract
# pacman -S imagemagick
# pacman -S ffmpeg
#
# On Ubuntu:
#
# apt-get install youtube-dl
# apt-get install tesseract-ocr
# apt-get install imagemagick
# apt-get install libav-tools

# TODO helper functions

function extract_frames() {  # TODO
    # Extraindo os quadros do vídeo (um por segundo)
    echo
}


function reduce1() {  # cutting data layer and car hood
    mkdir -p $DIR/crop
    cd $DIR
    for i in *jpg ; do
        echo "Converting $i"
        convert $i -crop $DIM crop/$i
    done
    cd ..
}

function reduce2() {  # cutting the coordinates area
    mkdir -p $DIR/coord
    cd $DIR
    for i in *jpg ; do
        echo "Converting coordinates $i"
        convert $i -crop $1 coord/$i
    done
    cd ..
}

function reduce3() {  # cutting the dates
    mkdir -p $DIR/time
    cd $DIR
    for i in *jpg ; do
        echo "Converting dates $i"
        convert $i -crop $DIM_DATES time/$i
    done
    cd ..
}

function tesseract_latlng_video1() {
    tesseract $1 $2 -l dsdigital --tessdata-dir ./tessdata -psm 6 \
        --user-patterns ./tessdata/latlng.user-patterns \
        -c tessedit_char_whitelist=-,0123456789
}

function tesseract_latlng_video2() {
    tesseract $1 $2 -l helvetica --tessdata-dir ./tessdata/ -psm 6 \
        --user-patterns ./tessdata/latlng.user-patterns \
        -c tessedit_char_whitelist=-,0123456789 \
        -c language_model_penalty_punc=0.1
}

# TODO main

function download_video() {
    youtube-dl $URL
}

function adjust_constrast() {  # TODO (optional use)
    # For video 2
    #convert [img] -level 0%,250% [out]
    #convert [out] +level 150%,-250% [final]
    echo
}

function crop_frames() {
    reduce1
    reduce2 $DIM_COORD_VIDEO
    reduce3
}

function extract_data() {  # TODO
    echo
}

# Parsing parameters

case "$1" in
    info)
        [ -e "$FILE" ] &&
            echo "'$FILE'" is present ||
            echo "'$FILE'" is NOT present
        # TODO issue #3
        ;;
    adjust)
        echo "not implemented"
        ;;
    prepare)
        crop_frames
        ;;
    make)
        extract_data
        ;;
    download)
        download_video
        ;;
    test)
        tesseract_latlng_video1 1/coord/001.jpg out
        ;;
    help)
        echo "not implemented"
        ;;
    *)
        echo
        echo "Options:"
        echo
        echo "  info"
        echo "  download"
        echo "  adjust    (optional)"
        echo "  prepare"
        echo "  make"
        echo "  all"
        echo "  help"
        echo
        ;;
esac
