# Let's create a container, which will also trigger an image fetch if the desied iamge is not 
# found in the local image cache. The container will remain in a created state until we
# explicitly start the container, when it becomes a running container. Since we are not 
# providing a name for the new container, the runtime will randomly pick a name for it. 
# (objective_elgamal in the below example). Then
# we list container to see whether the container is running. 
podman container create -it alpine sh
podman container ls
podman container ls -a
# CONTAINER ID  IMAGE                            COMMAND     CREATED         STATUS      PORTS       NAMES
# 18786d630b5e  docker.io/library/alpine:latest  sh          15 seconds ago  Created                 objective_elgamal

# Now let's start the container and list container again
podman container start 187
podman container ls
#CONTAINER ID  IMAGE                            COMMAND     CREATED             STATUS            PORTS       NAMES
#18786d630b5e  docker.io/library/alpine:latest  sh          About a minute ago  Up 9 seconds ago              objective_elgamal

# Let's attach to the running container, and validate its hostname, which by default 
# is teh container ID. List the container's processes and detach from the container with 
# ctrl + p + ctrl + q (not in vs code). We use exit to leave the container (and also stop).
podman container attach 187
# / # hostname
# 18786d630b5e
# / # ps
#PID   USER     TIME  COMMAND
#    1 root      0:00 sh
#    3 root      0:00 ps
# / # exit
podman container ls
# CONTAINER ID  IMAGE       COMMAND     CREATED     STATUS      PORTS       NAMES

# inspect the config details
podman container inspect 187

# a simplified method to run a container is the run command. It incorporates a fetch if needed,
# a create and a start. Let's run a container and manually set its hostname with -h. The 
# container will be removed/deleted auto once it exit --rm
podman container run -h alpine-host -it --rm alpine sh
# / # hostname
# alpine-host
# / # exit
# Hostname（主机名）：用于容器内部的网络标识,container 内部看到的计算机名称，可以通过 --hostname 选项设置。
# Container Name（容器名）：用于宿主机上的容器管理，可以通过 --name 选项设置。

# let's run a container with an infinite while-loop, output its logs, then stop and 
# start the container
podman container run -d alpine sh -c 'while [ 1 ]; do echo "hello world from container"; \
sleep 1; done'
# 491ea8d84064ff515cf1e3f56299c6963e8e095cf4c464503e04d1cde869572c

podman container logs 491
podman container ls
#CONTAINER ID  IMAGE                            COMMAND               CREATED         STATUS             PORTS       NAMES
#491ea8d84064  docker.io/library/alpine:latest  sh -c while [ 1 ]...  40 seconds ago  Up 40 seconds ago              busy_volhard

podman container stop 491
podman container ls
podman container start 491
podman container ls

# let's run a container that exits after a set number of ping executions. and it is auto removed
# once exited
# 注意 rm 是remove 所以用--。它不是-r和-m的结合
podman container run --rm --name auto_rm alpine ping -c 3 google.com
# now let's force the removal of a running container with -f option
podman container rm -f 491

# exec allow for commands to be run inside a running container. Running a shell in the container
# allow users to directly interact with the container env. exec can run non-interactive mode and
# in interactive terminal mode with the -ti options. We can also run installers, validators,
# display the env or a set of permissions from the container. Let's copy content from the host
# system into a running container, and validate the content. 
echo Welcom to Container Fundamentals! > host-file
podman container run -d --name host-content nginx
# /usr/share/nginx/html/index.html 是从容器的根目录 / 开始的路径。在这个例子中，
# 文件将被复制到容器内的 /usr/share/nginx/html/index.html 位置。
podman container cp host-file host-content:/usr/share/nginx/html/index.html
# 如果目标路径在容器中不存在，podman container cp 命令不会自动创建目录结构。你需要确保目标路径的目录已经存在，否则会报错。

# non-interactive
podman container exec host-content cat /usr/share/nginx/html/index.html
# Welcom to Container Fundamentals!

# interactive 
podman container exec -ti host-content sh
# # cat /usr/share/nginx/html/index.html
# Welcom to Container Fundamentals!
# # exit

# let's remove all non-running containers with prune:
podman container ls -aq
podman container prune
podman container ls -aq