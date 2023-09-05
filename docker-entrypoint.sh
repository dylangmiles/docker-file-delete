#!/bin/bash
set -e

echo "Authenticating with AWS"
aws configure set aws_access_key_id ${AWS_ACCESS_KEY}
aws configure set aws_secret_access_key ${AWS_SECRET_KEY}
aws configure set default.region ${AWS_REGION}

echo "Setting up SMTP settings"
envsubst < /root/.muttrc.template > /root/.muttrc
envsubst < /root/.msmtprc.template > /root/.msmtprc

if [ -n "$TIMEZONE" ]; then
	echo ${TIMEZONE} > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata
fi

if [ $1 == "go-cron" ]; then

	if [ -z "$SCHEDULE" ]; then
		echo Missing SCHEDULE environment variable 2>&1
		echo Example -e SCHEDULE=\"\*/10 \* \* \* \* \*\" 2>&1
		exit 1
	fi

exec go-cron -s "${SCHEDULE}" -- /usr/local/sbin/delete-run.sh
fi

exec "$@"