#!/bin/bash
# The Podman runtime for OCI and Docker containers, runs both privileged and unprivileged containers
# wrapped in a container pod. The container pod is extensively used by Kubernetes, and it was
# used by rkt as well. Beginning with Ubuntu 20.10, the Podman package can be installed
# directly from the ofiicial repo. For prior OS release, such as ours, the Podman
# package can be installed via the kubic project (the one chosen in GCP is older, 20.04)

# Let's install Podman. First source the host OS version information, to make it
# availabe as environment var to subsequent comments
. .etc/os-release
#`.`：这是 source 命令的简写。source 命令用于在当前 shell 会话中执行指定文件的内容，
# 而不是启动一个子 shell 来执行文件。
# 你在 shell 中执行 . /etc/os-release 时，shell 会读取 /etc/os-release 文件的内容，并将其中定义的变量加载到当前 shell 会话的环境变量中。例如：你在 shell 中执行 . /etc/os-release 时，shell 
# 会读取 /etc/os-release 文件的内容，并将其中定义的变量加载到当前 shell 会话的环境变量中.

# you can also do 
VERSION_ID="20.04"
echo $VERSION_ID # to confirm the var value in current env

# add teh repo to the list of apt source
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list

# retrive the specific release key (must write in one line)
curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | sudo apt-key add -

# update package index and upgrade
sudo apt update
sudo apt upgrade -y

# install 
sudo apt install -y podman

# once install, let's verify the version
podman --version
#podman version 3.4.2
