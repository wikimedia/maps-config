# etl

This folder will contain instructions on the map data Extract Transform and Load steps.

## Database setup

All data will be stored in a single database named `osm`. Connect to the database then run the following commands:

```console
psl> CREATE DATABASE osm;
psl> \c osm
psl> CREATE EXTENSION postgis;
psl> CREATE EXTENSION hstore;
```

The database also requires additional supporting functions:

- `extract_names`: TBD, identify the location of this function.


## OSM

## OSM water

