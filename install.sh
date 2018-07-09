#!/usr/bin/env ksh
SOURCE_DIR=$(dirname $0)
DEPLOY_DIR=/etc/ldap

HOST="${1:-localhost}"
BINDDN="${2:-cn=binduser,ou=auth,dc=example,dc=com}"
BINDPW="${3:-xxxxxx}"
BASEDN="${4:-ou=people,dc=example,dc=com}"
OPTIONS="${5}"
ATTR_USER="${6:-uid}"
ATTR_KEYS="${7:-sshPublicKey}"
ATTR_FILTER="${8}"
SED="${9:-`which sed`}"
LDAPSEARCH="${10:-`which ldapsearch`}"
CACHE_DIR="${11:-/etc/ldap/keys}"
CACHE_TTL="${12:-5}"
KEYS_OWNER="${13:-nobody}"

mkdir -p ${DEPLOY_DIR}
SCRIPT_CONFIG="${DEPLOY_DIR}/ldapkeys.conf"
[[ -f ${SCRIPT_CONFIG} ]] && SCRIPT_CONFIG="${SCRIPT_CONFIG}.new"

cp -rpv ${SOURCE_DIR}/ldapkeys/ldapkeys.conf.example  ${SCRIPT_CONFIG}
cp -rpv ${SOURCE_DIR}/ldapkeys/ldapkeys.sh            /usr/local/bin/ldapkeys

regex_array[0]="s|HOST=.*|HOST=\"${HOST}\"|g"
regex_array[1]="s|BINDDN=.*|BINDDN=\"${BINDDN}\"|g"
regex_array[2]="s|BINDPW=.*|BINDPW=\"${BINDPW}\"|g"
regex_array[3]="s|BASEDN=.*|BASEDN=\"${BASEDN}\"|g"
regex_array[4]="s|OPTIONS=.*|OPTIONS=\"${OPTIONS}\"|g"
regex_array[5]="s|ATTR_USER=.*|ATTR_USER=\"${ATTR_USER}\"|g"
regex_array[6]="s|ATTR_KEYS=.*|ATTR_KEYS=\"${ATTR_KEYS}\"|g"
regex_array[7]="s|ATTR_FILTER=.*|ATTR_FILTER=\"${ATTR_FILTER}\"|g"
regex_array[8]="s|SED=.*|SED=\"${SED}\"|g"
regex_array[9]="s|LDAPSEARCH=.*|LDAPSEARCH=\"${LDAPSEARCH}\"|g"
regex_array[10]="s|CACHE_DIR=.*|CACHE_DIR=\"${CACHE_DIR}\"|g"
regex_array[11]="s|CACHE_TTL=.*|CACHE_TTL=\"${CACHE_TTL}\"|g"
regex_array[12]="s|KEYS_OWNER=.*|KEYS_OWNER=\"${KEYS_OWNER}\"|g"
for index in ${!regex_array[*]}; do
    sed -i "${regex_array[${index}]}" ${SCRIPT_CONFIG}
done
