# Crictl, the CLI tool designed for CRI compatible runtimes such as CRI-O, containered,
# and even Docker. supports a limited set operations on container images. Some commands
# are similar in synta and effect to commands encountered earlier with Docker and Podman

# ensure the crictl is running if you meet the error
# FATA[0000] validate service connection: validate CRI v1 image API for endpoint 
# "unix:///var/run/crio/crio.sock": rpc error: code = Unavailable desc = connection 
# error: desc = "transport: Error while dialing: dial unix /var/run/crio/crio.sock: 
# connect: no such file or directory" 
crio --version
sudo systemctl enable crio
sudo systemctl start crio
sudo systemctl status crio

# Crictl expects to run as root, therefore we will run sudo crictl. Otherwise, it may
# display the error.
sudo crictl pull nginx

# with the first image pulled, let's list images available in the local cache
sudo crictl images
# IMAGE                     TAG                 IMAGE ID            SIZE
# docker.io/library/nginx   latest              e0c9858e10ed8       192MB

# pull a second image 
sudo crictl alpine
sudo crictl images

sudo crictl inspecti alpine
sudo crictl rmi alpine # remove

sudo crictl images

