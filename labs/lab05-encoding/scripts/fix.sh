#!/bin/sh
set -eu

in="evidence/staff-broken.csv"
out="evidence/staff-fixed.csv"
tmp="evidence/staff-fixed.tmp"

iconv -f RK1048 -t UTF-8 "$in" > "$tmp"
sed 's/\r*$//' "$tmp" |
  sed 's/$/\r/' > "$out.tmp"
printf '\357\273\277' | cat - "$out.tmp" > "$out"
rm "$tmp" "$out.tmp"
