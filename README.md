
# Cluster Docker: Apache Atlas


## Background

This cluster in docker contains Apache Atlas (and its dependencies) with a minimal Hadoop ecosystem to perform some basic experiments. More precisely, it provides:

* Kafka and Zookeeper (Atlas also depends on them);
* HDFS 2.7;
* Hive 2.3.2;
* Spark 2.4.

### Quickstart

1. run `docker-compose build` to build this all docker image or
2. run `docker-compose up` to start all cluster services (it may take some time).
3. wait for the above message:

```
atlas-server_1 | Apache Atlas Server started!!!
atlas-server_1 | 
atlas-server_1 | waiting for atlas to be ready
atlas-server_1 | .....
atlas-server_1 | Server: Apache Atlas
```

or verify that server is up and running using:

```
curl -u admin:admin http://localhost:21000/api/atlas/admin/version
```

4. Access Atlas server (`http://localhost:21000`) using user *admin* and password *admin*


#### Testing Hive

Load data into Hive:
```
  $ docker-compose exec hive-server bash
  # /opt/hive/bin/beeline -u jdbc:hive2://localhost:10000
  > CREATE TABLE pokes (foo INT, bar STRING);
  > LOAD DATA LOCAL INPATH '/opt/hive/examples/files/kv1.txt' OVERWRITE INTO TABLE pokes;
```

or 


```
create table brancha(full_name string, ssn string, location string);
create table branchb(full_name string, ssn string, location string);
insert into brancha(full_name,ssn,location) values ('ryan', '111-222-333', 'chicago'); 
insert into brancha(full_name,ssn,location) values ('brad', '444-555-666', 'minneapolis'); 
insert into brancha(full_name,ssn,location) values ('rupert', '000-000-000', 'chicago'); 
insert into brancha(full_name,ssn,location) values ('john', '555-111-555', 'boston');
insert into branchb(full_name,ssn,location) values ('jane', '666-777-888', 'dallas'); 
insert into branchb(full_name,ssn,location) values ('andrew', '999-999-999', 'tampa'); 
insert into branchb(full_name,ssn,location) values ('ryan', '111-222-333', 'chicago'); 
insert into branchb(full_name,ssn,location) values ('brad', '444-555-666', 'minneapolis');
create table branch_intersect as select b1.full_name,b1.ssn,b1.location from brancha b1 inner join branchb b2 ON b1.ssn = b2.ssn;

```

#### Testing Spark

To run some code in Spark:
```
  $ docker-compose exec spark bash
  # /usr/local/spark/bin/spark-submit /tmp/teste.py
```

#### NOTE: 

 * All project is quite large, for instance, Apache atlas has 1.0GB because of atlas bins and its dependencies (hbase and solr).
 * Also startup may take some time depending on HW resources ...
 * If you want, you may start only a fell components `docker-compose up atlas-server spark`
 * Atlas server was based on [Rokku project](https://github.com/ing-bank/rokku-dev-apache-atlas)
 * Hive and HDFS was based on [bde2020 project](https://hub.docker.com/r/bde2020/hive/)

