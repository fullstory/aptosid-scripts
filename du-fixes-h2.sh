#!/bin/bash
## note: save file as du-fixes-h2.sh

PREFIX="/usr/local/bin/"
UPSTREAM="http://techpatterns.com/downloads/distro/"
DUF="du-fixes-h2.sh"

error_handler()
{
	local message=''
	case $1 in
		1)
			message='You must be root to run this script!'
			;;
		2)
			message='Failed to download script!'
			;;
		3)
			message="${PREFIX}${DUF} not executable!"
			;;
		4)
			message='Script download exited with errors.'
			;;
		*)
			message='Unknown error, exiting now.'
			;;
	esac
	echo "ERROR: $message - Error No: $1"
	
	exit $1
}

# user login test cannot run first because it kills -h

# if it exists, du-fixes will handle the root tests. Root tests cannot
# be run first because they kill the -h help function
if [ -x "${PREFIX}${DUF}" ]; then
	exec "${PREFIX}${DUF}" "$@"
else
	# only in case of requirement to download script do root test, and just exit
	# if not root, anything else is counterintuitive I think for users.
	[ "$(id -u)" -ne 0 ] && error_handler 1

	if [ ! -f "${PREFIX}${DUF}" ]; then
		wget -Nc -O"${PREFIX}${DUF}" "${UPSTREAM}${DUF}" || error_handler 4
	fi
	[ -f "${PREFIX}${DUF}" ]   || error_handler 2
	
	[ -x "${PREFIX}${DUF}" ] || chmod +x "${PREFIX}${DUF}"
	
	if [ -x "${PREFIX}${DUF}" ]; then
		exec "${PREFIX}${DUF}" "$@"
	else
		error_handler 3
	fi
fi

