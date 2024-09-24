# Since we have configured Docker to run as non-root, we can now run docker commands as the 
# Lu user. Let's serach the Docker Hub registry for container images, using nginx as 
# a search term. Many search result will be displayed, but only one "official" image, 
# which we will use in subsequent steps. 
docker search nginx

# Let's pull the official nginx image from the Docker Hub
docker image pull nginx

# List images cached in the local repo. The nginx image was just pulled, while the 
# "hello-world" was pulled in a prior lab exercise when we validated the docker 
# installation by running the test image
docker image ls

# List images and their digests. A digest is a hash associated with the content of 
# each layer part of the iamge. Digests ensure each layer's integrity. The image ID
# is another hash, derived from the JSON config file of the image. The ouput has been
# truncated for readability
docker image ls --digests

# push an image to Docker Hub. Assuming the existence of an greenpear account on Docker Hub
# a user can login from the CLI and then push an image into the registry to be shared
# with other users. The following commands are provided only for illustrational purposes
docker login
# Username: greenpear
# Password: ****
# Login Succeeded

# push an image to docker hub suppose we have this image locally
docker iamge push greenpear/alpine:training

# Let's pull another iamge from Docker hub, the official alpine image, and tag it
docker search alpine
docker image pull alpine
docker image ls
docker image tag alpine myapls:v1

# If we examine closely the ouput, we notice that the tag command generated another image
# entry myalps:v1, referencing the same imageID as the original alpine:latest image.
# Both the iamge ID and size value are identical
# Let's display the alpine iamge details. Between the iamge ID and its digest, we find 
# both alpine and myalps tags. Try running the inspect command with the myalps:v1 image
# and compare the two outputs. 
docker image inspect alpine
# "Id": "sha256:a606584aa9aa875552092ec9e1d62cb98d486f51f389609914039aabd9414687",
#        "RepoTags": [
#            "alpine:latest",
#            "myapls:v1"
#        ],
#        "RepoDigests":
docker image inspect myapls
# same as above

# let's remove a cached image from the local repo (using the --force option), then list 
# available images with images this time insated image ls
docker image rm -f alpine
docker images

