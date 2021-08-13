#!/bin/bash

VAULTFILE="inventory/${MYSITE}/group_vars/all/vault.yml"

# Create vault file.
read -s -p "$USER password: " USERPASS; echo ""

echo "---" > $VAULTFILE
echo "vault_ssh_pass: '$USERPASS'" >> $VAULTFILE
echo "vault_sudo_pass: '$USERPASS'" >> $VAULTFILE
echo -n "..." >> $VAULTFILE
head /dev/urandom |tr -dc A-Za-z0-9 |head -c 8 > .vaultpass
ansible-vault encrypt $VAULTFILE
