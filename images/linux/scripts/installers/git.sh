#!/bin/bash
################################################################################
##  File:  git.sh
##  Desc:  Installs Git
################################################################################
set -xv

# Source the helpers for use with the script
source $HELPER_SCRIPTS/install.sh

## Install git
add-apt-repository ppa:git-core/ppa -y
apt-get update
apt-get install git -y
git --version

# Install git-lfs
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
apt-get install -y --no-install-recommends git-lfs

# Install git-ftp
apt-get install git-ftp -y

#Install hub
tmp_hub="/tmp/hub"
mkdir -p "$tmp_hub"
url=$(curl -s https://api.github.com/repos/github/hub/releases/latest | jq -r '.assets[].browser_download_url | select(contains("hub-linux-amd64"))')
download_with_retries "$url" "$tmp_hub"
tar xzvf "$tmp_hub"/hub-linux-amd64-*.tgz --strip-components 1 -C "$tmp_hub"
mv "$tmp_hub"/bin/hub /usr/local/bin

# Add well-known SSH host keys to known_hosts
cat /etc/ssh/ssh_known_hosts
ssh-keyscan -v -t rsa github.com >> /etc/ssh/ssh_known_hosts
ssh-keyscan -v -t rsa ssh.dev.azure.com >> /etc/ssh/ssh_known_hosts
cat /etc/ssh/ssh_known_hosts

invoke_tests "Tools" "Git"
echo "done ..."
