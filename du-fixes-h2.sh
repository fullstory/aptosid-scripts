#!/bin/sh
## note: save file as du-fixes-h2.sh

PREFIX="/usr/local/bin/"
UPSTREAM="http://techpatterns.com/"
DUF="du-fixes-h2.sh"

if [ "$(id -u)" -ne 0 ]; then
	[ -x /usr/bin/su-me ] && DISPLAY="" exec su-me "$0" "$@"
	echo "Error: You must be root to run this script!"

	exit 1
else
	if [ -x "${PREFIX}${DUF}" ]; then
		exec "${PREFIX}${DUF}"
	else
		[ -f "${PREFIX}${DUF}" ] ||	wget -Nc -O"${PREFIX}${DUF}" "${UPSTREAM}${DUF}"
		[ -x "${PREFIX}${DUF}" ] ||	chmod +x "${PREFIX}${DUF}"

		if [ -x "${PREFIX}${DUF}" ]; then
			exec "${PREFIX}${DUF}"
			echo "ERROR: ${PREFIX}${DUF} not executable!"
			exit 1
		else
			echo "ERROR: Failed to download script!"
			exit 2
		fi
	fi
fi

