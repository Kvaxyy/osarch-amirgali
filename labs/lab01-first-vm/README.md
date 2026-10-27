## Lab 1.
Pair: Amirgali/Kelis Driver: Amirgali Machine: windows 10 virtualbox Date:17.10.2026
## What I did:
Created a virtual machine running ubuntu server. I allocated 2 vCPUs because it is the recommended amount and is well below half of my host's Intel i5-13420H cores. I gave it 4 GB of RAM out of my total 16 GB, which leaves enough memory (about 12 GB) for my Windows host to run smoothly. For storage, I set up a 25 GB dynamically allocated disk so it only uses space as needed, placed on my main volume which has enough free space.
## Result:
| What                       | Value                                  | Where I got it / Source                                    |
| :------------------------- | :------------------------------------- | :--------------------------------------------------------- |
| Virtual Machine Name   | lab01-ubuntu                         | VirtualBox Manager                                         |
| Server Name (Hostname) | lab1                   | /etc/hostname                                            |
| Username               | amirgali                                  | System Prompt / Login                                      |
| Guest OS Version       | Ubuntu 26.04.1 LTS                     | lsb_release -a (evidence/guest-release.txt)            |
| VM Resources           | 2 vCPU, 4 GB RAM, 25 GB Disk           | VirtualBox Settings (evidence/vm-settings.png)           |
| Recovery Status        | Successful rollback to clean-install | VirtualBox Snapshot Manager (evidence/snapshot-list.png) |

## What did not work for the first time:
Accidentally instaled wrong version of ubuntu. After looking at step by step guide understood my mistake and downloaded right version.
## Evidence:
- [evidence/vm-settings.png](evidence/vm-settings.png) — CPU, memory and disk as configured
- [evidence/guest-release.txt](evidence/guest-release.txt) — Ubuntu Server is running in the guest
- [evidence/broken.png](evidence/broken.png) — the guest in its broken state
- [evidence/snapshot-list.png](evidence/snapshot-list.png) — the snapshot, after the rollback
- [evidence/hostname-after-rollback.png] — the cat /etc/hostname after rollback
