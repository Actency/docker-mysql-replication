#!/bin/bash
set -eo pipefail

cat > /etc/mysql/mysql.conf.d/repl.cnf << EOF
[mysqld]
log-bin=mysql-bin
relay-log=mysql-relay
#bind-address=0.0.0.0
#skip-name-resolve
innodb_file_per_table = 1
innodb_flush_method = O_DIRECT
innodb-flush-log-at-trx-commit = 0
transaction-isolation = READ-COMMITTED
max_allowed_packet = 128M
EOF

# If there is a linked master use linked container information
if [ -n "$MASTER_PORT_3306_TCP_ADDR" ]; then
  export MASTER_HOST=$MASTER_PORT_3306_TCP_ADDR
  export MASTER_PORT=$MASTER_PORT_3306_TCP_PORT
fi

if [ -z "$MASTER_HOST" ]; then
  export SERVER_ID=1
  cat >/docker-entrypoint-initdb.d/init-master.sh  <<'EOF'
#!/bin/bash

echo Creating replication user ...
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "\
  GRANT \
    FILE, \
    SELECT, \
    SHOW VIEW, \
    LOCK TABLES, \
    RELOAD, \
    REPLICATION SLAVE, \
    REPLICATION CLIENT \
  ON *.* \
  TO '$REPLICATION_USER'@'%' \
  IDENTIFIED BY '$REPLICATION_PASSWORD'; \
  FLUSH PRIVILEGES; \
"
EOF
else
  # TODO: make server-id discoverable
  export SERVER_ID=2
  cp -v /init-slave.sh /docker-entrypoint-initdb.d/
  cat > /etc/mysql/mysql.conf.d/repl-slave.cnf << EOF
[mysqld]
log-slave-updates
master-info-repository=TABLE
relay-log-info-repository=TABLE
relay-log-recovery=1
EOF
fi

cat > /etc/mysql/mysql.conf.d/server-id.cnf << EOF
[mysqld]
server-id=$SERVER_ID
EOF

exec docker-entrypoint.sh "$@"
