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

## TODO

The following list details various TODO items left for the cutover:

- [x] create landuse function
- [x] create waterway function
- [x] create water function
	- [ ] find water_polygons table - https://github.com/thesocialdev/kartodock/blob/0c581f5fc8c5f6ded206994337a37b714164433f/workspace/osm-initial-import.sh#L104
- [x] create aeroway function
- [ ] create road function
- [x] create admin function
- [x] create country_label function
	- [ ] find extract_names function
- [ ] create poi_label function
- [x] create road_label function (renamed to transportation_name)
	- [ ] find extract_names function
	- [ ] figure out linelabel(zoom_level, name, way) function
- [ ] create place_label function
- [x] create buildings function
- [ ] migrate tegola config to use ST_AsMVT
- [ ] refine zoom levels
- [ ] create matviews for simplified layers
- [ ] index assessment for performance
