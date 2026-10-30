# Build Document: Setting Up Test Machines for the New Developer

This document provides step-by-step instructions to build a dual-guest test environment (Ubuntu Server and Windows 11) from scratch using Oracle VM VirtualBox.

---

## Part 1: Installing the Linux Guest (Ubuntu)

### Step 1: Create the Virtual Machine
Open VirtualBox and click **New**. Set the VM name to `lab01-ubuntu`, select **Linux** / **Ubuntu (64-bit)**, and attach the Ubuntu Server ISO. Allocate **4096 MB (4 GB)** of RAM and **2 vCPUs**. Check "Skip Unattended Installation" to perform a manual setup.
![New VM Wizard](evidence/01-new-vm-wizard.png)
*Why this option:* Allocating 4 GB of RAM and 2 virtual CPUs ensures sufficient system headroom for running test backend services and background processes without starving the physical host machine.

### Step 2: Configure Virtual Storage
In the disk setup screen, choose **Create a Virtual Hard Disk Now**, set the file type to **VDI**, select **Dynamically allocated**, and set the size to **25.00 GB**.
![Disk Settings](evidence/02-disk-settings.png)
*Why this option:* Dynamic allocation reserves disk space on the host physical drive only as data is written (initial footprint is ~5.4 GB), preventing the hypervisor from locking 25 GB of physical storage immediately.

### Step 3: Configure Shared Network Adapter
Open the VM's **Settings** -> **Network** -> **Adapter 1**. Ensure "Enable Network Adapter" is checked, set "Attached to" to **NAT Network**, and select the network profile named **NatNetwork**.
*(Note: If no NAT Network exists yet, create one globally via VirtualBox Tools -> Network -> NAT Networks -> Create).*
![Network Adapter Settings](evidence/03-network-adapter.png)
*Why NAT Network and not default NAT:* The default "NAT" setting isolates virtual machines from one another. "NAT Network" functions as a virtual switch with a built-in DHCP server, allowing guests to talk to each other while sharing internet access via the host.

### Step 4: Install OS and Verify Environment
Start the VM and follow the standard Ubuntu installation steps. Set the user account (username `amirgali`, server name `lab1`, and password `password123`). 
After the installation completes and the system reboots, unmount the ISO, log in, and verify the kernel by running:
```bash
uname -a
```
*Why this step:* Running `uname -a` immediately confirms that the 64-bit Linux kernel is active, the guest OS is healthy, and the environment is ready for developer tasks.
> Check: Verify that the terminal reports the active 64-bit Linux kernel. The captured output is stored in `evidence/04-guest-uname.txt`.

---

## Part 2: Installing the Windows Guest

### Step 5: Create the Windows Virtual Machine
In the VirtualBox main interface, click **New**. Name the virtual machine `lab02-windows`, select **Microsoft Windows** as the Type, and select **Windows 11 (64-bit)** as the Version. Attach the Windows 11 installation ISO. Allocate **4096 MB (4 GB)** of RAM and **2 vCPUs**. Ensure "Skip Unattended Installation" is selected to retain control over setup parameters.
*Why this option:* Windows 11 requires a strict minimum of 4 GB of RAM and dual virtual cores to operate stably; assigning less causes intense storage swapping and system freezes during testing.

### Step 6: Configure Virtual Hard Disk for Windows
Select **Create a Virtual Hard Disk Now**, choose **VDI (VirtualBox Disk Image)**, set storage type to **Dynamically allocated**, and set the disk size to **40.00 GB**.
*Why this option:* Windows 11 base installations require ~20–25 GB. A 40 GB limit gives enough capacity for testing runtimes and tools, while dynamic allocation ensures physical host disk space is consumed only as real files are written.

### Step 7: Configure Windows Shared Network Adapter
Go to `lab02-windows` -> **Settings** -> **Network** -> **Adapter 1**. Ensure "Enable Network Adapter" is checked, set "Attached to" to **NAT Network**, and select the identical profile name **NatNetwork**.
*Why this option:* Placing both the Windows and Ubuntu VMs on the identical "NatNetwork" switch connects them to the same virtual subnet (`10.0.2.0/24`), enabling direct packet exchange between the test environments.

### Step 8: Install Windows OS and Configure Account
Start the virtual machine and proceed through the Windows Setup wizard:
1. Select language and keyboard layout, then click **Install Now**.
2. When prompted for activation, select **I don't have a product key** and choose **Windows 11 Pro**.
3. Choose **Custom: Install Windows only (advanced)** and install on the unallocated 40 GB drive.
4. During initial setup (OOBE), set up a local offline account with username `lab02-windows` and password `password123`.
*Why this option:* Using Windows 11 Pro with an offline local account prevents Microsoft Cloud account lockouts, ensuring any developer or manager can immediately log in without corporate credentials.

---

## Part 3: Inter-VM Connectivity and Baseline Preservation

### Step 9: Configure Windows Firewall for Ping Reachability
Log in to the Windows guest. Right-click the Start button, select **Terminal (Admin)** or **PowerShell (Admin)**, and run:
```powershell
New-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow
```
*Why this option:* By default, Windows Defender Firewall silently drops all unsolicited incoming ICMPv4 echo requests. This command creates a targeted inbound rule for ICMP Type 8 without disabling the entire firewall, preserving security while enabling mutual reachability testing.

### Step 10: Verify Network Reachability Between Guests
Confirm IP address assignments and verify mutual bidirectional communication:
1. On Linux, execute `ip addr` to check the assigned address (configured as `10.0.2.5`).
2. On Windows, execute `ipconfig` in PowerShell/CMD to check the assigned address (configured as `10.0.2.4`).
3. From the Linux terminal, ping the Windows guest:
```bash
ping -c 4 10.0.2.4
```
4. From the Windows PowerShell terminal, ping the Linux guest:
```powershell
ping 10.0.2.5
```
*Why this step:* Testing communication in both directions guarantees that both guest operating systems can resolve each other's network stacks without asymmetric packet loss.
> Check: Both commands must show 4 packets transmitted, 4 received, and 0% packet loss (logged in `evidence/05-ping-between-guests.txt`).

### Step 11: Take a Baseline Snapshot
Shut down both `lab01-ubuntu` and `lab02-windows`. For each virtual machine, navigate to the **Snapshots** tab in VirtualBox, click **Take**, and name the snapshot `Fresh Install & Network Configured`.
![Snapshot List](evidence/06-snapshot-list.png)
*Why this option:* A test machine is intended to be modified, experimented on, and potentially broken. Capturing a snapshot at this clean stage guarantees that the developer or manager can restore both guests back to a known working baseline in seconds.
