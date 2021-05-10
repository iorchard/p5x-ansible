Pengrix Ansible
================

This is a guide to install Pengrix Kubernetes(PK) using ansible playbook.

Install ansible
-----------------

Install python3-venv.::

   $ sudo apt update
   $ sudo apt install -y python3-venv

Create p5x virtual env.::

   $ python3 -m venv .envs/p5x

Source the env.::

   $ source .envs/p5x/bin/activate

Install ansible.::

   $ python -m pip install -U pip
   $ python -m pip install wheel
   $ python -m pip install ansible

ssh keys
---------

Install sshpass package.::

   $ sudo apt install -y sshpass

Create ssh key pair with passphrase on deployer.::

   $ ssh-keygen

Run ssh-agent and add the private key.::

   $ eval "$(ssh-agent -s)"
   $ ssh-add
   Enter passphrase: (Enter your passphrase of ssh key)

Create a vault file for ssh and sudo password.::

   $ ansible-vault create inventory/group_vars/all/vault.yaml
   New Vault password:
   Confirm New Vault password:
   ssh_pass: '<ssh password>'

Copy default inventory and create hosts file for your environment.::

   $ cp -a inventory/default inventory/<your_cluster_name>
   $ vi inventory/<your_cluster_name>/hosts
   [nodes]
   hci-[0:2]
   
   [kube_controllers]
   hci-[0:2]
   
   [kube_workers]
   hci-[0:2]

Check the connectivity to all nodes.::

   $ ansible --ask-vault-password -m ping all

Get ansible roles to install pengrix kubernetes.::

   $ ansible-galaxy role install -r requirements.yml

Run ansible playbook.::

   $ ansible-playbook --ask-vault-password setup.yml
