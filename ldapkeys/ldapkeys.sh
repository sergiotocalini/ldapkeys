#!/usr/bin/env ksh
#################################################################################

#################################################################################
#
#  Variable Definition
# ---------------------
#
APP_NAME=$(basename $0)
APP_DIR=$(dirname $0)
APP_VER="0.0.1"
APP_WEB="http://www.sergiotocalini.com.ar/"
APP_CONF="/etc/ldap/ldapkeys.conf"
TIMESTAMP=`date '+%s'`
CACHE_DIR=/tmp/${APP_NAME%.*}
CACHE_TTL=5

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
				  -b "${BASEDN}" ${filter} "${ATTR_KEYS}" \
	  | ${SED} -n '/^ /{H;d};/'"${ATTR_KEYS}"':/x;$g;s/\n *//g;s/'"${ATTR_KEYS}"': //gp'`
    if [[ ${?} == 0 ]]; then
	echo "${keys}" > "${file}"
    fi
fi
[[ -f "${file}" ]] && cat "${file}"
exit 0
