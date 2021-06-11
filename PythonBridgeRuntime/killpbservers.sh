#!/bin/bash

# Kill all the PythonBridge servers running on localhost.
# This assumes they are being run as the current user.
# Any associated debug server processes will automatically exit.

# List the processes.
# If none are found, exit successfully
ps aux | grep -E 'python.*start_bridge\.py.*msgpack'
status=$?
if [ $status -eq 1 ]
then
	exit 0
fi

# Kill them
ps aux | grep -E 'python.*start_bridge\.py.*msgpack' | awk '{print $2}' | xargs kill
exit $?
