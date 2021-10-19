# ppas-to-rds

* https://www.enterprisedb.com/edb-docs/static/docs/epas/12/EDB_Postgres_Advanced_Server_Installation_Guide_Linux_v12.pdf

* postgresql DB생성 및 접속 시 Peer authentication에러 발생 시 해야할 것

     https://zipeya.tistory.com/entry/postgresql-DB%EC%83%9D%EC%84%B1-%EB%B0%8F-%EC%A0%91%EC%86%8D-%EC%8B%9C-Peer-authentication%EC%97%90%EB%9F%AC-%EB%B0%9C%EC%83%9D-%EC%8B%9C-%ED%95%B4%EC%95%BC%ED%95%A0-%EA%B2%83


```
enterprisedb@ip-172-31-13-123:/etc/edb-as/13/main$ pwd
/etc/edb-as/13/main

enterprisedb@ip-172-31-13-123:/etc/edb-as/13/main$ vi pg_hba.conf

# Database administrative login by Unix domain socket
local   all             enterprisedb                            peer

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     md5      <--- 변경
host    all             all             0.0.0.0/0               md5      <--- 변경

# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            md5
host    replication     all             ::1/128                 md5
```


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
