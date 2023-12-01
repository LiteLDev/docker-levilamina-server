#! /usr/bin/env sh

apk add --no-cache curl gcompat wine 

curl -sSL https://github.com/lippkg/lip/releases/latest/download/lip-linux-amd64.tar.gz | tar -xz -C /usr/local/bin lip
chmod +x /usr/local/bin/lip
