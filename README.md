# docker-file-delete

This container can be used to periodically delete files.

You can check the last run with the integrated HTTP server on port 18080.

The container can monitor a local directory or Amazon S3 bucket location and files can be deleted based on a pattern.

# Setup

1. Clone this repository to your server with files that need to be backed up
```
git clone git@github.com:dylangmiles/docker-file-delete.git
```

2. Create a `.env` file in the directory with the following settings:
```bash
# Cron schedule
SCHEDULE=* * * * *

# Delete back up on this day from last week
INCLUDE_PATTERN=$$(date +%Y%m%d -d "last week")_*.???.gz

# Keep the back up from last Sunday
EXCLUDE_PATTERN=$$(date +%Y%m%d -d "last Sunday")_*.???.gz

# METHOD local | aws
LOCATION=aws

# The location where backups will be written to if file based
LOCAL_DESTINATION=./data/destination

# Command print | delete
LOCAL_COMMAND=print

# AWS dry run remove. 0 - false | 1 - true (default)
AWS_DRYRUN=1

# AWS Access Key
AWS_ACCESS_KEY=***************

# AWS Secret Key
AWS_SECRET_KEY=***************

# AWS Region
AWS_REGION=eu-west-1

# AWS Bucket name
AWS_DESTINATION=s3://bucketname/path

# Email address where notifications are sent
MAIL_TO=name@email.com

# Email sending options
SMTP_FROM=from@email.com
SMTP_SERVER=mail.server.com:587
SMTP_HOSTNAME=local.server.com
SMTP_USERNAME=username@email.com
SMTP_PASSWORD=*******

```

3. Start the container
```
docker compose up -d file-delete
```

You can also manually run the backup from the command line
```
docker compose run --rm file-delete delete-run.sh
```

