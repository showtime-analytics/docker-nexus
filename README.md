docker-nexus
============

A image to run Nexus server. It's based in "showtimeanalytics/java-jre".

## Build

```
docker build -t showtimeanalytics/nexus:<version> .
```

## Versions

- `2.12.1-01` [(Dockerfile)](https://github.com/showtimeanalytics/nexus/blob/master/Dockerfile)

## Usage

To start the Nexus service, exec

```
docker run -td -v <volume>:/opt/sonatype-work/nexus showtimeanalytics/nexus:<version> .
```

You could configure Nexus mem params in execution time, setting that variables:
- HEAP_MIN="256"
- HEAP_MAX="768"

## Storage

If you want to assure data persistence, you need a persistent volume on /opt/sonatype-work/nexus

## Auth

Default admin user: admin
Default admin pass: admin123
