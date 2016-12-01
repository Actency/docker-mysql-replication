FROM mysql:5.7

ENV REPLICATION_USER replication
ENV REPLICATION_PASSWORD replication_pass

COPY core/replication-entrypoint.sh /usr/local/bin/
COPY core/init-slave.sh /

ENTRYPOINT ["replication-entrypoint.sh"]
CMD ["mysqld"]
