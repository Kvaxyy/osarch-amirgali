## 1. Resource Allocation & Calculation
The host machine has 16 GB of physical RAM and a 475 GB SSD. To ensure the host OS remains completely stable while both guest virtual machines run simultaneously, resources were allocated as follows:
- **Linux Guest (`lab01-ubuntu` / Ubuntu Server 26.04.1 LTS):** Allocated 4 GB RAM and 25 GB of dynamically allocated virtual disk space. 4 GB of memory and 2 vCPUs provide sufficient performance for testing developer backend services and containers without causing physical host strain.
- **Windows Guest (`lab02-windows` / Windows 11):** Allocated 4 GB RAM and 40 GB of dynamically allocated virtual disk space. Windows 11 requires a minimum of 4 GB to prevent severe disk paging and performance degradation.
- **Host Reserve Calculation:** 
  - RAM: $16\text{ GB (Host)} - (4\text{ GB [Linux]} + 4\text{ GB [Windows]}) = 8\text{ GB}$ reserved strictly for the host OS.
  - Disk: $475\text{ GB (Host SSD)} - (25\text{ GB [Linux]} + 40\text{ GB [Windows]}) = 410\text{ GB}$ guaranteed free disk overhead (with initial actual disk usage being under 30 GB due to dynamic allocation).

## 2. Settings Differing from Default
- **Network Adapter -> "NAT Network":** Changed from the default isolated "NAT" mode. *Why:* Default NAT prevents virtual machines from discovering or communicating with each other. By placing both guests on a shared "NAT Network" (`NatNetwork`, subnet `10.0.2.0/24`), both VMs retain external internet access while belonging to the same broadcast domain.
- **Storage -> Dynamically Allocated VDI:** Selected dynamic allocation over fixed-size virtual disks. *Why:* This prevents VirtualBox from immediately reserving 65 GB on the host SSD, consuming disk space only as files are written inside the guests.
- **Processor -> 2 vCPUs for Both Guests:** Increased from the default 1 vCPU allocation. *Why:* Modern operating systems (especially Windows 11 and compilation tasks on Linux) experience noticeable CPU bottlenecks on a single virtual core; 2 vCPUs per VM provide a responsive environment without oversubscribing the physical host CPU.

## 3. Network & Visibility Evidence
Both guests successfully reach the external internet and have verified mutual network visibility:
- **Assigned IPs:** Windows guest is assigned `10.0.2.4`, Linux guest is assigned `10.0.2.5`.
- **Inter-Guest Communication:** Bidirectional ICMP communication was verified with 0% packet loss (documented in `evidence/05-ping-between-guests.txt`).
- **External Internet Access:** Verified via successful DNS resolution and packet exchange to external gateways from both machines.

## 4. Problems Encountered and Resolved
- **Problem:** Initially, the Linux guest (`10.0.2.5`) could not ping the Windows guest (`10.0.2.4`), resulting in 100% packet loss, despite both machines successfully obtaining IP addresses and having outbound internet access.
- **Resolution:** By default, Windows Defender Firewall drops all unsolicited incoming ICMPv4 echo requests. Instead of disabling the firewall completely, an elevated PowerShell terminal was opened inside the Windows guest and the following targeted inbound rule was executed:
  ```powershell
  New-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow
Immediately after adding this firewall rule, the Windows guest began responding to ping requests, and mutual network reachability was fully established.

5. Verification Checklist for Peer Reviewer
[ ] Both VM installation ISOs are unmounted after installation.

[ ] Network adapters are assigned to NAT Network (NatNetwork).

[ ] Inbound ICMPv4 firewall rule was executed in Windows PowerShell.

[ ] Bidirectional ping between 10.0.2.4 and 10.0.2.5 succeeds with 0% packet loss.

[ ] Snapshot restore point (Fresh Install & Network Configured) is present for the environment.
