BEGIN;

	-- layer_admin
	CREATE INDEX ON admin (maritime);
	CREATE INDEX ON admin (admin_level);

	-- layer_place_label
	CREATE INDEX ON planet_osm_point (name);
	CREATE INDEX ON planet_osm_point (place);
	CREATE INDEX ON planet_osm_point (population);

	-- layer_water
	CREATE INDEX ON planet_osm_polygon (landuse);
	CREATE INDEX ON planet_osm_polygon (waterway);
	CREATE INDEX ON planet_osm_polygon (way_area);

	-- layer_waterway
	CREATE INDEX ON planet_osm_line (waterway);
	CREATE INDEX ON planet_osm_polygon ("natural");
COMMIT;
