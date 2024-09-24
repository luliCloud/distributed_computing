# Performning container operations with crictl is not as straightforward as we have seen earlier
# in docker and podman. Both docker and podman are user oriented and offer commands that 
# intuitive, easy to customicze and adapt, while abstractingruntime operations, so that 
# the users' focus is on the container config and not on the runtime itself. Therefore, 
# we can simply create or run a container with docker and podman. and the runtime operation
# are automated under the hood.

# Rutimes such as containerd and CRR-O do not come with dedicated command line utilities, 
# as they have been designed to be used in complex env. by container orchestartion tool 
# equipped with sophiscated interfaces to interact with them. Without dedicate command 
# line utilies, it becomes difficult to toubleshoot runtime related issues if users 
# cannot interact with runtime itself, even at a higher level. 

# The solution is crictl, a high level command line utility, that can be customaized 
# to use either containerd, CRI-O, or Docker as its backend runtime. Altough it seems to be as 
# intuitive as the earlier tools, with supported container create adn run commands, among
# others, crictl sues a more complex approach when ruuning containers, by requiring the
# the user to also define an isolated sandbox for the container to be run. This sandbox
# is called a pod, a concept widely used by the Jubernetes container orchestrator, Podman, 
# and even the retired rkt. 

# this lab aims to introduce us to specfiic steps required by crictl in conjunction with
# CRI-O runtime to run containers, exec, stop and remove. As both projects are still 
# maturing, some of teh steps presented here may require extrac care to avoid possible runtime loads
# that may prevent some features from behaving as expected.

# keep in mind that the crictl command needs to run with sudo, and the crio service need to be running
# as well. In case the crio service is not running or its features stop working and the 
# runtime becomes unresponsive, ensure to start or restart teh crio service with 
sudo systemctl start crio.service
sudo systemctl restart crio.service # if needed

# crictl通过两个json files来确定container的 running和config状态
# let's first config the pod sandbox, and the container. The container will run a busybox
# image, which crictl will pull from the registry if not found in the local image cache. 
# The busybox container will run a sleep command for 600 seconds, keeping the container in 
# a running state for 10 minutes before its state chagnes to exited.
vim pod-config.json # i for insert, esc for exit, the input :wq for saving and exit
# input below content in .json file
{
    "metadata": {
        "name": "busybox-sandbox",
        "namespace": "default",
        "attempt": 1,
        "uid": "hdishd83djaidwnduwk28bcsb"
    },
    "log_directory": "/tmp",
    "linux": {
    }
}

vim container-config.json
{
  "metadata": {
      "name": "busybox"
  },
  "image":{
      "image": "busybox"
  },
  "command": [
"sleep" ],
  "args": [
      "600"
  ],
  "log_path":"busybox.0.log",
  "linux": {
  }
}

# the run comamnd takes as arguments the two config files, and it return the container ID
# upon its start. The ps command siplays containers in running state, the container ID, 
# pod ID, iamge, age and the container name. busybox is pulled from the image registry
# but the command is defined by config file.
sudo crictl run container-config.json pod-config.json 
# e1e220ce7b9e3e66a7db55f4f0c7ba2dc940e2cf673d62c7a471e84707166c6a
sudo crictl ps
#CONTAINER           IMAGE               CREATED              STATE               NAME                ATTEMPT             POD ID              POD
#e1e220ce7b9e3       busybox             About a minute ago   Running             busybox             0                   eb8850de97b0c       unknown

# the exec command allows us to run commands inside the container in a non-interactive 
# fashion. and then interactive via a terminal WE will notice that by default, the hostname
# of the container is the pod ID, and not the container ID as we have seen with Docker and podman
sudo crictl exec e1e ps
#PID   USER     TIME  COMMAND
#    1 root      0:00 /pause
#    7 root      0:00 sleep 600
#   12 root      0:00 ps

sudo crictl exec e1e hostname
# eb8850de97b0

sudo crictl exec -it e1e sh # -it same as -ti
# / # ps
#PID   USER     TIME  COMMAND
#    1 root      0:00 /pause
#    7 root      0:00 sleep 600
#   23 root      0:00 sh
#   29 root      0:00 ps
# / # hostname
# eb8850de97b0
# / # exit

# we can display the container's details, such as image info, runtime, command with arg, env, capabilities,
# mount points, permissions, and resources
sudo crictl inspect e1e

# we can display pod's details, such as its status, IP address, pause container image used by
# the runtime to set up and config the pod sandbox resources, runtime, env, capabilites,
# and mounts
sudo crictl inspectp eb8 # inspect+p and [pod num]

# prior to continue with the followings teps, we need remove the container and the pod to 
# reclaim resources. Before their removal, we need to ensure the container and the pod
# are stopped respectively. First, we will stop and remove the container, then we will do the 
# same with the pod, listing resources for validation
sudo crictl stop e1e
sudo crictl ps -a
#CONTAINER           IMAGE               CREATED             STATE               NAME                ATTEMPT             POD ID              POD
#e1e220ce7b9e3       busybox             14 minutes ago      Exited              busybox             0                   eb8850de97b0c       unknown
sudo crictl rm e1e
sudo crictl pods
#POD ID              CREATED             STATE               NAME                NAMESPACE           ATTEMPT             RUNTIME
#eb8850de97b0c       15 minutes ago      Ready               busybox-sandbox     default             1                   (default)
sudo crictl stopp eb8

sudo crictl pods
#POD ID              CREATED             STATE               NAME                NAMESPACE           ATTEMPT             RUNTIME
#eb8850de97b0c       15 minutes ago      NotReady            busybox-sandbox     default             1                   (default)
sudo crictl rmp eb8

# Let's reconfig the pod sandbox, and the container. The container will run a busybox iamge
# whichcrictl will pull form the registry, if not found in the local image cache. The 
# busybox container will run a single echo comamn, keeping the container in a running state
# only for a brief moment, then transitioning in an exited state.
vim pod-config.json
{
    "metadata": {
        "name": "busybox1-sandbox",
        "namespace": "default",
        "attempt": 1,
        "uid": "hdishd83djaidwnduwk28bcsb"
    },
    "log_directory": "/tmp",
    "linux": {
    }
}

vim container-config.json # diff from the above. echo  "Container Fundamentals"
{
  "metadata": {
      "name": "busybox1"
}, "image":{
      "image": "busybox"
  },
  "command": [
      "echo"
], "args": [
      "Container Fundamentals"
  ],
  "log_path":"busybox.1.log",
  "linux": {
  }
}

# the fun command taks as agu the two config files, and it returns the container ID upon
# its start. The ps -a command siplays containers in allstates, the container ID, pod ID, 
# age, and the container name
sudo crictl run container-config.json pod-config.json 
#6c61eae2f09cdb828bf1f5b84fb807d57afe705be8a3c60fdcf552333f006c31
sudo crictl ps -a # noting already exit status
#CONTAINER           IMAGE               CREATED             STATE               NAME                ATTEMPT             POD ID              POD
#6c61eae2f09cd       busybox             4 seconds ago       Exited              busybox1            0                   fe357ccdb96dd       unknown

# we can only view the execution of this conatiner via the logs
sudo crictl logs 6c6
# Container Fundamentals

# we can again remove the container and the pod to reclaim the resources. An easier method to
# remove container s and pods is to remove the pod directly, with the -f to foce the removal
# of active pods. At the end we will list resources for validation
sudo crictl ps -a
#CONTAINER           IMAGE               CREATED             STATE               NAME                ATTEMPT             POD ID              POD
#6c61eae2f09cd       busybox             6 minutes ago       Exited              busybox1            0                   fe357ccdb96dd       unknown
sudo crictl pods
#POD ID              CREATED             STATE               NAME                NAMESPACE           ATTEMPT             RUNTIME
#fe357ccdb96dd       6 minutes ago       Ready               busybox-sandbox     default             1                   (default)
sudo crictl rmp -f fe3
#Stopped sandbox fe3
#Removed sandbox fe3
sudo crictl ps -a
sudo crictl pods

# the container can also be config with a command and no arguments, or a command followed by a more
# complext set of arguments, the following example with the top command and no args will just
# keep the container in a running state, and the while-loop example will run an infinite loop 
# that displays some text, the container hostname and a time stamp every 10 seconds,
# and will keep the container in a running state
vim container-config.json
{ ...
  "command": [
      "top"
  ],
  ...
}

vim container-config.json
{ ...
  "command": [
      "sh"
], "args": [
      "-c", "while [ 1 ]; do echo Container Fundamentals $(hostname) $(date);
sleep 10; done"
], ...
}


