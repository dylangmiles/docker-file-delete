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

# LOCATION local | aws | azure
LOCATION=aws

# The location where backups will be written to if file based
LOCAL_DESTINATION=./data/destination

# Command print | delete
LOCAL_COMMAND=print

# AWS dry run remove. 0 - false | 1 - true (default)
AWS_DRYRUN=1

# AWS Storage
AWS_ACCESS_KEY=**************
AWS_SECRET_KEY=******************************
AWS_REGION=eu-west-1
AWS_DESTINATION=s3://bucketname/path

# AZURE dry run remove. 0 - false | 1 - true (default)
AZURE_DRYRUN=1

# Azure Storage
AZURE_APP_TENANT_ID=aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee
AZURE_APP_ID=aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeef
AZURE_APP_SECRET=*************
AZURE_STORAGE_ACCOUNT=mystorageaccount
AZURE_STORAGE_BLOB_CONTAINER=mycontainer
AZURE_STORAGE_BLOB_PREFIX=pathincontainer/

# Email address where notifications are sent
MAIL_TO=name@email.com

# Email sending options
SMTP_FROMNAME=FromName
SMTP_FROM=from@email.com
SMTP_HOST=mail.server.com
SMTP_PORT=587
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

