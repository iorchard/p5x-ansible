Pengrix Ansible
================

This is a guide to install Pengrix Kubernetes(PK) using ansible playbook.

Assumptions
-------------

* The first node in nodes group is the ansible deployer.
* Ansible user in every node has a sudo privilege without NOPASSWD option.
  We will use vault_sudo_pass in ansible vault.
* Ansible user in every node has the same password.
  We will use vault_ssh_pass in ansible vault.

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

Prepare
---------

Copy default inventory and create hosts file for your environment.::

   $ MYSITE="mysite"
   $ cp -a inventory/default inventory/$MYSITE
   $ vi inventory/$MYSITE/hosts
   hci-0 ansible_host=192.168.21.121 ansible_port=22 ansible_user=pengrix
   hci-1 ansible_host=192.168.21.122 ansible_port=22 ansible_user=pengrix
   hci-2 ansible_host=192.168.21.123 ansible_port=22 ansible_user=pengrix
   
   [kube_controllers]
   hci-[0:2]
   
   [kube_workers]
   hci-[0:2]
   
   [nodes:children]
   kube_controllers
   kube_workers

Modify hostname, ip, port, and user in hosts file for your environment.

Copy ansible.cfg.sample to ansible.cfg and 
update inventory value in ansible.cfg.::

   $ cp ansible.cfg.sample ansible.cfg
   $ vi ansible.cfg
   inventory = inventory/<mysite>/hosts

Create a vault file for ssh and sudo password.::

   $ ansible-vault create inventory/$MYSITE/group_vars/all/vault.yml
   New Vault password:
   Confirm New Vault password:
   vault_ssh_pass: "<ssh password>"
   vault_sudo_pass: "<sudo password>"

Change keepalived management network interface name and
virtual ip address for your site in vars.yml.::

   $ vi inventory/$MYSITE/group_vars/all/vars.yml
   ...
   # keepalived
   keepalived_interface: "<management_interface>"
   keepalived_vip: "<keepalived_virtual_ip>"

Check the connectivity to all nodes.::

   $ ansible --ask-vault-password -m ping all

Run
----

Get ansible roles to install pengrix kubernetes.::

   $ ansible-galaxy role install --force --role-file requirements.yml

Run ansible playbook.::

   $ ansible-playbook --ask-vault-password setup.yml
