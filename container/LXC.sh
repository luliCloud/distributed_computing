# LXC is an interface for Linux kernel OS level virtualization features. It allows the 
# creation of linux containers, both unprivileged and priviledge. Let's explore both
# aspects.

# initial first
sudo apt update
sudo apt install -y lxc

# create an unprivilieged container as the lu user (no privilege account)
# An unprivileged contiainer is the safest container to deploy in any env. The UID of the 
# contianer's root is mapped to a UID with few or no privileges on the host system. While
# an unprivileged container can be breated by root also, we will explore the lxc config and
# the container creation steps as the lu user. Prior to creating an unprivileged container,
# we have to set the config for UID and GID mapping, and a network device quota that allows
# the unprivileged user to create network devices on the host - which otherwise is not 
# allowed by default. 

# Let's dispaly the UID and GID map defiend for the lu user on the host. (The values associted)
# with the lu user  will be used later to customize the config. 
cat /etc/subuid
# ubuntu:100000:65536
# lu:165536:65536
cat /etc/subgid
# same as the above

# let's add the lu account to a config file which allows the user to create network
# devices on the host, to be then used by the linux containers. 
sudo bash -c 'echo lu veth lxcbr0 10 >> /etc/lxc/lxc-usernet'
cat /etc/lxc/lxc-usernet
# USERNAME TYPE BRIDGE COUNT
# lu veth lxcbr0 10

# let's setup the config file for lxc. First verify that it is not already setup.
# search the config file under current user dir, for all dirs
ls -a ~/ | grep config  # output empty

# Then continue by creating the necessray dir, copy over the default config file,
# ensure it is rea-write enabled, and display its default content:
mkdir -p ~/.config/lxc # mkdir -p 是一个 Linux 命令，用于创建一个目录及其所有必需的父目录。
ls -a ~/.config/
# .  ..  lxc

cp /etc/lxc/default.conf ~/.config/lxc/default.conf
chmod 644 ~/.config/lxc/default/conf
cat ~/.config/lxc/default.conf
# lxc.net.0.type = veth
# lxc.net.0.link = lxcbr0
# lxc.net.0.flags = up
# lxc.net.0.hwaddr = 00:16:3e:xx:xx:xx

# now let's customize the config file with the UID and GID maps of the lu user,
# extracted earlier. 
echo lxc.idmap = u 0 165536 65536 >> ~/.config/lxc/default.conf # not 165536:65536
echo lxc.idmap = g 0 165536 65536 >> ~/.config/lxc/default.conf
cat ~/.config/lxc/default.conf  # successful writing in

# in order to prevet a possible permission error, we need to set an access control list
# on out ~/.local dir. Using the same UID value extracted earlier.
# if no .local: sudo mkdir ~/.local
setfacl -R -m u:165536:x ~/.local
# noting I modified to .config here. as we don't have .local dir

# setfacl 是一个用于设置文件访问控制列表 (ACL) 的命令。这个命令会递归地为用户 ID 为 165536 的用户在当前用户的
# .local 目录及其所有子目录和文件上设置执行权限。

# At this point, we are ready to create an unprivileged container. We will use the downlad
# template which will present us a list of all available images designed to work without
# privileges. Once the image index is displayed, the tool will pause and expect at the 
# prompt three seperate entries from the user at the CLI: distribution, release and architecture.
# for this example ubuntu, xenial and amd64 have been entered respectively at the prompts:
# Note: if an error is caused by the GPG key fetch step, run this
# -- keyserver keyserver.ubuntu.com
lxc-create --template download --name unpriv-cont-user
# noting below is what you need to type manually to finish image download
# Distribution:
## type ubuntu and press ENTER
# Release:
## type xenial and press ENTER
# Architecture:
## type amd64 and press ENTER
# lxc会自动完成后续image index。。。下载

# NOTE:If we already know the desireddistribution,releaseandarchitecturevalues, 
# we can simply runthe following command (pay close attention to the extra set 
# ofdouble hyphens (--)separating the lastthree options from the original command):
# lxc-create --template download --name unpriv-cont-user ----dist ubuntu --release xenial --arch amd

# with the continer created, now we can start it:
lxc-start -n unpriv-cont-user -d

# we can list contained and also display indiviual container details:
lxc-ls -f
# AME             STATE   AUTOSTART GROUPS IPV4 IPV6 UNPRIVILEGED 
# unpriv-cont-user RUNNING 0         -      -    -    true

lxc-info -n unpriv-cont-user
# Name:           unpriv-cont-user
# State:          RUNNING
# PID:            86335
# Link:           veth1001_iSKc
# TX bytes:      796 bytes
# RX bytes:      1.55 KiB
# Total bytes:   2.33 KiB

# we can log into the running container and interact with its env, let's display
# the container hostname, list of process, and OS reelase, then exit the container
lxc-attach -n unpriv-cont-user
# root@unpriv-cont-user:/# 
hostname
# unpriv-cont-user
ps
    # PID TTY          TIME CMD
    # 28 pts/5    00:00:00 bash
    # 32 pts/5    00:00:00 ps

cat /etc/os-release
exit

# stopping and removing a container is quite simple
lxc-stop -n unpriv-cont-user  # may need ctrl+x to kill the process. but already stop if ls
lxc-destroy -n unpriv-cont-user
lxc-ls -f


### CREATE a privileged container (as ROOT user)
# in this situation when a privileged container has to be created, the process is similar
# to an unprivileged contariner, with the only distinction that it is created by the 
# root of the host. Again, we will be required to provide as the CLI prompt the desired 
# distribution, release and architecture fromt the available image index

# noting, 因为是root，所以cont后都不需要加-user
sudo lxc-create --template download --name priv-cont
# ubuntu xenial amd64

# if a prev failed container exist, we can remove it by
# sudo rm -rf ~/.local/share/lxc/unpriv-cont-user (which is the name we created before)

# with teh container created, now we can start it:
sudo lxc-start -n priv-cont -d

# we can list containers, and also display indivudual containers details
sudo lxc-ls -f
#NAME      STATE   AUTOSTART GROUPS IPV4       IPV6 UNPRIVILEGED 
#priv-cont RUNNING 0         -      10.0.3.194 -    false  (notingt is false)
sudo lxc-info -n priv-cont

# we can log into the running container and interact with its env. let's display
# the container hostname, list of processes, and OS release, then exit container:
sudo lxc-attach -m priv-cont 
hostname
ps
cat /etc/os-release
exit 

# stopping and removing a container is quite simple
sudo lxc-stop -n priv-cont
sudo lxc-destroy -n priv-cont
sudo lxc-ls -f