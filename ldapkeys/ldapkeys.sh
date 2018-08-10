#!/usr/bin/env ksh
#################################################################################

#################################################################################
#
#  Variable Definition
# ---------------------
#
APP_NAME=$(basename $0)
APP_DIR=$(dirname $0)
APP_VER="0.1.0"
APP_WEB="https://github.com/sergiotocalini/ldapkeys"
APP_CONF="/etc/ldap/ldapkeys.conf"
TIMESTAMP=`date '+%s'`
CACHE_DIR="/tmp/${APP_NAME%.*}"
CACHE_TTL="5"
KEYS_OWNER="nobody"

#
#################################################################################

#################################################################################
#  Load Oracle Environment
# -------------------------
#
[[ -f "${APP_CONF}" ]] && . "${APP_CONF}"

#
#################################################################################

#################################################################################
#
#  Function Definition
# ---------------------
#
usage() {
    echo "Usage: ${APP_NAME%.*} [Options]"
    echo ""
    echo "Options:"
    echo "  -h            Displays this help message."
    echo "  -u ARG(str)   Username."
    echo "  -c ARG(str)   ldapkeys configuration file (default=/etc/ldap/ldapkeys.conf)."
    echo "  -v            Show the script version."
    echo ""
    echo "Please send any bug reports to sergiotocalini@gmail.com"
    exit 1
}

version() {
    echo "${APP_NAME%.*} ${APP_VER}"
    exit 1
}
#
#################################################################################

#################################################################################
while getopts "s::u:hvc:" OPTION; do
    case ${OPTION} in
	h)
	    usage
	    ;;
	c)
	    [[ -f "${OPTARG}" ]] && . "${OPTARG}"
	    ;;
	u)
	    USER="${OPTARG}"
	    ;;
	v)
	    version
	    ;;
        \?)
            exit 1
            ;;
    esac
done

[[ -d "${CACHE_DIR}" ]] || mkdir -p "${CACHE_DIR}"
file="${CACHE_DIR}/${USER}"
if [[ $(( `stat -c '%Y' "${file}" 2>/dev/null`+60*${CACHE_TTL} )) -le ${TIMESTAMP} ]]; then
    filter="(&(objectClass=posixAccount)(${ATTR_USER}=${USER})${ATTR_FILTER})"
    keys=`${LDAPSEARCH} ${OPTIONS} -h ${HOST} -D "${BINDDN}" -w "${BINDPW}" \
				  -b "${BASEDN}" ${filter} "${ATTR_KEYS}" 2>/dev/null \
	  | ${SED} -n '/^ /{H;d};/'"${ATTR_KEYS}"':/x;$g;s/\n *//g;s/'"${ATTR_KEYS}"': //gp'`
    if [[ ${?} == 0 && -z ${keys} ]]; then
	echo "${keys}" > "${file}"
	chown "${KEYS_OWNER}": "${file}"
    fi
fi
[[ -f "${file}" ]] && cat "${file}"
exit 0
