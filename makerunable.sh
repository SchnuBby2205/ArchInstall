#!/bin/bash

sed -i -e 's/\r$//' install.sh
sed -i -e 's/\r$//' functions.sh
chmod +x ./*.sh