#!/bin/bash
# install the desired crictl version (check release page), first set the VERSION 
# variable to the desired release value
VERSION="v1.30.0"

wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz

sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin

rm -f crictl-$VERSION-linux-amd64.tar.gz

crictl --version
# crictl version v1.30.0
# 在 Bash 中，定义变量有两种主要方式：
# 一种是仅在当前 shell 环境中有效，另一种是通过 export 命令使变量在子进程中也有效。

# start the CRIO-O service and then display the crictl runtime version
# I have not install cri-o yet, crictl is used to manage cri api vai system 
# let me install cri-o in another sh
