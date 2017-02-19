# Steps for Ansible

### Enableable root for raspberry

```bash
sudo passwd root
sudo nano /etc/ssh/sshd_config
PermitRootLogin yes
reboot
```

Test reachablity to host with ping module `ansible webservers -m ping -k`

### setup server 
````bash
ansible-playbook site.yml -k
ansible-playbook site.yml -k --tags "ruby"
ansible-playbook site.yml -k --vault-password-file vault_pass.txt
````


