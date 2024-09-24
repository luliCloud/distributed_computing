# In addition to public registries, such as Docker Hub and quay.io, Docker is capable of 
# interacting with private registries as well. Let's set up a private registry, by running 
# Docker's own registry container iamge.
# 私有registry是公司或组织自己运行的，别人不能access。方便存放一些敏感的不能公开的image 或 image hub
docker run -d -p 5000:5000 --restart=always --name registry registry:2

# With the registry running in a "registry" container, we mapped the container's port 
# 5000 to the host port 5000 so that we can access it via local host. The private registry 
# currently does not hold any images. So let's populate it by pulling an iamge from the public 
# registry Docker Hub, tag it and push it into the private registry, while listing local
# cache registries to validate
docker image pull alpine:3.14 # pull an image from the docker public hub, 3.14 is the version
docker images # validate alpine has been pulled

# tag it with localhost:5000/myalps; localhost:5000 is the private registry
# 不打标签直接推送镜像到新的位置会导致错误，因为 Docker 需要明确知道推送目标位置与本地镜像的对应关系。
# 正确的操作流程是先为镜像打上目标标签，
# 再进行推送。这样可以确保 Docker 能够找到正确的镜像并推送到指定的注册表和命名空间。
docker image tag alpine:3.14 localhost:5000/myalps
docker images

# push the newly tagged image to the private registry. Now localhost:5000/myalps is the ref of 
# alpine:3.14
docker image push localhost:5000/myalps

# Now we will remove the two cached iamges alpine:3.14 and localhost:5000/myalps:
# 注意删除远程image的步骤是不一样的 这个image rm命令只会删除本地registry中的image
docker image rm alpine:3.14
docker image rm localhost:5000/myalps
docker images

# pull the imagefrom the private registry
docker image pull localhost:5000/myalps
docker images

# after successfully validating the private registry can store container image. and it can 
# be used to push and pull images to and from ti, lets remove images that are no longer needed
docker image rm -f registry:2
docker image rm localhost:5000/myalps
