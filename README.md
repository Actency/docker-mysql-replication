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
 -v /data/mastermysql:/var/lib/mysql \
 -e MYSQL_ROOT_PASSWORD=mysqlroot \
 -e MYSQL_USER=example_user \
 -e MYSQL_PASSWORD=mysqlpwd \
 -e MYSQL_DATABASE=example \
 -e REPLICATION_USER=replication_user \
 -e REPLICATION_PASSWORD=myreplpassword \
 actency/docker-mysql-replication:5.7

```

## Start slave

```
docker run -d \
 --name mysql_slave \
 -v /data/slavemysql:/var/lib/mysql \
 -e MYSQL_ROOT_PASSWORD=mysqlroot \
 -e MYSQL_USER=example_user \
 -e MYSQL_PASSWORD=mysqlpwd \
 -e MYSQL_DATABASE=example \
 -e REPLICATION_USER=replication_user \
 -e REPLICATION_PASSWORD=myreplpassword \
 --link mysql_master:master \
 actency/docker-mysql-replication:5.7
```

## Check replication status

```
docker exec -it mysql_slave mysql -uroot -pmysqlroot -e "SHOW SLAVE STATUS\G;"
```
