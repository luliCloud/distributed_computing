# CRI-O 没办法安装。因为release一直找不到。可能之后去官网找教程。先搁置在这里
# 另外 如果因为release repo没找到导致apt 不work，一直报错，显示E。可以根据error中的信息找到所在文件删除
# grep -rn "message" /etc/apt

#!/bin/bash
# Although CIO-O is not entended to be used directly uby iusers. we will explore the install method
# of the CRI-O pacakge on Ubuntu, followed by the installation of crictl., a Beta CLI
# designed to allow users to interact with the simple container runtimes such as CRI-O and containerd
sudo apt udpate

# As root, set the OS variable to the appropriate value that reflects the current OS
# and the VERSION variable to match the desired Jubernetes version (1.21)

# check current OS version
cat /etc/os-release
# output:
# NAME="Ubuntu"
# VERSION="20.04.6 LTS (Focal Fossa)". we just need to 20.04

# login as root user
sudo -i
OS=xUbuntu_20.04
VERSION=1.21
VERSION_ID=20.04

# add new repo with the following four commands, run as root, then exit
# every command must write in one line. don't break. otherwise wrong
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list


echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list

curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | apt-key add -

curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | apt-key add -

exit

# udpate package index
sudo apt update

# Install CRI-O packages:
sudo apt install -y cri-o cri-o-runc

# Display CRI-O version
crio --version
