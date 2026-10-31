# Ticket 1 — Test machine for the new developer

## 1. What was asked

> From: Aigerim T. (Office Manager)  
> Subject: test machine for new dev
>
> Hi, we have someone starting on Monday and he needs a test computer set up. Nothing special, just so he can try things without breaking anything. Can you write down how to do it so I can do the next one myself? Thanks

## 2. What was actually needed

The request asks for a repeatable, isolated test environment and instructions that another person can follow. It does not specify the host computer's available memory, free disk space, hypervisor, Linux distribution, Windows edition or licensing, whether both guests must run at once, or whether they need internet access and communication with each other. I would clarify those requirements and confirm whether the office network permits virtual-machine networking.

For this build, I assumed the host has 16 GB of RAM and a 475 GB SSD, that VirtualBox is the hypervisor, and that the two guests should be usable together, reach the internet, and communicate for testing. I used Ubuntu Server 26.04.1 LTS and Windows 11, with a shared VirtualBox NAT Network named `NatNetwork`. Confirm the host figures and Windows licensing status before submission; attach evidence for the host figures and network configuration if available.

### Resource allocation

Each guest was assigned 4 GB of RAM and 2 virtual CPUs. If both run simultaneously, they use 8 GB of the host's 16 GB RAM, leaving a nominal 8 GB for the host and other processes. This is an allocation calculation, not a guarantee that the host will remain responsive under every workload.

The Linux virtual disk has a 25 GB maximum and the Windows virtual disk a 40 GB maximum; both use dynamically allocated VDI files. Their combined maximum virtual capacity is 65 GB. Dynamic allocation grows the host files as guest data is written, so `475 - 65 = 410 GB` is only the arithmetic capacity remaining before accounting for the host OS, other files, and actual disk usage. It is not measured free space.

### Non-default settings and reasons

- **2 virtual CPUs per guest:** selected to give each operating system more than one virtual core for ordinary development and setup tasks. Actual suitability depends on the host CPU and workload.
- **Dynamically allocated VDI disks:** selected so the host files grow with guest data rather than immediately occupying the full configured virtual capacity.
- **Shared NAT Network (`NatNetwork`):** selected to give both guests outbound connectivity through the host and place them on a shared virtual network for guest-to-guest testing. Unlike separate default NAT adapters, a shared NAT Network supports communication between its attached guests.
- **Inbound ICMPv4 echo rule on Windows:** added after the initial ping failed, to allow the specific connectivity check without turning off Windows Firewall.
- **Windows 11 Pro and a local account:** the build document specifies these choices. Verify that the Windows installation is appropriately licensed and that the account setup steps match the Windows installer version being used.

## 3. What I did

I created an Ubuntu Server guest named `lab01-ubuntu` with 4 GB RAM, 2 virtual CPUs, and a 25 GB dynamically allocated VDI disk. I created a Windows 11 guest named `lab02-windows` with 4 GB RAM, 2 virtual CPUs, and a 40 GB dynamically allocated VDI disk. I attached both guests to the same NAT Network, configured Windows to allow inbound ICMPv4 echo requests, checked connectivity in both directions, and took a baseline snapshot of each guest.

The detailed numbered procedure, commands, screenshots, and reasons for the build choices are in [BUILD.md](BUILD.md). The Windows firewall rule used was:

```powershell
New-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow
```

The peer reviewer should follow `BUILD.md` literally and record the first step that is unclear or cannot be completed. Add their feedback under `review/feedback-from-<surname>.md` after the peer review.

## 4. Evidence

## Evidence checklist

The current evidence directory contains:

- `evidence/01-new-vm-wizard.png`
- `evidence/02-disk-settings.png`
- `evidence/03-network-adapter.png`
- `evidence/04-guest-uname.txt`
- `evidence/04b-ubuntu-install.png`
- `evidence/05-ping-between-guests.txt`
- `evidence/05b-guest-ipaddr.png`
- `evidence/06-snapshot-list.png`
- `evidence/06b-windows-vm-wizard.png`
- `evidence/07b-windows-disk-settings.png`
- `evidence/08b-windows-network-adapter.png`
- `evidence/09b-windows-ip.png`
- `evidence/10a-windows-firewall-rule.png`
- `evidence/11b-windows-snapshot.png`
- `evidence/11c-ping-internet`

## 5. What I would do differently

At first, the Ubuntu VM could not ping the Windows VM, even though both guests had IP addresses on the same NAT Network. I checked that the Windows adapter was enabled and confirmed that the guests could communicate after allowing inbound ICMPv4 echo requests with a targeted Windows Firewall rule. I kept the firewall enabled instead of turning it off completely. After adding the rule, the bidirectional ping test succeeded with no packet loss
