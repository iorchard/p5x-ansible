#!/bin/bash

MYSITE="default"
VAULTFILE="inventory/${MYSITE}/group_vars/all/vault.yml"

# Create vault file.
read -s -p 'ssh password: ' SSHPASS; echo ""
read -s -p 'sudo password: ' SUDOPASS; echo ""

echo "---" > $VAULTFILE
echo "vault_ssh_pass: '$SSHPASS'" >> $VAULTFILE
echo "vault_sudo_pass: '$SUDOPASS'" >> $VAULTFILE
echo -n "..." >> $VAULTFILE
head /dev/urandom |tr -dc A-Za-z0-9 |head -c 8 > .vaultpass
ansible-vault encrypt $VAULTFILE
