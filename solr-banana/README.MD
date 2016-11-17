**Docker solr-banana:**

This is a Docker image for Apache Solr and banana



# docker-solr

This is a Docker image for Apache Solr.

## What is Solr?

[Solr](http://lucene.apache.org/solr/) (pronounced "solar") is an open source enterprise search platform, written in Java, from the Apache Lucene project. Its major features include full-text search, hit highlighting, faceted search, real-time indexing, dynamic clustering, database integration, NoSQL features[1] and rich document (e.g., Word, PDF) handling. Providing distributed search and index replication, Solr is designed for scalability and Fault tolerance.

Learn more about Solr on the [Solr Wiki](https://cwiki.apache.org/confluence/display/solr/Apache+Solr+Reference+Guide).

## How to build this Docker image

```
$git clone https://github.com/bishnuroy/Docker/tree/master/solr-banana
$ cd /solr-banana
$ docker build -t solrreg.***.com/solr-banana:latest .
$docker images
```



**How to use this Docker image**
Standalone Solr (with Banana) example

1. Start standalone Solr (with Banana)

$ docker run -d -p 8984:8983 --name solr -e ENABLE_CORS=true -e CORE_NAME=collection1 solrreg.***.com/solr-banana:latest

2. Check container ID

$ docker ps
