#!/bin/bash
# Although continerd is not intended to be used directly by user, we will explore the installation method 
# of the containered pacakge on Ubuntu. In a future lab exercise we will install crictl, 
# a Beta CLI tool designed to allowe users to ineract with simple suntimes such as contiainered
sudo apt upgrade -y
sudo apt update
sudo apt install -y containerd # noting no 'e' after r
containerd --version
# containerd github.com/containerd/containerd 1.7.12 

sudo systemctl status containerd.service

# as containerd runs as a daemon on the Ubuntu host, we can manage it with systemd
# “守护进程”（Daemon）是一个在后台运行的计算机程序，通常在启动时自动启动，
# 并在系统运行期间一直保持运行状态。守护进程通常用于执行系统级别的任务和服务，
# 如处理网络请求、管理系统日志、监控系统资源等。
# 常见的守护进程
# 系统守护进程：例如 init 或 systemd，负责管理系统的启动和停止。
# 网络守护进程：例如 httpd（Apache HTTP 服务器），处理网络请求和响应。
# 日志守护进程：例如 syslogd，管理系统日志记录。
# 任务调度守护进程：例如 cron，根据预设的时间表运行任务。

