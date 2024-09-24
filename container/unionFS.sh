#!/bin/bash
# UnionFS transparently overlays files and directories of seperate filesystems, to
# create a unified seamless filesystem. Each participant directory is referred to 
# as a branch and we may set priorities and access modes while mounting branches. 

sudo apt update
# insall unionfs
sudo atp install -y unionfs-fuse

# create 2 seperate dir wich 2 files
mkdir dir1
touch dir1/f1
touch dir1/f2
mkdir dir2
touch dir2/f3
touch dir2/f4

# create an empty dir, for mount
mkdir union

# mount the two branches and verify the transparent overlay 
unionfs dir1/:dir2/ union/
ls union/
# f1 f2 f3 f4

# umount
umount union/
ls union/ 
# empty

rm -r dir*
rm -r union