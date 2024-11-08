# ArchInstall
-  Installation Script for Arch Linux
-  ArchInstall.sh = ArchInstall through the archinstall script from archiso
-  ArchInstall_man.sh = ArchInstall through manual install less output
-  ArchInstall_det.sh = ArchInstall through manual install verbose (recommended)

# Install
curl https://raw.githubusercontent.com/SchnuBby2205/ArchInstall/main/ArchInstall.sh -o ./ArchInstall.sh && chmod +x ./ArchInstall.sh && ./ArchInstall.sh

curl https://raw.githubusercontent.com/SchnuBby2205/ArchInstall/main/ArchInstall_man.sh -o ./ArchInstall.sh && chmod +x ./ArchInstall.sh && ./ArchInstall.sh 1 [disk] y/n [bootpartition] [swappartition] [rootpartition] [hostname] [non-root-username]

curl https://raw.githubusercontent.com/SchnuBby2205/ArchInstall/main/ArchInstall_det.sh -o ./ArchInstall.sh && chmod +x ./ArchInstall.sh && ./ArchInstall.sh 1 [disk] y/n [bootpartition] [swappartition] [rootpartition] [hostname] [non-root-username]

# Example
- Download Script
- Set Runflag (rwx) 
- Start with
  - Disk nvme0n1
  - No partitioning (cfdisk)
  - bootpartition nvme0n1p1
  - swappartition nvme0n1p2
  - rootpartition nvme0n1p3
  - Hostname = ArchLinux
  - Non-root-username = schnubby
curl https://raw.githubusercontent.com/SchnuBby2205/ArchInstall/main/ArchInstall_det.sh -o ./ArchInstall.sh && chmod +x ./ArchInstall.sh && ./ArchInstall.sh 1 /dev/nvme0n1 n /dev/nvme0n1p1 /dev/nvme0n1p2 /dev/nvme0n1p3 ArchLinux schnubby
