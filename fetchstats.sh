#!/bin/bash
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 spanner_instance database_name 'YYYY-MM-DDTHH:MM:SSZ' input_file.sql"
    exit 1
fi

INSTANCE_NAME=$1
DATABASE_NAME=$2
SQL_TIMESTAMP_VAL=$3
INPUT_FILE=$4

sed "s/@HOUR_INTERVAL/'$SQL_TIMESTAMP_VAL'/g" "$INPUT_FILE" | gcloud alpha spanner cli "$DATABASE_NAME" --instance "$INSTANCE_NAME"