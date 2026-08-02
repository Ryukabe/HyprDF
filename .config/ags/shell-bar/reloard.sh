#!/bin/bash

ags quit &>/dev/null

sleep 0.5

ags run ~/01.Project/ags/shell-bar/app.tsx &
disown

