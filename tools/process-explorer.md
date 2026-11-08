# Process Explorer — who is using this file?

**Presented:** Nov 9, Aruzhan A./Aiganym K.

## The problem

Windows sometimes refuses to delete, move, or replace a file because another program has it open. The message says the file is in use, but it may not tell us which program is holding it. Guessing and closing programs one by one wastes time and can interrupt unrelated work.

## What we showed

Open Process Explorer and use **Find → Find Handle or DLL** (or press **Ctrl+F**). Search for the file name or part of its path. The results show which process has a matching open handle. Select a result to locate the process, then close the file in that application and retry the operation.

For a safe demonstration, use a temporary test file held open by a PowerShell process, then find `locked-demo.txt` in Process Explorer. Release and remove the test file after the demo. Avoid forcing a handle closed: that can cause data loss or make the application unstable.

## When to reach for it

Use Process Explorer when Windows reports that a file is in use and you do not know which process owns it. It is useful when the program has no obvious window or when several applications may be involved. If the error already names the application, close the file there first. Resource Monitor (`resmon.exe`) can also search handles; Process Explorer offers a convenient searchable view alongside its process details.

## Installing

- Windows: Download Process Explorer from [Microsoft Sysinternals](https://learn.microsoft.com/sysinternals/downloads/process-explorer), extract it, and run `procexp.exe` or `procexp64.exe`.
- Linux: Process Explorer is Windows-only. For a similar file-owner lookup, install `lsof` with `sudo apt install lsof`, then run `lsof /path/to/file` (use `sudo` if needed).

