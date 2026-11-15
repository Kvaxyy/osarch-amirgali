# !/bin/sh
# Convert the original RK1048 CSV to UTF-8, keeping CRLF line endings.
iconv -f RK1048 -t UTF-8 evidence/staff-broken.csv |
  sed 's/$/\r/' > evidence/staff-fixed.csv
