#!/bin/sh

# Get the distribution.
. /etc/os-release

# Update the system.
case "${ID}" in
  debian|ubuntu)
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get upgrade --quiet --yes
  ;;
  centos|fedora|ol|redhat)
    yum -y update
  ;;
  *)
    echo "Uncertain of the distribution, failing."
    exit 1
  ;;
esac

# Add a user "lab" with password "lab".
useradd -m -s /bin/bash lab
echo "lab:lab" | chpasswd

# Allow sudo.
echo "lab ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/lab

# Enable password authentication.
rm /etc/ssh/sshd_config.d/50-cloud-init.conf
systemctl restart sshd
