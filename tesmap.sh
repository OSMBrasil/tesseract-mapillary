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


# TODO import variables from "source"?

# TODO description (comment only)


# Check dependencies

function is_ok() {
    which $1 > /dev/null 2>&1
    return $?
}

function passing() {
    is_ok $1 || ( echo "Lacks dependency: $1" && exit 1 )
}

function dependencies_check()
{
    passing "youtube-dl"
    passing "ffmpeg"
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

function reduce1() {  # TODO
    # Cortando a parte com a camada dos dados e o capô do carro
    echo
}

function reduce2() {  # TODO
    # Cortando as coordenadas
    echo
}

function reduce3() {  # TODO
    # Cortando as datas
    echo
}

function crop_frames() {  # TODO
    # call reduce1
    # call reduce2
    # call reduce3
    # TODO rename the tree functions above?
    echo
}

# TODO main

function download_video() {  # TODO
    echo
}

function adjust_constrast() {  # TODO (optional use)
    echo
}

function extract_data() {  # TODO
    echo
}

# TODO parsing

# info
# download
# adjust (optional)
# make
# all
# help
