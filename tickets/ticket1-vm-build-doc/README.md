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
- **Problem:** Initially, the Linux guest could not ping the Windows guest, even though both were on the same NAT network. The Windows guest ignored all incoming ICMP requests.
- **Resolution:** This is due to the default Windows Defender Firewall policy, which blocks inbound ICMPv4 echo requests. Inside the Windows guest, the "File and Printer Sharing (Echo Request - ICMPv4-In)" rule was enabled in the Advanced Firewall settings. After applying this, ping packets were successfully received and answered. 

## 5. Verification Check list for Peer Reviewer
- [ ] Both VM installation ISOs are unmounted after installation.
- [ ] Network adapter is set to NAT Network (allowing both internet access and inter-VM traffic).
- [ ] Windows Firewall is configured to allow ICMP (ping) requests from the same subnet.
- [ ] Guest Additions are installed on both guests (enabling clipboard sharing and resolution scaling).
