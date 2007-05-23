#!/bin/bash
PREFIX="/usr/local/bin/"
UPSTREAM="http://techpatterns.com/downloads/distro/"

# this will handle stub for any other script also
CALLER=$(basename $0)

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
			message="${PREFIX}${SCRIPT} not executable!"
			;;
		4)
			message='Script download exited with errors.'
			;;
		5)
			message='Unknown script requested.'
			;;
		*)
			message='Unknown error, exiting now.'
			;;
	esac
	echo "ERROR: $message - Error No: $1"

	exit $1
}

# set the SCRIPT value
case $CALLER in
	sgfxi)
		SCRIPT="sgfxi"
		;;
	du-fixes-h2.sh)
		SCRIPT="du-fixes-h2.sh"
		;;
	*)
		error_handler 5
		;;
esac

# if $SCRIPT exists, it will handle the root tests. Root tests cannot
# be run first because they kill the -h help function
if [ -x "${PREFIX}${SCRIPT}" ]; then
	exec "${PREFIX}${SCRIPT}" "$@"
else
	# only in case of requirement to download script do root test, and just exit
	# if not root, anything else is counterintuitive I think for users.
	[ "$(id -u)" -ne 0 ] && error_handler 1

	if [ ! -f "${PREFIX}${SCRIPT}" ]; then
		wget -Nc -O"${PREFIX}${SCRIPT}" "${UPSTREAM}${SCRIPT}" || error_handler 4
	fi
	
	[ -f "${PREFIX}${SCRIPT}" ] || error_handler 2
   
	[ -x "${PREFIX}${SCRIPT}" ] || chmod +x "${PREFIX}${SCRIPT}"

	if [ -x "${PREFIX}${SCRIPT}" ]; then
		exec "${PREFIX}${SCRIPT}" "$@"
	else
		error_handler 3
	fi
fi
