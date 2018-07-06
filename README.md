# ldapkeys
SSH LDAP keys

Installation
------------
Default variables:

NAME|VALUE
----|-----
HOST|localhost
BINDDN|cn=binduser,ou=auth,dc=example,dc=com
BINDPW|xxxxxx
BASEDN|ou=people,dc=example,dc=com
OPTIONS|
ATTR_USER|uid
ATTR_KEYS|sshPublicKey
ATTR_FILTER|
SED|`which sed`
LDAPSEARCH|`which ldapsearch`
CACHE_DIR|/etc/ldap/keys
CACHE_TTL|5


```
#~ git clone https://github.com/sergiotocalini/ldapkeys.git
#~ ./ldapkeys/install.sh "${HOST}" "${BINDDN}" "${BINDPW}" "${BASEDN}" \
                         "${OPTIONS}" "${ATTR_USER}" "${ATTR_KEYS}" \
                         "${ATTR_FILTER}" "${SED}" "${LDAPSEARCH}" \
                         "${CACHE_DIR}" "${CACHE_TTL}" 
```

Configuration
-------------
```
#~ cat /etc/ldap/ldapkeys.conf
HOST="localhost"
BINDDN="cn=binduser,ou=auth,dc=example,dc=com"
BINDPW="xxxxxx"
BASEDN="ou=people,dc=example,dc=com"
OPTIONS=""
ATTR_USER="uid"
ATTR_KEYS="sshPublicKey"
ATTR_FILTER=""
SED="/bin/sed"
LDAPSEARCH="/usr/bin/ldapsearch"
CACHE_DIR="/etc/ldap/keys"
CACHE_TTL="5"
#~
```

Execution
---------
```
#~ /usr/local/bin/ldapkeys -h
Usage: ldapkeys [Options]

Options:
  -h            Displays this help message.
  -u ARG(str)   Username.
  -c ARG(str)   ldapkeys configuration file (default=/etc/ldap/ldapkeys.conf).
  -v            Show the script version.

Please send any bug reports to sergiotocalini@gmail.com
#~
```

```
#~ /usr/local/bin/ldapkeys -u ${USER} -c /etc/ldap/ldapkeys.conf
...
#~
```

OpenSSH
-------

```
#~ cat /etc/ssh/sshd_config
...
AuthorizedKeysCommand       /usr/local/bin/ldapkeys
AuthorizedKeysCommandUser   nobody
...
#~
```
