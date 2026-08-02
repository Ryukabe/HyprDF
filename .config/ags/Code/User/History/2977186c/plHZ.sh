#!/usr/bin/env bash


dir="$HOME/.config/rofi"
theme='applauncher.rasi'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
