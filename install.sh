#!/bin/bash

git reset --hard
git checkout src
rm *.log*

source ~/.sdkman/bin/sdkman-init.sh

sdk install java 8.0.392-librca
sdk install java 23.1.2.r21-nik
sdk install java 21.0.2-librca
