# Docker image for MySQL master-slave replication

## Additional environment variables:
* REPLICATION_USER [default: replication]
* REPLICATION_PASSWORD [default: replication_pass]
* REPLICATION_HEALTH_GRACE_PERIOD [default: 3]
* REPLICATION_HEALTH_TIMEOUT [default: 10]
* MASTER_PORT [default: 3306]
* MASTER_HOST [default: master]

## Start master

```
docker run -d \
  --name mysql_master \
  -e MYSQL_ALLOW_EMPTY_PASSWORD=1 \
  actency/docker-mysql-replication:5.7
```

## Start slave

```
docker run -d \
  --name mysql_slave \
  -e MYSQL_ALLOW_EMPTY_PASSWORD=1 \
  --link mysql_master:master \
  actency/docker-mysql-replication:5.7
```
