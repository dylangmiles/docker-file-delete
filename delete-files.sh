#!/bin/bash

DIRECTORY=${DIRECTORY:-/var/destination}
#INCLUDE_PATTERN=
#EXCLUDE_PATTERN=
COMMAND=${COMMAND:-print}

echo Using the following configuration:
echo
echo "    directory:          ${DIRECTORY}"
echo "    include pattern:    ${INCLUDE_PATTERN}"
echo "    exclude pattern:    ${EXCLUDE_PATTERN}"
echo "    command:            ${COMMAND}"
echo

# Expand patterns
INCLUDE_PATTERN="$(eval "echo ${INCLUDE_PATTERN}")"
RETVAL=$?

if [ "$RETVAL" == 0 ]; then
  EXCLUDE_PATTERN="$(eval "echo ${EXCLUDE_PATTERN}")"
  RETVAL=$?
fi

if [ "$RETVAL" == 0 ]; then

  if [ "$INCLUDE_PATTERN" ]; then
    INCLUDE_PATTERN="-name $INCLUDE_PATTERN"
  fi

  if [ "$EXCLUDE_PATTERN" ]; then
    EXCLUDE_PATTERN="! -name $EXCLUDE_PATTERN"
  fi

fi

# Resolve patterns
INCLUDE_PATTERN="$(eval "echo ${INCLUDE_PATTERN}")"
EXCLUDE_PATTERN="$(eval "echo ${EXCLUDE_PATTERN}")"

# Delete files
find $DIRECTORY $INCLUDE_PATTERN $EXCLUDE_PATTERN -$COMMAND

RETVAL=$?

echo

if [ "$RETVAL" == 0 ]; then
	echo Delete matched files finished successfully.
	exit 0
else
	echo Delete matched files failed.
	exit 1
fi