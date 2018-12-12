# My notes on Linux configuration

See particular md files.

# Ansible playbook

## Proxy 
* edit file `ansible-playbook-root/group_vars/all` : set correct proxy
* edit file `ansible-playbook-root/site.yml` : uncomment the `- proxy_settings`

Run command
<pre>
ansible-playbook -K <i>/path/to/</i>site.yml
</pre>
