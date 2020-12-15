# My notes on Linux configuration

See particular md files.

# Ubuntu 18.04 / Mint 19.x

### Install git and ansible
As root
```shell script
apt-get update
apt-get install ansible git
```

### Clone this repo
If cloning this repo fails with message _failed: Connection refused._
then
```shell script
export https_proxy="$http_proxy"
```

# Ansible playbook

## Proxy 
* edit file `ansible-playbook-root/group_vars/all` : set correct proxy
* edit file `ansible-playbook-root/site.yml` : uncomment all proxy related lines

## Convert Ubuntu 18.04 to Linux Mint 19.3
If hidden behind proxy, edit file `ansible-playbook-root/ubuntu-to-mint.yml` and uncomment all proxy related lines
```
ansible-playbook -K ansible-playbook-root/ubuntu-to-mint.yml
```

Run command
<pre>
ansible-playbook -K <i>/path/to/</i>site.yml
</pre>
