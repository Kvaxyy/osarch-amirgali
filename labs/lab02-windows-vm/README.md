# Lab 2 — A Windows guest, and a network between them

Pair: Aruzhan Amirgali / Aiganym Kelis   Driver first half: Aruzhan Amirgali
Machine: host, Windows, 16 Gb RAM, 8 cores, guests Ubuntu Server + Windows 11 Enterprise eval
Date: 25.10.2026

## What I did
1. Downloaded Windows 11 Enterprise evaluation. Licence: https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise
2. Created lab02-windows: 2 vCPU, 4 GB, 64 GB thin, UEFI + Secure Boot, vTPM.
3. Network mode: Nat network, both guests. Why: Standard NAT isolates each VM behind its own router so they cannot communicate, Bridged mode is often blocked by campus Wi-Fi, and Host-Only lacks internet. NAT Network puts both guests in a single shared subnet so they can reach each other while maintaining routed internet access
4. Ping Ubuntu → Windows timed out because Windows Defender Firewall treats the fresh connection as a Public network and blocks incoming ICMPv4 echo requests by default. Fixed with: New-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow
5. Overcommitment: set 10 GB + 10 GB on a 16 GB host.

## Network diagram
              Internet
                 |
      Host laptop 192.168.0.15
                 |
     [VMware NAT · VMnet8 · 10.0.2.0/24]
          /                        \
    lab01-ubuntu               lab02-windows
    10.0.2.5/24                   10.0.2.4/24
## Result
| | Before | After |
|---|---|---|
| Host RAM in use | 8.4 GB | 15.7 GB |
| Available | 7.3 GB | 73.4 MB |
| Committed / Swap used | 13.6/27.7 GB | 25.8/27.7 GB |
| What I noticed | — | Everything started to work really slow. I waited about a minute just to open task manager. Mouse freezed approximately once a minute for a couple of seconds. |

## What did not work the first time
After switching the adapter to NAT Network in VirtualBox, running "ip -br a" in Ubuntu still displayed the old IP (10.0.2.15), and pings between the VMs failed with 100% packet loss. Turns out VirtualBox did not update the link state or release the cached DHCP lease while the VM was actively running. So I completely shut down Ubuntu, confirmed both VMs shared the same NAT Network profile, and powered Ubuntu back on to receive the correct IP (10.0.2.5)

## Evidence
- [evidence/ipconfig-windows.txt](evidence/ipconfig-windows.txt) — Windows address
- [evidence/ip-addr-linux.txt](evidence/ip-addr-linux.txt) — Ubuntu address
- [evidence/ping-both-ways.txt](evidence/ping-both-ways.txt) — both directions and the internet
- [evidence/host-memory-before.png](evidence/host-memory-before.png) — host memory, guests off
- [evidence/host-memory-after.png](evidence/host-memory-after.png) — host memory, both guests overcommitted
