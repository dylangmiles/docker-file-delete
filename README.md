# Scheduled File Deletion

Create schedule backups of databases in a PostgreSQL server to a destination directory.

## Build the contiainer
```
$ make
```

## Start a scheduled backup

```shell
docker run \
-v /var/destination:/var/destination \
-e TIMEZONE="Africa/Johannesburg" \
-e SCHEDULE="0 0 3 * *" \
-e INCLUDE_PATTERN="2023*.sql.gz" \
-e EXCLUDE_PATTERN="????????_09*.sql.gz" \
dylangmiles/docker-pg-backup
```

## Run a backup once off

```shell
docker run \
--entrypoint="/usr/local/sbin/delete-run.sh" \
-v ~/dev/temp/backups:/var/destination \
-e INCLUDE_PATTERN="2023*.sql.gz" \
-e EXCLUDE_PATTERN="????????_09*.sql.gz" \
dylangmiles/docker-file-delete

```shell
## Sample docker compose

version: "3.9"
services:
    clean:
        build: .
        volumes:
            - ~/dev/temp/backups:/var/destination
        environment:
            - SCHEDULE="0 0 3 * *"
            - INCLUDE_PATTERN="$$(date +%Y)*.sql.gz"
            - EXCLUDE_PATTERN="????????_09*.sql.gz"
```



