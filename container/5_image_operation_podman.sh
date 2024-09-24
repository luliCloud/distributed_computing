# For docker users transitioning to Podman and its command line structure should be quite seamless.
# The typical recommendation is to set an alias such as alias docker=podman. With this
# in mind, commands that we haver run earlier with docker, can be easily replicate with 
# podman. 
podman search nginx
podman image pull docker.io/library/nginx
podman image ls
# REPOSITORY               TAG         IMAGE ID      CREATED     SIZE
# docker.io/library/nginx  latest      e0c9858e10ed  6 days ago  192 MB

podman image ls --digests

# let's search for the official alpine image and pull it to the local cache, then list to
# validate its presence. Inspect the image, and compare the ouput with the earlier docker image 
# inspect output. 
podman search alpine
podman image pull docker.io/library/alpine
podman image ls
# REPOSITORY                TAG         IMAGE ID      CREATED     SIZE
# docker.io/library/nginx   latest      e0c9858e10ed  6 days ago  192 MB
# docker.io/library/alpine  latest      a606584aa9aa  6 days ago  8.09 MB

podman image tag alpine myalps:v2
# [
#    {
#        "Id": "a606584aa9aa875552092ec9e1d62cb98d486f51f389609914039aabd9414687",
#        "Digest": "sha256:b89d9c93e9ed3597455c90a0b88a8bbb5cb7188438f70953fede212a0c4394e0",
#        "RepoTags": [
#            "docker.io/library/alpine:latest",
#            "localhost/myalps:v2"
#        ],
#        "RepoDigests":

podman image rm -f alpine
podman images
