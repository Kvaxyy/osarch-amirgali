# Build Document: Setting Up Test Machines for the New Developer

This document describes how to build a Linux (Ubuntu) and a Windows guest machine from scratch using VirtualBox.

---

## Part 1: Installing the Linux Guest (Ubuntu)

### Step 1: Create a New Virtual Machine
In VirtualBox, click the **New** button. Name the VM `Dev-Linux-Test`, choose **Linux** (Ubuntu 64-bit), and set the Memory to **2048 MB** (2 GB).
![New VM Wizard](evidence/01-new-vm-wizard.png)
*Why this is done:* 2 GB of RAM is the sweet spot for a lightweight Linux desktop that needs to run test scripts without choking, while leaving the manager’s or developer's host machine fully responsive.

### Step 2: Configure Virtual Hard Disk
Select "Create a virtual hard disk now", choose **VDI (VirtualBox Disk Image)**, and select **Dynamically allocated**. Set the size to **20 GB**.
![Disk Settings](evidence/02-disk-settings.png)
*Why "Dynamically allocated" and 20 GB:* It only takes up space on your physical drive as the VM fills it up, saving you host space. 20 GB is plenty for a basic Linux environment and test packages.

### Step 3: Network Configuration
Before starting, go to the VM's **Settings** -> **Network**. Change the "Attached to" dropdown to **NAT Network** (or add a second "Host-Only" adapter if you don't have a NAT network pre-configured).
![Network Adapter Settings](evidence/03-network-adapter.png)
*Why NAT Network and not standard NAT:* Standard NAT isolates VMs completely, meaning they can see the internet but cannot talk to each other. A "NAT Network" creates a shared virtual switch, enabling both VMs to access the internet and ping each other.

### Step 4: Install OS & Check System Info
Mount the Ubuntu ISO, start the VM, and follow the on-screen prompt to install Ubuntu. Use the default username `developer` and password `password123`.
Once installed, open the terminal and run:
`uname -a`
Take a screenshot or grab the text output to verify the OS is running.
*(Refer to `evidence/04-guest-uname.txt` for the system validation).*

---

## Part 2: Installing the Windows Guest

### Step 5: Windows VM Creation & Resource Assignment
Click **New**, name it `Dev-Win-Test`, select **Windows 10/11 (64-bit)**. Allocate **4096 MB (4 GB)** of RAM and **2 vCPUs** (under the processor tab).
*Why:* Windows 10/11 is virtually unusable with less than 4 GB of RAM and 1 CPU core due to constant background processes. This ensures the developer doesn't experience freeze-ups.

### Step 6: Virtual Disk Allocation
Allocate **40 GB** dynamically. Follow the standard Windows installer wizard. Choose "I don't have a product key" and select **Windows 10/11 Pro** if prompted.
Create a local offline account (e.g., `developer` / `password123`).

---

## Part 3: Connecting and Verifying the Environment

### Step 7: Configure Windows Firewall for Connectivity
Because Windows blocks incoming ping requests by default, we must allow them so the Linux machine can verify the network.
1. In Windows, search for "Windows Defender Firewall with Advanced Security".
2. Click **Inbound Rules** in the left sidebar.
3. Scroll down to find **File and Printer Sharing (Echo Request - ICMPv4-In)**.
4. Right-click and choose **Enable Rule**.
*Why:* Without this, the Linux VM will never get a response from Windows, making network troubleshooting and collaborative testing impossible.

### Step 8: Network Connectivity Tests
From the Linux terminal, find your IP using `ip addr` (e.g., `10.0.2.4`) and ping the Windows IP.
From the Windows Command Prompt (`cmd`), find your IP using `ipconfig` (e.g., `10.0.2.5`) and ping the Linux machine.

> Check: Execute `ping <other_vm_ip>` on both guest VMs. You should see active replies.
*(Refer to `evidence/05-ping-between-guests.txt` for the capture of the ping command outputs).*

### Step 9: Take a Virtual Machine Snapshot
With both machines running correctly, shut them down. In VirtualBox, select each VM, go to the **Snapshots** tab, and click **Take** to create a restore point named `Fresh Install & Network Configured`.
![Snapshot List](evidence/06-snapshot-list.png)
*Why:* A test machine is designed to be broken. A snapshot allows the developer to mess up the configuration completely and restore back to this exact working point in 2 seconds.
