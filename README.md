# EDB Postgres Advanced Server to Amazon RDS


#### PostgreSQL 소스 데이터베이스 설정 ####

* https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html

#### logical replication ####

* https://medium.com/@ramesh.esl/change-data-capture-cdc-in-postgresql-7dee2d467d1b
  
#### logical replication plugin ####  
* [pglogical 2.4.0](https://www.postgresql.org/about/news/pglogical-240-now-available-2284/)
* [test_decoding](https://www.enterprisedb.com/edb-docs/d/postgresql/reference/manual/11.7/test-decoding.html)






* 데이터베이스 재기동

```
ubuntu@ip-172-31-13-123:~$ sudo su -
root@ip-172-31-13-123:~# systemctl status edb-as@13-main
● edb-as@13-main.service - EPAS Cluster 13-main
     Loaded: loaded (/lib/systemd/system/edb-as@.service; enabled-runtime; vendor preset: enabled)
     Active: active (running) since Tue 2021-10-19 10:55:21 UTC; 5min ago
    Process: 67948 ExecStart=/usr/bin/epas_ctlcluster --skip-systemctl-redirect 13-main start (code=exited, statu>
   Main PID: 67959 (edb-postgres)
      Tasks: 8 (limit: 37564)
     Memory: 202.2M
     CGroup: /system.slice/system-edb\x2das.slice/edb-as@13-main.service
             ├─67959 /usr/lib/edb-as/13/bin/edb-postgres -D /var/lib/edb-as/13/main -c config_file=/etc/edb-as/13>
             ├─67966 postgres: 13/main: checkpointer
             ├─67967 postgres: 13/main: background writer
             ├─67968 postgres: 13/main: walwriter
             ├─67969 postgres: 13/main: autovacuum launcher
             ├─67970 postgres: 13/main: stats collector
             ├─67971 postgres: 13/main: dbms_aq launcher
             └─67972 postgres: 13/main: logical replication launcher

Oct 19 10:55:19 ip-172-31-13-123 systemd[1]: Starting EPAS Cluster 13-main...
Oct 19 10:55:21 ip-172-31-13-123 systemd[1]: Started EPAS Cluster 13-main.
root@ip-172-31-13-123:~# systemctl restart edb-as@13-main
```

