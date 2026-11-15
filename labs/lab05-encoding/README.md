# Lab 5 — Encoding forensics

Name: Amirgali A. · Date: 2026-11-15 · Tools: Ubuntu guest, Windows PowerShell.

## What I received
- Excel: opened with warnings and appeared blank.
- LibreOffice Calc: opened with warnings and appeared blank.
- Terminal: the original file was identified as non-ISO extended-ASCII text with CRLF line terminators. Decoding as Windows-1251 displayed Kazakh names incorrectly.

## Diagnosis (made before the fix)
- `file` said: `Non-ISO extended-ASCII text, with CRLF line terminators` (`evidence/file-before.txt`)
- First 16 bytes: `49 44 3B D4 E0 EC E8 EB E8 FF 3B C8 EC FF 3B CE` (`evidence/hexdump-before.txt`)
- Encoding: RK1048 — the file has one byte per Cyrillic character; decoding as RK1048 produced readable Russian and Kazakh names. Windows-1251 did not.
- Line ending: CRLF — the hex dump shows `0D 0A` at the end of a line.
- BOM: no — the file starts with `49 44 3B` (`ID;`), not a BOM. I did not add one because the target is UTF-8 and the file should also work with command-line tools.

## Fix

```sh
iconv -f RK1048 -t UTF-8 evidence/staff-broken.csv |
  sed 's/$/\r/' > evidence/staff-fixed.csv
```

## Verification
`file evidence/staff-fixed.csv` reported UTF-8 text with CRLF line terminators. Decoding the fixed file as UTF-8 displayed the Russian and Kazakh names correctly. The file was also opened in Excel, LibreOffice Calc, and a terminal; see `evidence/opens-correctly.png`.

## What did not work the first time
Decoding the file as Windows-1251 did not work: Russian text appeared readable, but Kazakh letters were incorrect. A PowerShell check for legacy code pages also failed because the required encoding provider was unavailable. I identified the source encoding as RK1048 using `iconv` in the Ubuntu guest.
