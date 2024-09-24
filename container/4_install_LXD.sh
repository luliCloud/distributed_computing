#!/bin/bash
# in an earlier exercise we explored the LXC installation, an Operating System virtulization mechanism
# tha uses the Linux system as a runtime for Linux containers. LXD another tool to mange linux
# Containers, enhances the LXC experience by replacing the LXC set of tools (lxc-create,
# lxc-start, lxc-stop, lxc-info, etc) with a single CLI tool based on a REST API that enables management of 
# remote containers as well. The recommended installation method is via snap, however,
# snap is known to store large amounts of unecessary data on our filesystems. With
# this in mind, we will install LXD directly from the Ubuntu package repository.

# Let's start with a system update and upgrade
sudo apt update
sudo apt upgrade -y

# install LXD
sudo apt isntall -y lxd
lxd version
# 4.0.9

# in order to be able to run LXD as a non-root user, our own user ID needs to be a member of the 
# lxd group. We can validate by running th efollowing coammnd where (lxd) shoudl be a 
# member of the groups list. YOur group id may be different. 
id
# 119(lxd)

# if our own user ID is not a member of the lxd group, we need to add it manually
sudo adduser $USER lxd
newgrp lxd
id