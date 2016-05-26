#!/bin/sh

set -e -x

cat $BASE_FILE > $OUTPUT_FILE

cat << EOF >> $OUTPUT_FILE
env:
  DB_URL: `terraform output -state=$STATE_FILE -module=rds_internal rds_host`
  DB_PORT: `terraform output -state=$STATE_FILE -module=rds_internal rds_port`
EOF
