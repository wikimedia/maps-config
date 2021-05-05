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

- `labelgrid`: contained in the [postgis-vt-util](https://github.com/mapbox/postgis-vt-util) package.
- `extract_names`: contained in the `./sql/helpers.sql` file.
- `bail`: an error reporting function contained in the `./sql/helpers.sql` file.
- `to_int`: a type conversion function contained in the `./sql/helpers.sql` file.
- `get_label_name`: contained in the `./sql/helpers.sql` file.

## OSM

The initial OSM import process has several steps:

* Download a PBF extract from [https://download.geofabrik.de](https://download.geofabrik.de)
* Run [imposm3](https://github.com/omniscale/imposm3) against the PBF extract to import the data into PostGIS.

Imposm3 uses a config file in the following format:

```json
{
    "cachedir": "/root/kartosm/cache",
    "diffdir": "/root/kartosm/diff",
    "expiretiles_dir": "/root/kartosm/expiretiles",
    "expiretiles_zoom": 15,
    "connection": "postgis: user=user password=password dbname=osm host=host prefix=NONE",
    "mapping": "/root/wiki-repos/kartodock/workspace/mapping.yml",
    "replication_url": "https://planet.openstreetmap.org/replication/minute/"
}
```

Adjust the parameters to match the environment. 

The following imposm command is an "end to end" run. It will perform the following:

* read the OSM extract PBF `europe-latest.osm.pbf` (`-read` flag)
* prepare a diff directory for future imports (`-diff` flag)
* connect to the database using the `connection` string defined in the `config.europe.json` file. (`-write` flag)
* import the data to the `import` schema using the `mapping` file defined in the `config.europe.json` file.
* copy the data to the `public` schema (`-deployproduction` flag)

```console
$ imposm import -config config.europe.json -overwritecache -read europe-latest.osm.pbf -diff -write -deployproduction
```

This process is long, so after you start the job make sure to have a nice movie queued up to pass the time.

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

And the simplified water polygons:

```console
$ curl -O https://osmdata.openstreetmap.de/download/simplified-water-polygons-split-3857.zip
$ unzip simplified-water-polygons-split-3857.zip
$ shp2pgsql -I -c -s 3857 -g way simplified-water-polygons-split-3857/simplified_water_polygons.shp water_polygons_simplified | psql -h ${PGHOST} -U ${PGUSER} -d ${PGDATABASE}
```

## Create additional indexes

Once the aforementioned steps are run the `create_indexes.sql` file should be run to build up additional indexes necessary for performance.
