#!/bin/sh
set -eu

in="evidence/staff-broken.csv"
out="evidence/staff-fixed.csv"
tmp="${out}.tmp"

iconv -f RK1048 -t UTF-8 "$in" > "$tmp"
printf '\357\273\277' | cat - "$tmp" > "$out"
rm "$tmp"
