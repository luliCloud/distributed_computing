# Prior to being able to perform container operation with runc, we need to create 
# a container in an OCI bundle format (?). We will use a busybox Docker container to 
# export its filesystem in a tar archive, and use the extracted filesystem at as the
# rootfs for the runc container. 
# 1. 创建 OCI Bundle. OCI bundle 可以用busybox tar 解压过来
# OCI Bundle 是一个目录结构，包含容器的 root 文件系统（rootfs）和配置文件（config.json）。
# config.json 描述了容器的配置信息，如环境变量、命名空间等。

mkdir -p runc-container/rootfs
# 我们会使用一个 Busybox Docker 容器来导出其文件系统。
# 导出的文件系统会保存为一个 tar 压缩包。我们选择 Busybox 作为基础镜像，
# 因为它体积小且包含了一些基本的 Unix 工具。使用 Docker 可以方便地将 Busybox 容器的文件系统导出。
docker container export \
$(docker container create busybox) \
> busybox.tar  # noting this > must have, is not a default symbol in \ change line
# 这个命令会从library/busyobox拉取image

# 将导出的 tar 压缩包解压，得到文件系统内容，这些内容将作为 runc 容器的根文件系统。
# 将解压得到的文件系统内容放入一个特定的目录（如 rootfs），并在 OCI Bundle 的配置文件中指向这个目录。
tar -C runc-container/rootfs/ -xf busybox.tar
cd runc-container/rootfs/
ls
# bin  dev  etc  home  lib  lib64  proc  root  sys  tmp  usr  var

# aside from rootfs, runc requires a spec config file to start a container. 
# runc allows us to create a sample spec file
cd ..
runc spec # runc create a spec for us
ls
# config.json  rootfs // config.json 是 runc spec 生成的

# display the content of the config.json file. Observe some of the sections in the files, such as 
# process, root, and namespace. The process section specifies a shell process that will 
# run in a temrminal as root (uid 0, gid 0). The root dir of the container is mapped, 
# in a read-only mode., to the roofs generated earlier. Namespace lists all the namespace
# that the container neeeds to have for the isolation of pid, network, ipc, hostname, and
# mount. 
cat config.json
# config.json 文件是 OCI (Open Container Initiative) bundle 的配置文件。
# 它定义了容器的运行环境、资源限制、挂载点和其他重要设置，是容器运行时所需的核心配置文件。
# 当我们在runc-container 中运行 runc spec，会自动帮我们生成config.json, 并将这些生成好

# Now we are ready to run the container. Make sure to leave this terminal window as it is.
# with the running shell from the busybox container. 
sudo runc run busybox
# enter a terminal: / #

# open a 2nd terminal, login in gcp. list container. 
sudo runc list
#ID          PID         STATUS      BUNDLE                    CREATED                          OWNER
#busybox     297049      running     /home/lu/runc-container   2024-06-30T05:23:26.859904435Z   root

# also list the process running insider the busybox container
sudo runc ps busybox
# UID          PID    PPID  C STIME TTY          TIME CMD
# root      297049  297039  0 05:23 ?        00:00:00 sh

# also from a second terminal, list the events of the busybox container. the command will 
# keep outputing events until we stop the stream with Ctrl + C
sudo runc events busybox

# runc allow for a continer to be paused and then resumed. From the second terminal list
# containers and issue the pause command, then list again to confirm the paused status. 
# Return to the first terminal and try to type a command at the shell prompt - type date.
# No command will be registered or executed because the container is paused. Now return 
# to the second terminal and resume the container, listing containers again to confirm
# running status. Return to the first terminal to see that the date command typed
# before is now displayed, together with the expected output. 
sudo runc pause busybox
sudo runc list
# ID          PID         STATUS      BUNDLE                    CREATED                          OWNER
# busybox     297049      paused      /home/lu/runc-container   2024-06-30T05:23:26.859904435Z   root

sudo runc resume busybox # date cannot be enetered in first terminal
sudo runc list

# the container status can be displayed, again, from the second termianl window.
sudo runc state busybox

# There are a few methods to delete this container. From the second terminal, as it is running
# we need to supply the -f option to force the delete command. If the container stopped, then 
# -f woudl not be necessary. Another method would be to exit out of the shell running in
# the first terminal window, which would terminate the shell process running the busybox 
# container. and as a result, the busybox container will be removed as well. We will run the
# delete -f container from the second terminal:
sudo runc delete -f busybox
sudo runc list

# on the first termianl the prompt has already return to the lu@ubuntu, since the runc 
# container was delted. No command is expected below. this is only show the 
# current prompt.
# / # lu@ubuntu:~/runc-container$ 