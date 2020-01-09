#!/usr/bin/env bash

#set the permission to read-only for other users
dir=/workdir
inotifywait -m -r -e create --format '%w%f' "$dir" | while read f; do
    if [[ -d "$f" ]]; then
        chmod 775 "$f"
    fi
done
inotifywait -m -r -e create --timefmt '%y-%m-%d %H:%M' --format '[%T] <%w%f> : %e' "$dir" | while read f; do
    if [[ -d "$f" ]]; then
        chmod 775 "$f"
    fi
done
