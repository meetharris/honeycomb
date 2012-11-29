#!/bin/sh

: ${MYSQL_HOME?"Need to set MYSQL_HOME environmental variable."}

cd $MYSQL_HOME/mysql-test/
#rm suite/cloud-test/funcs/r/*.reject
./mtr --suite=cloud-test/funcs             \
  --mysqld=--plugin-load=cloud=ha_cloud.so \
  --mysqld=--default-storage-engine=cloud  \
  --mysqld=--character-set-server=utf8     \
  --mysqld=--collation-server=utf8_bin     \
  --force --retry=0 --max-test-fail=400

#  --extern socket=/tmp/mysql.sock