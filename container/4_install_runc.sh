#!/bin/bash
# while runc was not designed to be used directly by end-users, it is used by more complext
# container tools, such as Docker or Podman. There are various methods of installing 
# the runc CLI tool. For Ubuntu it is available to install directly from the Ubuntu software package 
# repo.

sudo apt upgrade -y
sudo apt update  # need to udgrade first to run the update cli
#now is safe to install the runc packge
sudo apt install -y runc

# verify the version of installed runc
runc --version
# runc version 1.1.12-0ubuntu2~20.04.1
# spec: 1.0.2-dev
# go: go1.21.1
# libseccomp: 2.5.1
