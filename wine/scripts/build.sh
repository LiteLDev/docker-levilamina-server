#! /usr/bin/env sh

apk add --no-cache curl gcompat wine

curl -sSL https://github.com/lippkg/lip/releases/latest/download/lip-windows-amd64.zip | unzip -q -j - lip.exe
