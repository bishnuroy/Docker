**Docker solr-banana:**

This is a Docker image for Apache Solr and banana



# docker-solr

This is a Docker image for Apache Solr.

## What is Solr?

[Solr](http://lucene.apache.org/solr/) (pronounced "solar") is an open source enterprise search platform, written in Java, from the Apache Lucene project. Its major features include full-text search, hit highlighting, faceted search, real-time indexing, dynamic clustering, database integration, NoSQL features[1] and rich document (e.g., Word, PDF) handling. Providing distributed search and index replication, Solr is designed for scalability and Fault tolerance.

Learn more about Solr on the [Solr Wiki](https://cwiki.apache.org/confluence/display/solr/Apache+Solr+Reference+Guide).

## How to build this Docker image

```
$mkdir /solr-banana

$ cd /solr-banana
$ docker build -t solrreg.***.com/solr-banana:latest .
```