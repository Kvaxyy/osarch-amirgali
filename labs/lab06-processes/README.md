# Lab 6 — Live processes and memory pressure

Pair: [имя 1] + [имя 2]  
Date: 2026-11-22  
Guests: Ubuntu [версия], 3.3 GiB RAM; Windows 11 Enterprise Evaluation, RAM [указать]

## Part 1 — One process, three tools

Process chosen: `VBoxSVC.exe` on Windows and the VirtualBox service (`VBoxService`) on Ubuntu. I chose it because the VirtualBox Guest Additions process was available in both guests.

| Metric | Task Manager | Process Explorer | htop / ps |
|---|---:|---:|---:|
| PID | 24032 | 24032 | [нужен PID из строки VBoxService в htop] |
| Parent (name and PID) | Not shown | Not visible in screenshot | [нужен PPID из `ps`] |
| Memory as shown by default | Working set: 34,156 K | Working Set: 34,688 K | RES: [нужно значение процесса VBoxService] |
| Private memory | Not shown | Private Bytes: 14,228 K; WS Private: 12,820 K | Not shown |
| Working set / RES | 34,156 K | 34,688 K | [нужен RES] |
| Virtual size | Not shown | Not shown | [нужен VIRT] |
| Handles / file descriptors | 1,920 handles | 1,922 handles | [нужно число FD, если собрано] |
| Threads | 17 | 17 | [нужно число NLWP/threads] |

### Where the tools disagree

Task Manager reports a working set of 34,156 K, while Process Explorer reports 34,688 K. The values are close but not identical because the tools sample the process at slightly different times. Process Explorer also shows Private Bytes and WS Private separately, while Task Manager shows working set and commit size as separate columns.

The Windows screenshots show 1,920 handles in Task Manager and 1,922 in Process Explorer. This small difference may be due to the tools refreshing at different times.

## Part 2 — Memory pressure

Guest RAM: 3.3 GiB. Swap: 2.0 GiB.

### Measurements

| Stage | Time (UTC) | Available RAM | Swap used |
|---|---|---:|---:|
| Before | 2026-11-22 08:29:47 | 2.9 GiB | 0 B |
| During | 2026-11-22 08:34:47 | 71 MiB | 1.9 GiB |
| After | 2026-11-22 08:42:37 | 2.9 GiB | 52 MiB |

During the experiment, memory availability fell sharply and swap usage increased. The Linux OOM killer terminated `stress-ng-vm` processes when memory was exhausted. After the test, available memory returned to 2.9 GiB and swap usage fell to 52 MiB.

Responsiveness: [опиши своими словами, насколько Ubuntu тормозила во время нагрузки и вернулась ли к нормальной работе после неё.]

### What the kernel did

The kernel OOM killer terminated `stress-ng-vm` processes because the guest ran out of available memory. The log excerpt is saved in `evidence/kernel-log-extract.txt`.

### Windows event log

Command:

```powershell
Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-Resource-Exhaustion-Detector'} -MaxEvents 5 |
  Format-List TimeCreated, Id, Message
