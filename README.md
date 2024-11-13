# ArchInstall
-  My own installation script for Arch Linux.

# Install
- With cfdisk
  - curl https://raw.githubusercontent.com/SchnuBby2205/ArchInstall/main/ArchInstall.sh -o ./ArchInstall.sh && chmod +x ./ArchInstall.sh && ./ArchInstall.sh --option 1 --cfdisk y --disk [diskname] --boot [bootpartition] --swap [swappartition] --root [rootpartition] --hostname [hostname] --user [non root username]
    
- Without cfdisk
  - curl https://raw.githubusercontent.com/SchnuBby2205/ArchInstall/main/ArchInstall.sh -o ./ArchInstall.sh && chmod +x ./ArchInstall.sh && ./ArchInstall.sh --option 1 --boot [bootpartition] --swap [swappartition] --root [rootpartition] --hostname [hostname] --user [non root username]

The position of the arguments of the ./ArchInstall.sh script are flexible.

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

curl https://raw.githubusercontent.com/SchnuBby2205/ArchInstall/main/ArchInstall.sh -o ./ArchInstall.sh && chmod +x ./ArchInstall.sh && ./ArchInstall.sh --option 1 --boot /dev/nvme0n1p1 --swap /dev/nvme0n1p2 --root /dev/nvme0n1p3 --hostname ArchLinux --user schnubby

Add --cfdisk y and --disk /dev/nvme0n1 to partition the disk beforehand.

If necessary arguments are missing. Or no arguments supplied at all, the script will ask for them with an interactive menu.
