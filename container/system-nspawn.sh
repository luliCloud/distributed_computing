# Another method of creating an isolated virtual environment where an application or 
# an entire operating system could run is by creating a systemd-container. Subsequently, 
# this container can be managed with systemd tools. 

# install the container tool
sudo apt update
sudo apt install -y systemd-container

# let's bootstrap a Debain base system in a targe dir of the host system, more precisely
# in /home/lu/DebianContainer. Debootstrap can only run as root:
sudo debootstrap --arch=amd64 stable ~/DebianContainer

# Bootstrap
# Bootstrap 一般指初始化一个系统或环境，使其能够从最基础的状态启动并运行。这包括安装必要的工具、库和配置文件，使系统能够进行进一步的安装和配置。

# debootstrap （注意不是卸载前面的bootstrap系统,而是安装deblian related boodstrap）
# debootstrap 是一个专门用于创建 Debian 基本系统的工具。它允许用户在没有现有 Debian 安装的情况下，通过从 Debian 仓库中下载并解压缩基础系统的文件来创建一个最小化的 Debian 环境。

# now we can safely create a container from the dir where the Debian base system is
# running. Again, we neet to be root. With the container running, we can display its OS 
# release file for validation. 
sudo systemd-nspawn -D ~/DibianContainer
cat /etc/os-release

# leave the current terminal open with the running DebianContainer, and open a second terminal
# on the same host Cloud. From the second terminal let's list containers and display
# container details
# 注意这里我们要在VS打开第二个bash，然后ssh GCP，然后输入以下命令
sudo machinectl list
# MACHINE         CLASS     SERVICE        >
# DebianContainer container systemd-nspawn >
#1 machines listed.

sudo machinectl status DebianContainer 
#DebianContainer(179dbb9a798a41c7937fb8b50>
#           Since: Mon 2024-06-10 22:09:06>
#          Leader: 100186 (bash)
#         Service: systemd-nspawn; class c>
#            Root: /home/lu/DebianContainer
#              OS: Debian GNU/Linux 12 (bo>
#            Unit: machine-DebianContainer>
#                  └─payload
#                    └─100186 -bash

# The container can be terminated from within or from outside (from the second terminal)
# from within the container we may run logout or exti command. 
exit

# while from the second terminal we may run 
sudo machinectl terminate DebianContainer # first nspawn has exit
sudo machinectl list
# No machines. 
