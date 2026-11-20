#!/bin/sh
# Lab 5: convert staff-broken.csv from KZ-1048 (iconv name RK1048) to UTF-8
in=evidence/staff-broken.csv
out=evidence/staff-fixed.csv
iconv -f RK1048 -t UTF-8 "$in" > "$out"                       
# line endings: CRLF kept on purpose (Windows/Excel), no change
printf '\357\273\277' | cat - "$out" > tmp && mv tmp "$out"  
