#!/bin/bash

DIRECTORY=${DIRECTORY:-/var/destination}
COMMAND=${COMMAND:-print}

# Expand patterns
INCLUDE_PATTERN="$(eval "echo ${INCLUDE_PATTERN}")" || {
  exit $?
}

EXCLUDE_PATTERN="$(eval "echo ${EXCLUDE_PATTERN}")" || {
  exit $?
}

echo Using the following configuration:
echo
echo "    directory:          ${DIRECTORY}"
echo "    include pattern:    ${INCLUDE_PATTERN}"
echo "    exclude pattern:    ${EXCLUDE_PATTERN}"
echo "    command:            ${COMMAND}"
echo


# Delete files
if [ "$LOCATION" == "local" ]; then
  if [ "$INCLUDE_PATTERN" ]; then
    INCLUDE_PATTERN="-name $INCLUDE_PATTERN"
  fi

  if [ "$EXCLUDE_PATTERN" ]; then
    EXCLUDE_PATTERN="! -name $EXCLUDE_PATTERN"
  fi

  # Expand the command
  COMMAND=-$COMMAND

  # Always print the files deleted
  if [ "$COMMAND" == "-delete"  ]; then
    COMMAND="$COMMAND -print"
  fi

  find $DIRECTORY $INCLUDE_PATTERN $EXCLUDE_PATTERN $COMMAND

  RETVAL=$?
fi

if [ "$LOCATION" == "aws" ]; then

  if [ "$INCLUDE_PATTERN" ]; then
    INCLUDE_PATTERN="--include $INCLUDE_PATTERN"
  fi

  if [ "$EXCLUDE_PATTERN" ]; then
    EXCLUDE_PATTERN="--exclude $EXCLUDE_PATTERN"
  fi

	aws s3 rm ${AWS_DESTINATION} --recursive --exclude "*" ${INCLUDE_PATTERN} ${EXCLUDE_PATTERN} --dryrun
  #aws s3 rm ${AWS_DESTINATION} --recursive --exclude "*" $INCLUDE_PATTERN --dryrun
  #aws s3 rm ${AWS_DESTINATION} --recursive --exclude "*" --include "20230825*.tar.gz" --dryrun

  RETVAL=$?

fi

echo

if [ "$RETVAL" == 0 ]; then
	echo Delete matched files finished successfully.
	exit 0
else
	echo Delete matched files failed.
	exit $RETVAL
fi