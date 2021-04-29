# maps-config

This repository maintains instructions and configuration files necessary for running Wikimedia maps

## Software requirements

- [Postgres 11](https://www.postgresql.org/)
- [PostGIS 3.1](https://postgis.net/)
- [tegola v0.14.0+](https://github.com/go-spatial/tegola/releases)

## Repository layouot

* [tegola/](tegola/): contains the tegola config file and associated instructions.
* [sql/](sql/): The primay SQL functions that must be installed in the database. These functions are used by tegola for fetching geometries from Postgres.
* [etl/](etl): Instructions for running the extract, transform and load pipeline to populate the database with map data.
