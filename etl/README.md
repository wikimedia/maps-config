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

- `extract_names`: contained in the `./sql/helpers.sql` file.
- `labelgrid`: This is contained in the [postgis-vt-util](https://github.com/mapbox/postgis-vt-util) package.

## OSM

TODO: discuss the OSM data ETL process.

## OSM water

The OSM water layer is maintained by https://osmdata.openstreetmap.de. The layer is derived from OSM data and is pre-split to aid with tile generation. Note that when using pre-split data polygons will overlap at the split seams. This is to avoid rendering artifacts but also makes using opacity in styling less desirable as the seams will show.

Prior to importing the water layer, set the following environment variables: 

- `PGHOST`: The Postgres database host
- `PGUSER`: The Postgres database user
- `PGDATABASE`: The Postgres database name

Now the water data can be fetched and imported:

```console
$ curl -O https://osmdata.openstreetmap.de/download/water-polygons-split-3857.zip
$ unzip water-polygons-split-3857.zip
$ shp2pgsql -I -c -s 3857 -g way water-polygons-split-3857/water_polygons.shp water_polygons | psql -h ${PGHOST} -U ${PGUSER} -d ${PGDATABASE}
```


```console
$ curl -O https://osmdata.openstreetmap.de/download/simplified-water-polygons-split-3857.zip
$ unzip simplified-water-polygons-split-3857.zip
$ shp2pgsql -I -c -s 3857 -g way simplified-water-polygons-split-3857/simplified_water_polygons.shp simplified_water_polygons | psql -h ${PGHOST} -U ${PGUSER} -d ${PGDATABASE}
```
