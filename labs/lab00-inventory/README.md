# Lab 00 - Inventory

Pair: Amirgali / Kelis    Driver first half: Amirgali
Machine: Host, Windows
Date: 17.10.2026

What I did:
Got information about my pc from PowerShell by using comands.

Result:
| What | Value | Where I got it |
| CPU model, core count and thread count | 13th Gen Intel(R) Core(TM) i5-13420H | Get-CimInstance Win32_Processor |
| Firmware type (BIOS or UEFI), version, date | LENOVO       MCCN27WW          4/2/2024 5:00:00 AM | Get-CimInstance Win32_BIOS |
| Hardware virtualization |Расширения режима мониторинга виртуальной машины: Да. Виртуализация включена во встроенном ПО: Да | systeminfo |
| Total memory, module count, speed | Controller0-ChannelA-DIMM0 8589934592  3200. Controller1-ChannelA       8589934592  3200 | Get-CimInstance Win32_PhysicalMemory, Win32_OperatingSystem |
| Disk model, type, free space | SAMSUNG,MZAL4512HBLU-00BL2 SSD,NVMe. free:3411Mb in total:16108Mb  | Get-PhysicalDisk, Get-Volume |

What did not work the first time
I didn't complete the assignment correctly first time. 

Evidence
- [evidence/cpu.txt](evidence/cpu.txt) - Data about cpu.
- [evidence/memory.txt](evidence/memory.txt) - Data about memory.
- [evidence/disk.txt](evidence/disk.txt) - Data about disk.
- [evidence/BIOs.txt](evidence/BIOS.txt) - Data about BIOS version.
- [evidence/virtualization.txt](evidence/virtualization.txt) - Data about virtualization.
