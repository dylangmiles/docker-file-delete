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

if [ "$LOCATION" == "azure" ]; then

  AZURE_DRYRUN=${AZURE_DRYRUN:-1}
  AZURE_DESTINATION="https://${AZURE_STORAGE_ACCOUNT}.blob.core.windows.net/${AZURE_STORAGE_BLOB_CONTAINER}/${AZURE_STORAGE_BLOB_PREFIX}"

  echo Using the following configuration:
  echo "    location:           $LOCATION"
  echo "    path:               ${AZURE_DESTINATION}"
  echo "    include pattern:    ${INCLUDE_PATTERN}"
  echo "    exclude pattern:    ${EXCLUDE_PATTERN}"
  echo "    dryrun:             ${AZURE_DRYRUN}"
  echo

  if [ "$INCLUDE_PATTERN" ]; then
    P_INCLUDE_PATTERN="--include-pattern $INCLUDE_PATTERN"
  fi

  if [ "$EXCLUDE_PATTERN" ]; then
    P_EXCLUDE_PATTERN="--exclude-pattern $EXCLUDE_PATTERN"
  fi

  # Default to dry run
  P_AZURE_DRYRUN=--dry-run
  if [ "$AZURE_DRYRUN" == 0 ]; then
    P_AZURE_DRYRUN=
  fi

	azcopy rm ${AZURE_DESTINATION} ${P_INCLUDE_PATTERN} ${P_EXCLUDE_PATTERN} ${P_AZURE_DRYRUN}

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