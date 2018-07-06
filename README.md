# ldapkeys
SSH LDAP keys

Installation
------------

```
#~ git clone https://github.com/sergiotocalini/ldapkeys.git
#~ ./ldapkeys/install.sh
```

Configuration
-------------
```
#~ vi /etc/ldap/ldapkeys.conf
```

OpenSSH
-------

```
#~ cat /etc/ssh/sshd_config
...
AuthorizedKeysCommand		    /usr/local/bin/ldapkeys
AuthorizedKeysCommandUser		nobody
...
#~
```
