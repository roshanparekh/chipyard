#!/bin/bash

set -e

while [ "$1" != "" ];
do
    case $1 in
        -c | -compile )
            cmake -S ./ -B ./build/ -D CMAKE_BUILD_TYPE=Debug ;;
        -t | -test )
            shift
            cmake --build ./build/ --target ${1} ;;
        * )
            error "invalid option $1"
    esac
    shift
done
