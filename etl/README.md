# Extract Transform and Load (ETL)

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

- `labelgrid`: contained in the [@kartotherian/postgis-vt-util:v0.3.1](https://github.com/kartotherian/postgis-vt-util/tree/v0.3.1) package but also included in the `./sql/functions/postgis_vt_util.sql` file.
- `merc_length`: contained in the [@kartoherian/postgis-vt-util:v0.3.1](https://github.com/kartotherian/postgis-vt-util/tree/v0.3.1) package but also included in the `./sql/functions/postgis_vt_util.sql` file.
- `extract_names`: contained in the `./sql/functions/helpers.sql` file.
- `bail`: an error reporting function contained in the `./sql/functions/helpers.sql` file.
- `to_int`: a type conversion function contained in the `./sql/functions/helpers.sql` file.
- `get_label_name`: contained in the `./sql/functions/helpers.sql` file.

## Import OSM data

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

## Import OSM water

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

## Create transportation generalized tables

The `planet_osm_merge_line_transportation_gen.sql` script needs to be run after the imposm import. This script will create materialized views for the transportation layers at various zooms implementing several optimizations including:

* Merging features of like type together to create longer lines. This is necessary to make simplification effective.
* Applying simplification to features with the tolerances based on the target zoom level. This reduces the fidelity of the feature on lower zooms, reducing the number of feature vertices with minimal visual difference.
* Filtering out short features. This is important at the lower zooms where short features are not visually present but would still be encoded and bloat the tile size unnecessarily.

To update the the transportation materialized views, the following SQL needs to be run:

```sql
SELECT refresh_planet_osm_merge_line_transportation_gen();
```

This call will cause all the materialized views to update CONCURRENTLY. The concurrently detail is key as it allows the view to be updated without blocking reads.

## Create additional indexes

Once the aforementioned steps are run the `create_indexes.sql` file should be run to build up additional indexes necessary for performance.
