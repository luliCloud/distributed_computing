#!/bin/bash
# Docker Engine has many installation options. While for Mac and Windows there is the Docker
# Desktop, for Linux distributions there are repositories including software packages of the docker
# components. Let's install on Ubuntu the Docker Engine from the offical Docker repo

# To avoid any possible incompatiblities, it requires several steps for system cleanup, 
# repo setup and for package installation. Let's remove all related prev installed 
#  packages -docker, containerd, and runc

sudo apt remove docker docker.io containerd runc # I removed docker-engine from this command
# as E: Unable to locate package docker-engine, and will not remove all other options

# update packages
sudo apt update 

# install packages required for HTTPS repository
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# add docker GPG key 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# add the stable repo, don't make it into several parts
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# udpate package
sudo apt update

# Install the latest version of Docker Engine
sudo apt install -y docker-ce docker-ce-cli containerd.io 

# Display the version of the docker Engine components. We may notice that Docker does not
# use the latest release of containerd and runc. Installed in earlier exercises:
sudo docker version

# verify the installation by runninng a test image
sudo docker run hello-world # will pull from the library/hello-world
# Hello from Docker!
# This message shows that your installation appears to be working correctly.

#To generate this message, Docker took the following steps:
# 1. The Docker client contacted the Docker daemon.
# 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
#    (amd64)
# 3. The Docker daemon created a new container from that image which runs the
#    executable that produces the output you are currently reading.
# 4. The Docker daemon streamed that output to the Docker client, which sent it
#    to your terminal.

# We can managed the Docker daemon with systemd
sudo systemctl status docker.service 

# inorder to manage Docker as a non-root user, we need to create a group called docker and add our user ID to it:
sudo groupadd docker

# groupadd: group 'docker' already exists
# if you see the above output, then the docker group already exists on your Docker host.
# it is safe to proceed to the next step
sudo usermod -aG docker $USER
# usermod: change usermod; -aG: append to Group. docker is the appended group. $USER 
# is currently logged in user.

# Docker 安装时，通常会创建一个名为 docker 的用户组。将用户添加到 docker 组后，
# 该用户就可以通过 Docker 客户端与 Docker 守护进程进行通信。将用户添加到 docker 组后，
# 用户无需使用 sudo 即可运行 Docker 命令。这并不是因为 docker 组本身具有 root 权限，而是因为 
# Docker 守护进程的设计方式允许 docker 组的成员与 Docker 守护进程进行通信，从而执行需要特权的操作。

# after we modify the group, generally we should reboot the system. but we can do 
# newgrp instead
newgrp docker

# verify the installation again, this time without sudo
docker run hello-world
