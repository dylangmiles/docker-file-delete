#!/bin/bash

# Expand patterns
INCLUDE_PATTERN="$(eval "echo ${INCLUDE_PATTERN}")" || {
  exit $?
}

EXCLUDE_PATTERN="$(eval "echo ${EXCLUDE_PATTERN}")" || {
  exit $?
}


# Delete files
if [ "$LOCATION" == "local" ]; then

  DIRECTORY=/var/destination
  COMMAND=${LOCAL_COMMAND:-print}

  echo Using the following configuration:
  echo "    location:           $LOCATION"
  echo "    directory:          ${DIRECTORY}"
  echo "    include pattern:    ${INCLUDE_PATTERN}"
  echo "    exclude pattern:    ${EXCLUDE_PATTERN}"
  echo "    command:            ${COMMAND}"
  echo


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

  AWS_DRYRUN=${AWS_DRYRUN:-1}

  echo Using the following configuration:
  echo "    location:           $LOCATION"
  echo "    path:               ${AWS_DESTINATION}"
  echo "    include pattern:    ${INCLUDE_PATTERN}"
  echo "    exclude pattern:    ${EXCLUDE_PATTERN}"
  echo "    dryrun:             ${AWS_DRYRUN}"
  echo

  if [ "$INCLUDE_PATTERN" ]; then
    INCLUDE_PATTERN="--include $INCLUDE_PATTERN"
  fi

  if [ "$EXCLUDE_PATTERN" ]; then
    EXCLUDE_PATTERN="--exclude $EXCLUDE_PATTERN"
  fi

  # Default to dry run
  P_AWS_DRYRUN=--dryrun
  if [ "$AWS_DRYRUN" == 0 ]; then
    P_AWS_DRYRUN=
  fi

	aws s3 rm ${AWS_DESTINATION} --recursive --exclude "*" ${INCLUDE_PATTERN} ${EXCLUDE_PATTERN} ${P_AWS_DRYRUN}

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