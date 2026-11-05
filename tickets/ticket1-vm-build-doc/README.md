# Ticket 1 — Test machine for the new developer

## 1. What was asked

> From: Aigerim T. (Office Manager)  
> Subject: test machine for new dev
>
> Hi, we have someone starting on Monday and he needs a test computer set up. Nothing special, just so he can try things without breaking anything. Can you write down how to do it so I can do the next one myself? Thanks

## 2. What was actually needed

The request is for a repeatable, isolated test environment, not just another computer. “Without breaking anything” is too broad to implement literally: a test can still damage the guest OS, use up disk space, expose data through shared resources, or affect an external service. I interpreted it as a disposable environment whose guest operating systems can be returned to a known clean state. I used separate virtual machines and clean snapshots for that purpose. A snapshot helps roll back a guest; it is not a backup and does not protect the host or external systems.

Before building this for Aigerim, I would ask:

1. Which applications and development tasks must the new developer run, and are both operating systems required?
2. Which Linux distribution and Windows edition are required by the team's work? Is an evaluation edition acceptable, or does the office have a Windows licence for a VM?
3. Must the two guests run at the same time? Do they need outbound internet, guest-to-guest communication, or both?
4. What host computer will run them, how much RAM and free disk space does it have, and which hypervisor is approved by IT?
5. Does the office network permit virtual-machine traffic, and are there restrictions on bridged networking or inbound connections?

I proceeded on these assumptions because the request supplied no answers: the host has 16 GB RAM and a 475 GB SSD; VirtualBox is available and permitted; the developer needs one Ubuntu Server guest and one Windows 11 guest at the same time; both guests need outbound internet and must be able to reach each other; and the Windows 11 Enterprise Evaluation ISO is acceptable for a temporary course lab. The evaluation ISO is not described as Windows 11 Pro, and this report makes no claim that it supplies a permanent production licence. For an office deployment, IT must provide an edition and licence approved for that use.

### Resource allocation

I assigned 4 GB RAM and 2 virtual CPUs to each guest. If both are running, that reserves 8 GB of the host's 16 GB RAM for the VMs and leaves 8 GB before accounting for the host OS and other applications. This is a practical starting allocation for the lab, not a promise that every workload will remain responsive.

The Ubuntu disk is a dynamically allocated 25 GB VDI. The Windows disk is configured with a 40 GB maximum to meet Windows 11's published minimum storage requirement. The combined maximum virtual capacity is 65 GB. Dynamic allocation grows the host files as data is written; the configured maximum is not the current space consumed. A 475 GB drive capacity does not tell us how much free space is available, so I would check free space before building and leave room for the host, updates, and snapshots.

### Non-default settings and alternatives

- **VirtualBox instead of Hyper-V:** VirtualBox was available for this lab and its GUI makes the VM and network settings straightforward to reproduce from screenshots. Hyper-V would be a reasonable alternative on a managed Windows host, especially where IT already administers it, but it would require different instructions and permissions. I chose one hypervisor so the build can be repeated consistently.
- **Two virtual CPUs per guest:** this gives each guest more than one virtual processor for ordinary setup and development tasks. I would reduce this if the host had fewer available cores or became unresponsive.
- **Dynamically allocated VDI disks:** these avoid immediately reserving the full virtual capacity on the host. The trade-off is that the host can still run out of space as the guests grow, so free space must be monitored.
- **Shared NAT Network instead of separate default NAT adapters:** one shared NAT Network gives both guests outbound connectivity through the host and places them on a common virtual network for the required guest-to-guest test. Separate default NAT adapters are simpler for internet access but do not provide the same shared guest network. Bridged networking could put a guest directly on the office LAN, but that exposes it to the LAN and may be blocked by network policy; it was not needed here.
- **Windows UEFI, Secure Boot, and TPM 2.0:** these settings make the VM meet Windows 11's expected virtual hardware requirements. EFI is enabled in the VM-creation screenshot; TPM 2.0 and Secure Boot must also be enabled and verified in the final VM settings.
- **A scoped inbound ICMPv4 rule on Windows:** Windows initially did not answer the Linux guest's ping. I allowed echo requests for this lab only and kept Windows Firewall enabled, instead of disabling the firewall. This permits the diagnostic check; it is not a general firewall policy.

## 3. What I did

I created the Ubuntu Server guest `lab01-ubuntu` with 4 GB RAM, 2 virtual CPUs, and a dynamically allocated 25 GB VDI. I created the Windows 11 Enterprise Evaluation guest `lab02-windows` with 4 GB RAM, 2 virtual CPUs, and a dynamically allocated 40 GB VDI, attached both VMs to the shared `NatNetwork`, allowed inbound ICMPv4 echo requests on Windows, tested connectivity between the guests and to the internet, and took a clean snapshot of each guest.


The Windows firewall rule used for the connectivity check was:

```powershell
New-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow
```

The build procedure is in [BUILD.md](BUILD.md).

## 4. Evidence

- [`evidence/01-new-vm-wizard.png`](evidence/01-new-vm-wizard.png) — Ubuntu VM creation settings.
- [`evidence/02-disk-settings.png`](evidence/02-disk-settings.png) — Ubuntu disk format, allocation type, and maximum size.
- [`evidence/03-network-adapter.png`](evidence/03-network-adapter.png) — Ubuntu adapter attached to `NatNetwork`.
- [`evidence/04-guest-uname.txt`](evidence/04-guest-uname.txt) — Linux kernel and architecture, including the `uname -a` command.
- [`evidence/05-ping-between-guests.txt`](evidence/05-ping-between-guests.txt) — successful ping output in both guest-to-guest directions.
- [`evidence/05b-guest-ipaddr.png`](evidence/05b-guest-ipaddr.png) — Ubuntu address and route output.
- [`evidence/06-snapshot-list.png`](evidence/06-snapshot-list.png) — Ubuntu snapshot.
- [`evidence/06b-windows-vm-wizard.png`](evidence/06b-windows-vm-wizard.png) — Windows VM wizard showing 4 GB RAM, 2 virtual CPUs, and EFI enabled.
- [`evidence/07b-windows-disk-settings.png`](evidence/07b-windows-disk-settings.png) — Windows disk wizard capture.
- [`evidence/08b-windows-network-adapter.png`](evidence/08b-windows-network-adapter.png) — Windows adapter attached to `NatNetwork`.
- [`evidence/09b-windows-ip.png`](evidence/09b-windows-ip.png) — Windows IP configuration and routes.
- [`evidence/10a-windows-firewall-rule.png`](evidence/10a-windows-firewall-rule.png) — Windows inbound ICMPv4 rule enabled.
- [`evidence/11b-windows-snapshot.png`](evidence/11b-windows-snapshot.png) — Windows snapshot.
- [`evidence/11c-ping-internet`](evidence/11c-ping-internet) — successful internet ping output from both guests.

## 5. What I would do differently
Next time, I would ask the developer which tools and workloads they need before choosing the VM resources. I would then test the setup with those workloads while both guests are running, so I could adjust the CPU, memory, and disk allocations before handing it over.
Next time I would check the Windows 11 virtual hardware requirements before creating the VM, then take a screenshot of the final firmware, Secure Boot, and TPM settings before installing Windows. That would catch the missing TPM configuration earlier and avoid having to revisit the VM after the first build. I would also confirm the Windows edition and licence with the requester before choosing an evaluation ISO.
