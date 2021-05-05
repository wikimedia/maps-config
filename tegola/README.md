# tegola

[Tegola](https://github.com/go-spatial/tegola) is responsible for receiving vector tile requests, forming up database queries and returing the encoded vector tiles to the client. 

## Tegola config

`tegola.toml` uses tegola's `mvt_postgis` provider along with ST_AsMVT(). This will engage PostGIS to perform the geoprocessing and vector tile encoding.

### Config Environment Variables

The tegola config expects the following environment variables to be set:

* `DB_HOST`: The database host.
* `DB_PORT`: The port the database is listening on
* `DB_NAME`: The name of the database to operate against.
* `DB_USER`: The user to connect to the database with.
* `DB_PASSWORD`: The password for the user connecting to the database.

## Running tegola

To run tegola, issue the following command:

```console
$ tegola serve --config=tegola.toml
```
