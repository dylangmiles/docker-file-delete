#!/bin/bash

# Get last error even in piped commands
set -o pipefail

PIDFILE=/var/run/delete-run.pid

if [ -f $PIDFILE ]; then
	echo $0 is already running with pid $(cat $PIDFILE), aborting!
	exit 1
fi

echo $$ >$PIDFILE

OUT_BUFF=$( /usr/local/sbin/delete-files.sh 2>&1 | tee /proc/1/fd/1 )

RETVAL=$?

# Calculate result in words
RESULT="unknown"
if [ "$RETVAL" == 0 ]; then
	RESULT="success"
else
	RESULT="failed"
fi

# Email results
ssmtp "${MAIL_TO}" <<EOF
To:${MAIL_TO}
From:${SMTP_FROM}
Subject:File cleanup ${RESULT}
${OUT_BUFF}
EOF

rm $PIDFILE

exit $retval