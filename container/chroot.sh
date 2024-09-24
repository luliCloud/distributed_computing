#!/bin/bash
# in this exercise we will explore chroot's ability to change the apparent dir for a process.
# The setup will require an installation of a Debain-based guest system in a subdir of our 
# Ubuntu host system. Although similar to the installation of a guest OS virtual machine,
# this scenario is missing the hypervisor component, allowing the guest OS to be installed 
# directly on top of the host OS, while allowing the host kernel to manage the guest as well.

# The tool required to install the Debain based guest on an existing running host is 
# debootstrap. It installs a Debian based guest in a subdir of our Ubuntu system (in GCP).
# install debootstrap
sudo apt udpate
sudo apt install -y debootstrap

# now let's set up a subdir on our host system for the guest
sudo mkdir /mnt/chroot-ubuntu-xenial
# / 是根目录。 /下有/bin，/etc， /home，/usr， /var，等
# ~ 符号代表当前用户的家目录。
# 例如，如果当前用户是 john，则 ~ 可能代表 /home/john（或在 macOS 上为 /Users/john）。

# install an Ubuntu Xenial guest suite in the target subdir 
sudo debootstrap xenial /mnt/chroot-ubuntu-xenial http://archive.ubuntu.com/ubuntu/
# sudo debootstrap <suite> <target> <mirror>
# suite这个版本名称代表了 Debian 项目的一个特定开发阶段，例如稳定版（stable）、
# 测试版（testing）或不稳定版（unstable），
# 或者具体的发行版代号，比如 "buster", "bullseye" 或对于 Ubuntu "focal", "bionic" 等。

# before verifying the guest installation with chroot, let's verify the version
# of our Ubuntu OS system
cat /etc/os-relrease

# Now, with chroor, let's open a shell into the newly install guest OS system.
# Every subsequence command will run inside the chrooted env as the new root of
# /mnt/chroot-ubuntu-xenial/
sudo chroot /mnt/chroot-ubuntu-xenial/ /bin/bash
cat /etc/os-release
# it is different from what we see in ubuntu host OS 

# we can safely exit the chrooted environment and return to the lu user in the host OS
exit
