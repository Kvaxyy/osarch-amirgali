# Lab 5 — Encoding forensics

Name: Amirgali A. · Date: 2026-11-20 · Tools: Ubuntu guest, Windows PowerShell, Excel, LibreOffice Calc

## What I received

- Excel: the original CSV opened with warnings and appeared blank.
- LibreOffice Calc: the original CSV opened with warnings and appeared blank.
- Terminal: `file` reported non-ISO extended-ASCII text with CRLF line terminators. Decoding as Windows-1251 displayed Kazakh letters incorrectly.

## Diagnosis (made before the fix)

- `file` said: `Non-ISO extended-ASCII text, with CRLF line terminators` (`evidence/file-before.txt`).
- First 16 bytes: `49 44 3B D4 E0 EC E8 EB E8 FF 3B C8 EC FF 3B CE` (`evidence/hexdump-before.txt`).
- Encoding: RK1048. In the source bytes, `A3` decodes to `Ә` in RK1048; Windows-1251 did not display the Kazakh names correctly.
- Line ending: CRLF. The hex dump shows `0D 0A` at the end of a line.
- BOM: no in the original; the first bytes are `49 44 3B` (`ID;`), not a BOM. The fixed file has a UTF-8 BOM (`EF BB BF`), added by `scripts/fix.sh` so Excel on Windows can recognize UTF-8 when opening the CSV directly.
- Separator: semicolon (`;`), visible between the CSV fields in the header and data rows.

## Fix

Run from `labs/lab05-encoding/`:

```sh
sh scripts/fix.sh
```
The script runs:
```
iconv -f RK1048 -t UTF-8 evidence/staff-broken.csv > evidence/staff-fixed.csv
```
It converts the original file to UTF-8, keeps the existing CRLF line endings, does not add a BOM, and leaves the semicolon separator unchanged.
## Verification
- file evidence/staff-fixed.csv reports UTF-8 text with CRLF line terminators (evidence/file-after.txt).
- The fixed file has 16 lines: one header and 15 data rows.
- The fixed CSV uses `;` as its separator, starts with the UTF-8 BOM `EF BB BF`, and displays the Russian and Kazakh names correctly.
- evidence/opens-correctly.png shows the complete fixed CSV open in Excel, LibreOffice Calc, and a terminal.
## What did not work the first time
Decoding the source as Windows-1251 left Kazakh letters incorrect. A PowerShell attempt to check legacy encodings also failed because the required encoding provider was unavailable. I compared the output from iconv in Ubuntu and identified RK1048.
