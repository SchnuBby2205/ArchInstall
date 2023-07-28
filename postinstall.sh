#!/bin/bash
source ./functions.sh

# Mein Arch Installationsscript

# Welcome Screen
clearScreen
myPrint "green" "*************************\n"
myPrint "green" "* Entering postinstall  *\n"
myPrint "green" "*************************\n\n"

installYAY

installYAYPrograms

installPrograms