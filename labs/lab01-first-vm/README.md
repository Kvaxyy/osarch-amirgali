Lab 1.
Pair: Amirgali/Kelis Driver: Amirgali Machine: windows 10 virtualbox Date:17.10.2026
What I did:
Created a virtual machine running ubuntu server. I allocated 2 vCPUs because it is the recommended amount and is well below half of my host's Intel i5-13420H cores. I gave it 4 GB of RAM out of my total 16 GB, which leaves enough memory (about 12 GB) for my Windows host to run smoothly. For storage, I set up a 25 GB dynamically allocated disk so it only uses space as needed, placed on my main volume which has enough free space.
Result:
What| Value| Source|
VM name| lab| virtualbox manager|
Server name|lab1 | /etc/hostname|
username|amirgali|system prompt/login|
guest OS version| ubuntu 26.04.1 LTS| lsb_release -a|
VM resources| 2 vCPU, 4GB RAM, 25GB disk| VM setting|
What did not work for the first time:
Accidentally instaled wrong version of ubuntu. After looking at step by step guide understood my mistake and downloaded right version.
Evidence:
- evidence/vmSettings.png- VM settings.
- evidence/guest-release.png- lab_release -a output.
- evidence/broken.png - deleting the hostname file wich broke the VM.
- evidence/Snapshot.png - snapshot of the working VM called clean-install and successful rollback.
