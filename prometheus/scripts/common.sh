#!/bin/bash

# configure name resolution
echo "" >> /etc/hosts
echo "# Kubernetes Lab" >> /etc/hosts
echo "192.168.56.90    prometheus" >> /etc/hosts
echo "192.168.56.11    node-1" >> /etc/hosts
echo "192.168.56.12    node-2" >> /etc/hosts

# disable selinux
setenforce 0 2> /dev/null
sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

# disable firewall
systemctl stop firewalld
systemctl disable firewalld
