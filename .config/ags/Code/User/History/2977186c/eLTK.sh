#!/usr/bin/env bash


dir="$HOME/.config/rofi"
theme='appluncher.rasi'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
