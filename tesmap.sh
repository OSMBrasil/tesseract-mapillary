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

# Variables

URL="https://www.youtube.com/watch?v=$YOUTUBE_VIDEO_ID"
FILE=$3
TYPE=$2
DIR="$TYPE"
#FILE=$(youtube-dl --get-filename $URL)

DIM="864x486+208+117"
DIM_COORD_VIDEO1="183x97+861+15"
DIM_COORD_VIDEO2="115x65+980+825"
DIM_DATES="196x87+1056+21"

LANG1=dsdigital
LANG2=helvetica

DIM_COORD_VIDEO=DIM_COORD_VIDEO$TYPE
DIM_COORD_VIDEO=${!DIM_COORD_VIDEO}

LANG=LANG$TYPE
LANG=${!LANG}


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

# TODO main

function download_video() {
    youtube-dl $URL
}

function adjust_constrast() {  # TODO (optional use)
    # For video 2
    echo
}

function split_frames() {
  mkdir -p $DIR
  ffmpeg -i $FILE -qscale:v 2 -r 1/2 "$DIR/%03d.jpg"
}

function crop_frames() {
    reduce1
    reduce2 $DIM_COORD_VIDEO
#reduce3
}

function extract_data() {  # TODO
    echo
}

function enhance1() {
  cd $DIR/coord
  for i in *jpg ; do
    ../../negative2positive $i a$i
    ../../textcleaner -p 10 -g -e stretch -f 10 -t 20 a$i b$i
  done

  rm a*.jpg
}

function enhance2() {
  cd $DIR/coord
  for i in *jpg ; do
    convert $i -level 0%,250% a$i
    convert a$i +level 150%,-250% b$i
  done

  rm a*.jpg
}

function ocr() {
  for i in $DIR/coord/b*jpg ; do
     tesseract $i $i -l $LANG --tessdata-dir ./tessdata/ -psm 6 \
     --user-patterns -\d\d,\d\d\d\d \
     -c tessedit_char_whitelist=-,0123456789 -c tosp_min_sane_kn_sp=8
  done
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
        split_frames
        crop_frames
        ;;
    enhance)
      enhance$TYPE
      ;;
    make)
        extract_data
        ;;
    download)
        download_video
        ;;
    extract)
        ocr
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
