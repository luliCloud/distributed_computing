# pull an image from the docker hub registry to the local repo, 
# to start exploring container operations supported by docker. 
docker image pull alpine
docker image ls

# create a container from the image available in the local repo. This comamnd does not start the
# container, it only creates it. Since we are not providing a name for the container, the
# runtime will assign a random name
docker container create -it alpine sh
# below is the container id, not container name. We always use id to identify the container
# 2dc79913e575757dcad3b26b745bdc15926f922a143e259bd568161607ff3b57

# start the created container, using a partial container ID. The container will start the sh
# program, as we provided as a COMMAND argument.
docker container start 2dc

docker container ls
# CONTAINER ID   IMAGE          COMMAND                  CREATED              STATUS         PORTS                                       NAMES
# 2dc79913e575   alpine         "sh"                     About a minute ago   Up 6 seconds                                               intelligent_burnell

# Running a container instead of creating & starting. The -t option allocates a pseudo-TTY,
# and the -i option keep the STDIN open in interactive mode. Both -i and -t options can be 
# combined into a -it or -ti notation. all with the same effect. The --name option allow the 
# myapline name to be assigned to the running container, instead of allowing the runtime to 
# pick a random name for it
docker container run -it --name myalpine alpine sh

# Detaching from a running container ensures the container remains running. By pressing the 
# Ctrl + p + Ctrl + q key combination in the terminal of running container. 
# but vscode does not support this method. 
# instead, we can type 
exit # to exit the whole container but not just detach the container (detach means the
# container keep running in the back)

# another way to run the container, name it, and make it running in the back
docker container run -itd --name myapline alpine sh
# db705cb657c06aa5aeeff595dd8e99b5746dd2a92988e7120b9d64535c082305
docker container ls
#CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                       NAMES
#db705cb657c0   alpine         "sh"                     12 seconds ago   Up 11 seconds                                               myapline
#2dc79913e575   alpine         "sh"                     18 minutes ago   Up 17 minutes                                               intelligent_burnell

# we can attach a running container 
docker start db7
docker container attach myalpine
# output: / # 

# we can run a container in the background with -d option. in which case we receive an output
# with the container ID. this example will run an infinite while-loop inside the container. 
docker container run -d alpine sh -c 'while [ 1 ]; do echo "hello world from container"; \
sleep 1; done'
# ad7beeac52a370e1fccdbf30050020d1d1484cd8ddd7d358f96cf9be6da95dad

# display container logs
docker container logs ad7
# hello world from conttainer
# hello world from conttainer
# hello world from conttainer 
# ...

# stop a running container
docker container stop ad7
# list all containers (ruuuning and stopped)
docker container ls -a  # up to indicating this container still running
# so we can check all container using this command and stop any running container

# start a stopped container
docker container start ad7

# restaring a container. This command !!!stops!!! a container first and then starts it again.
docker container restart ad7

# pausing and resuming a container
docker container pause ad7
docker container ls -a  # a (pause) appear after up 22 seconds
# ad7beeac52a3   alpine         "sh -c 'while [ 1 ];…"   10 minutes ago      Up 22 seconds (Paused)                  exciting_bassi
docker container unpause ad7
docker container ls -a # pause disappear

# renaming a running container. Let's rename the ad7... container, from exciting_bassi
# to hello_world_loop
docker container rename exciting_bassi hello_world_loop
docker container ls 
# CONTAINER ID   IMAGE     COMMAND                  CREATED        STATUS          PORTS     NAMES
# ad7beeac52a3   alpine    "sh -c 'while [ 1 ];…"   11 hours ago   Up 23 seconds             hello_world_loop

# Deleting or removing a container, There are two seperate options available to remove 
# containers. The default command that removes stopped containers, and a force option to
# remove running containers
docker container stop hello_world_loop 
docker container rm hello_world_loop 
docker container ls -a

docker container rm -f myalpine

# auto remove a container upon its exit. In order to automate the removal process, to avoid
# repetitive task to manually find terminated containers and manually remove them, we can automate
# the removal process by passing the --rm option when we run the container. As a result, we will
# no longer see terminated containers in their stopped state. 
docker container run --rm --name auto_rm alpine ping -c 3 google.com
# --rm：在容器终止后自动删除容器。
# --name auto_rm：将容器命名为 auto_rm，便于管理和识别。

# setting the host name of a container. Unless we explicitly set the hostname of a container 
# with the -h option, by default, at runtime, the container hostname is set to the container
# ID:
docker container run -h alpine-host -it --rm alpine sh
# / # hostname
# alpine-host
# / # exit
# 在使用 Docker 容器编排工具（如 Docker Compose 或 Kubernetes）时，
# 主机名可以用于容器之间的通信。一个容器可以通过主机名解析来找到另一个容器，并与之进行通信。
# -it 选项组合用于创建一个交互式终端会话，使你能够与容器进行交互。

# set the current working dir with the -w option. 将一个容器的工作目录射到指定位置
 docker container run -it -w /tmp/mypath --rm alpine sh
# /tmp/mypath # pwd
# /tmp/mypath
# /tmp/mypath # exit

# set an environment variable of a container and assign a value to it. We are setting the
# WEB_HOST environment var of the container, and assign an IP address to it
docker container run -it --env "WEB_HOST=172.168.1.1" --rm alpine sh
# / # env
#HOSTNAME=adc26101587d
#SHLVL=1
#HOME=/root
#TERM=xterm
#PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
#PWD=/
#WEB_HOST=172.168.1.1
# / # exit

# 指定命令的重要性：在docker 结尾的sh
#在一些镜像中，默认命令可能并不是一个交互式 shell。在这种情况下，如果你不指定一个交互式命令，容器可能会立即退出。
#例如，某些镜像可能默认运行一个守护进程或其他非交互式命令。

# set the ulimit of a container. ulimit is a command line tool to manage resource limits for 
# users. It return current limits for the users, but it also set such resource limits. Let's
# display all the default limits on a new alpine container. 
docker container run -it --rm alpine sh
# / # ulimit -a
#core file size (blocks)         (-c) unlimited
#data seg size (kb)              (-d) unlimited
#scheduling priority             (-e) 0
#...
# / # exit

# by default, user processes are unlimited. Let's try to limit max user processes. By setting
# a limit we restrict the num of processes this container can create:
docker container run -it --ulimit nproc=10 --rm alpine sh

# display all the details of a container, such as  host name, ip address, attached volumnes
# image, and network config
docker container ls
docker container inspect 2dc # or longer id len, but the first 3 char is enough

# Restrict the host CPU(s) that are allowed to execute a container. We can set a single CPU, 
# or a range of CPUs that are allowed to execute the container. In the previous full output 
# of the insepect comamnd, there were no such restriction. In this exercise, let's restrict
# the container to be executed only by CPU '0'
docker container run -d --name cpu-set --cpuset-cpus="0" alpine top 
# -d or -- detach 后台运行容器并返回容器 ID。

# let's verify the new setting by inspecting the container 
docker container inspect cpu-set | grep -i cpuset # -i 忽略大小写进行搜索
#            "CpusetCpus": "0",
#            "CpusetMems": "",

# now it's safe to remove the container
docker container rm -f cpu-set

# we can also set the amount of memory of a container. By default, from the pre full output
# of the inspect command, the value is set to '0'. if the VM is provisioned on a local 
# hypervisor such as Virtual Box, you may see a warning message that can be ignore. Otherwise,
# the command will only return the container ID. Let's set the value:
docker container run -d --name memeory --memory "200m" alpine top
docker container inspect memeory | grep -i mem
#        "Name": "/memeory",
#            "Memory": 209715200, ...
docker container rm -f memeory 

# create a new process inside a running container, a feature very useful for debugging.
# Let's execute a new process inside a container by running a command that retreives and 
# lists the IP address of the container. As soon as the command finishes, the newly forked
# process also get terminated. 
docker container start 2dc # start in the background
docker container ls
#CONTAINER ID   IMAGE     COMMAND   CREATED        STATUS         PORTS     NAMES
#2dc79913e575   alpine    "sh"      22 hours ago   Up 9 seconds             intelligent_burnell
docker container exec intelligent_burnell ip a

# set the restart policy of a container. An always restart policy restarts the container
# every time it fails. An on-failure policy, however, allow us to control the num of restart
# of the container as a result of several failures - set to 3 in the example below:
docker container run -d --restart=always --name web-always nginx
# c34531a712ab05a8dc32c32457f7467dd78d190cd5f700d6e94d23d0cc9eeb4b
docker container ls
# CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS          PORTS     NAMES
# c34531a712ab   nginx     "/docker-entrypoint.…"   8 seconds ago   Up 7 seconds    80/tcp    web-always
# 2dc79913e575   alpine    "sh"           
docker container run -d --restart=on-failure:3 --name web-on-failure nginx

# we can copy files between the host system and a running container. This example will 
# overwrite the index.html file of teh nginx webserver running in a container. and the
# verification step will include the display of the container IP and finally a curl command to display
# the new web page served by the webserver. 
echo Welcome to Container Fundamentals! > host-file
docker container cp host-file web-on-failure:/usr/share/nginx/html/index.html
# Successfully copied 2.05kB to web-on-failure:/usr/share/nginx/html/index.html
docker container inspect --format='{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' web-on-failure 
# 172.17.0.4
curl 172.17.0.4
# Welcome to Container Fundamentals!

# labeling a container
docker container run -d --label env=dev nginx
# 这是添加一个标签，格式为 key=value。在这个例子中，标签的键是 env，值是 dev。
# 标签可以用于描述容器的环境、用途、版本等信息，有助于管理和组织容器。

# filtering container lists. We can filter containers by specifying conditions, to control
# and limit the output only to the desired obj. In this example, let's use the label created
# pre as a filter. 
docker inspect c6a | grep -A 2 -i "labels" # inspect the Labels contents
#            "Labels": {
#                "env": "dev",
#                "maintainer": "NGINX Docker Maintainers <docker-maint@nginx.com>"
docker container ls --filter label=env=dev

# remove all (running and stopped)container with one command. But first, let's explore
# the -q option of the ls command that lists only the congtainer IDs:
docker container ls -q # noting -q only list the running one 
docker container rm -f `docker container ls -q` # noting the ``
docker container ls
# CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

# change the default executable that runs at container startup. if defined, a default executable runs
# when a container starts. An nginx container start with /usr/bin/nginx -g daemon off. 
# we can change it by passing another command with possible arg when running the container. 
# Let's start a container from the nginx image, but with a running shell instead
docker container run -it nginx sh # no further command, exit the container


# privieged container. In privileged mode, containers gain permission to access devices on 
# the host. by default, it is disabled and containers run in un-privilieged mode. Let's 
# demo privileges by running two container in un-privileged and priivileged mode respectivel.
# while attempting to change host network setting, that is to create a simple alias to a 
# network device. 
