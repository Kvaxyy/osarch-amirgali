## 1. Resource Allocation & Calculation
The host machine has 16 GB of RAM and a 475 GB SSD. To ensure the host remains fully functional while both guest VMs are running, resources were allocated as follows:
- **Linux Guest (Ubuntu 26.04.1):** Allocated 2 GB RAM and 20 GB of dynamically allocated virtual disk space. 2 GB is the recommended minimum for a GUI-based Linux test environment, leaving plenty of room for the host.
- **Windows Guest (Windows 11):** Allocated 4 GB RAM and 40 GB of dynamically allocated virtual disk space. Windows requires at least 4 GB to prevent severe paging/performance degradation.
- **Host Reserve:** This leaves 10 GB of RAM and enough of free disk space for the host machine, preventing any resource starvation or host instability.

## 2. Settings Differing from Default
- **Network Adapter -> "NAT Network" (or Host-Only + NAT):** Changed from the default "NAT". *Why:* Default "NAT" isolates VMs from each other. They need to see each other (per requirements), so they were placed on a custom NAT Network (e.g., `10.0.2.0/24`) or given a second Host-Only adapter.
- **Storage -> Dynamic Allocation:** Explicitly ensured "Dynamically Allocated" was chosen over "Fixed Size". *Why:* To save physical host disk space, as the VM will only consume what it actually uses, rather than blocking 40-60 GB instantly.
- **Processor -> 2 vCPUs for Windows:** Changed from the default 1 vCPU. *Why:* Windows 10/11 is extremely sluggish on a single core; 2 vCPUs provide a usable test environment without overloading a quad-core/octa-core host.

## 3. Network & Visibility Evidence
Both VMs successfully reach the internet and can communicate with each other:
- The Linux VM can ping the Windows VM and vice versa (see `evidence/05-ping-between-guests.txt`).
- Both VMs can resolve external domain names (tested via `ping google.com` or curl).

## 4. Problems Encountered and Resolved
- **Problem:** Initially, the Linux guest could not ping the Windows guest (100% packet loss), even though both machines obtained IP addresses on the same NAT Network subnet (`10.0.2.0/24`) and both had working internet access.
- **Resolution:** Windows Defender Firewall blocks incoming ICMPv4 echo requests by default. Rather than disabling the firewall entirely, an elevated PowerShell session was opened inside the Windows guest and the following rule was added:
  ```powershell
  New-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow
  ```

## 5. Verification Check list for Peer Reviewer
- [ ] Both VM installation ISOs are unmounted after installation.
- [ ] Network adapter is set to NAT Network (allowing both internet access and inter-VM traffic).
- [ ] Windows Firewall is configured to allow ICMP (ping) requests from the same subnet.
- [ ] Guest Additions are installed on both guests (enabling clipboard sharing and resolution scaling).
