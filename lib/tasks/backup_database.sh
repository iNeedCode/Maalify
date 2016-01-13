#!/usr/bin/env bash

# heavy based on
# http://www.rubytreesoftware.com/resources/basic-postgresql-backup-and-restore
# change to postgres user
su - postgres

DATE=`date +%Y_%m_%d`
DATABASE="maalify_production"
FILENAME="backup/db_backup_maalify_production_$DATE.sql"

cd /var/lib/postgresql/

# input date to file
echo "-- Backup date: $DATE" > $FILENAME

# Backup a single database
pg_dump $DATABASE >> $FILENAME

echo `date` - Delete old backups
find backup/* -mtime +1 -delete

# Restore a single database
# psql db_name < db_backup.sql
