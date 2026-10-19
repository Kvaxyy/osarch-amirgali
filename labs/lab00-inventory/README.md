# Lab 00 - Inventory

Pair: Amirgali / Kelis    Driver first half: Amirgali
Machine: Host, Windows
Date: 17.10.2026

## What I did:
Got information about my pc from PowerShell by using comands.

## Result:
| What                       | Value                                                    | Where I got it                                                    |
| :------------------------- | :------------------------------------------------------- | :---------------------------------------------------------------- |
| CPU Model & Cores      | 13th Gen Intel(R) Core(TM) i5-13420H , 8 cores, 12 threads           | Get-CimInstance Win32_Processor                                 |
| Total Memory           | 16 GB (3200 MHz)                                 | Get-CimInstance Win32_PhysicalMemory                            |
| Disk Models            | SAMSUNG,MZAL4512HBLU-00BL2 SSD,NVMe.    | Get-PhysicalDisk                                                |
| Free Disk Space        | free:55,3Gb in total:512Gb                       | Get-Volume                                                      |
| Firmware Type          | LENOVO       MCCN27WW          4/2/2024 5:00:00 AM  | Get-CimInstance Win32_BIOS                                      |
| Virtualization Enabled | Расширения режима мониторинга виртуальной машины: Да. Виртуализация включена во встроенном ПО: Да                                                      | (Get-CimInstance Win32_Processor).VirtualizationFirmwareEnabled |


## What did not work the first time
Everything worked.

## Evidence
- [evidence/cpu.txt](evidence/cpu.txt) - Data about cpu.
- [evidence/memory.txt](evidence/memory.txt) - Data about memory.
- [evidence/disk.txt](evidence/disk.txt) - Data about disk.
- [evidence/bios.txt](evidence/bios.txt) - Data about BIOS version.
- [evidence/virtualization.txt](evidence/virtualization.txt) - Data about virtualization.
