#!/bin/sh
# Convert the complete CSV from RK1048 to UTF-8 without a BOM.
# iconv preserves the CRLF bytes already present in the source.
set -eu

in="evidence/staff-broken.csv"
out="evidence/staff-fixed.csv"

iconv -f RK1048 -t UTF-8 "$in" > "$out"
