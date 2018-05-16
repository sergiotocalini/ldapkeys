# ldapkeys
SSH LDAP keys

Installation
------------

```
#~ git clone https://github.com/sergiotocalini/ldapkeys.git /opt/ldapkeys
#~ cp /opt/ldapkeys/ldapkeys.env.example /opt/ldapkeys/ldapkeys.env
#~ vi /opt/ldapkeys/ldapkeys.env
```

OpenSSH
-------

```
#~ cat /etc/ssh/sshd_config
...
AuthorizedKeysCommand		   /opt/ldapkeys/ldapkeys.sh
AuthorizedKeysCommandUser		nobody
...
#~
```
