
-- planet_osm_merge_line_transportation_gen_z14
DROP MATERIALIZED VIEW IF EXISTS planet_osm_merge_line_transportation_gen_z14 CASCADE;
CREATE MATERIALIZED VIEW planet_osm_merge_line_transportation_gen_z14 AS (
  SELECT 
    NULL::bigint AS osm_id,
    tags,
    aeroway,
    access,
    bridge,
    highway,
    name,
    railway,
    ref,
    tunnel,
    waterway,
    z_order,
    way
  FROM (
    SELECT
      tags,
      aeroway,
      access,
      bridge,
      highway,
      name,
      railway,
      ref,
      tunnel,
      waterway,
      min(z_order) AS z_order,
      ST_LineMerge(ST_Collect(way)) AS way
    FROM 
      planet_osm_line
    WHERE 
      (
        highway IN ('motorway', 'primary', 'primary_link', 'trunk', 'trunk_link', 'secondary', 'secondary_link','tertiary', 'tertiary_link', 'residential', 'unclassified', 'living_street', 'pedestrian', 'construction', 'motorway_link', 'service', 'track', 'driveway','path', 'cycleway', 'ski', 'steps', 'bridleway', 'footway') 
        OR railway IN ('rail', 'monorail', 'narrow_gauge', 'subway', 'tram', 'funicular', 'light_rail', 'preserved') 
        OR access = 'private'
      ) AND ST_IsValid(way)
    GROUP BY
      tags, aeroway, access, bridge, highway, name, railway, ref, tunnel, waterway
    ) AS transportation_union
);

CREATE INDEX ON planet_osm_merge_line_transportation_gen_z14 USING gist (way);

-- planet_osm_merge_line_transportation_gen_z13
CREATE MATERIALIZED VIEW planet_osm_merge_line_transportation_gen_z13 AS (
  SELECT 
    osm_id,
    tags,
    aeroway,
    access,
    bridge,
    highway,
    name,
    railway,
    ref,
    tunnel,
    waterway,
    z_order,
    way
  FROM (
    SELECT
      osm_id,
      tags,
      aeroway,
      access,
      bridge,
      highway,
      name,
      railway,
      ref,
      tunnel,
      waterway,
      z_order,
      ST_Simplify(way, ZRes(11)) AS way
    FROM 
      planet_osm_merge_line_transportation_gen_z14
    WHERE
      (
        highway IN ('motorway', 'primary', 'primary_link', 'trunk', 'trunk_link', 'secondary', 'secondary_link','tertiary', 'tertiary_link', 'residential', 'unclassified', 'living_street', 'pedestrian', 'construction', 'motorway_link') 
        OR railway IN ('rail', 'monorail', 'narrow_gauge', 'subway', 'tram') 
        OR access = 'private'
      )
    ) AS transportation_union
);

CREATE INDEX ON planet_osm_merge_line_transportation_gen_z13 USING gist (way);

-- planet_osm_merge_line_transportation_gen_z12
CREATE MATERIALIZED VIEW planet_osm_merge_line_transportation_gen_z12 AS (
  SELECT 
    osm_id,
    tags,
    aeroway,
    access,
    bridge,
    highway,
    name,
    railway,
    ref,
    tunnel,
    waterway,
    z_order,
    way
  FROM (
    SELECT
      osm_id,
      tags,
      aeroway,
      access,
      bridge,
      highway,
      name,
      railway,
      ref,
      tunnel,
      waterway,
      z_order,
      ST_Simplify(way, ZRes(10)) AS way
    FROM 
      planet_osm_merge_line_transportation_gen_z13
    WHERE 
        highway IN ('motorway', 'primary', 'primary_link', 'trunk', 'trunk_link', 'secondary', 'secondary_link','tertiary', 'tertiary_link', 'residential', 'unclassified', 'living_street', 'pedestrian', 'construction') 
        OR railway IN ('rail', 'monorail', 'narrow_gauge', 'subway', 'tram') 
        OR access = 'private'
    ) AS transportation_union
);

CREATE INDEX ON planet_osm_merge_line_transportation_gen_z12 USING gist (way);

-- planet_osm_merge_line_transportation_gen_z11
CREATE MATERIALIZED VIEW planet_osm_merge_line_transportation_gen_z11 AS (
  SELECT 
    osm_id,
    tags,
    aeroway,
    access,
    bridge,
    highway,
    name,
    railway,
    ref,
    tunnel,
    waterway,
    z_order,
    way
  FROM (
    SELECT
      osm_id,
      tags,
      aeroway,
      access,
      bridge,
      highway,
      name,
      railway,
      ref,
      tunnel,
      waterway,
      z_order,
      ST_Simplify(way, ZRes(9)) AS way
    FROM 
      planet_osm_merge_line_transportation_gen_z12
    WHERE 
      highway IN ('motorway', 'primary', 'primary_link', 'trunk', 'trunk_link', 'secondary', 'secondary_link')
    ) AS transportation_union
);

CREATE INDEX ON planet_osm_merge_line_transportation_gen_z11 USING gist (way);

-- planet_osm_merge_line_transportation_gen_z10
CREATE MATERIALIZED VIEW planet_osm_merge_line_transportation_gen_z10 AS (
  SELECT 
    osm_id,
    tags,
    aeroway,
    access,
    bridge,
    highway,
    name,
    railway,
    ref,
    tunnel,
    waterway,
    z_order,
    way
  FROM (
    SELECT
      osm_id,
      tags,
      aeroway,
      access,
      bridge,
      highway,
      name,
      railway,
      ref,
      tunnel,
      waterway,
      z_order,
      ST_Simplify(way, ZRes(8)) AS way
    FROM 
      planet_osm_merge_line_transportation_gen_z11
    ) AS transportation_union
);

CREATE INDEX ON planet_osm_merge_line_transportation_gen_z10 USING gist (way);

-- planet_osm_merge_line_transportation_gen_z9
CREATE MATERIALIZED VIEW planet_osm_merge_line_transportation_gen_z9 AS (
  SELECT 
    osm_id,
    tags,
    aeroway,
    access,
    bridge,
    highway,
    name,
    railway,
    ref,
    tunnel,
    waterway,
    z_order,
    way
  FROM (
    SELECT
      osm_id,
      tags,
      aeroway,
      access,
      bridge,
      highway,
      name,
      railway,
      ref,
      tunnel,
      waterway,
      z_order,
      ST_Simplify(way, ZRes(7)) AS way
    FROM 
      planet_osm_merge_line_transportation_gen_z10
    WHERE 
      highway IN ('motorway', 'primary', 'primary_link', 'trunk', 'trunk_link')
    ) AS transportation_union
);

CREATE INDEX ON planet_osm_merge_line_transportation_gen_z9 USING gist (way);

-- planet_osm_merge_line_transportation_gen_z8
CREATE MATERIALIZED VIEW planet_osm_merge_line_transportation_gen_z8 AS (
  SELECT 
    osm_id,
    tags,
    aeroway,
    access,
    bridge,
    highway,
    name,
    railway,
    ref,
    tunnel,
    waterway,
    z_order,
    way
  FROM (
    SELECT
      osm_id,
      tags,
      aeroway,
      access,
      bridge,
      highway,
      name,
      railway,
      ref,
      tunnel,
      waterway,
      z_order,
      ST_Simplify(way, ZRes(6)) AS way
    FROM 
      planet_osm_merge_line_transportation_gen_z9
    WHERE 
      highway IN ('motorway', 'primary', 'primary_link', 'trunk', 'trunk_link')
    ) AS transportation_union
);

CREATE INDEX ON planet_osm_merge_line_transportation_gen_z8 USING gist (way);

-- planet_osm_merge_line_transportation_gen_z7
CREATE MATERIALIZED VIEW planet_osm_merge_line_transportation_gen_z7 AS (
  SELECT 
    osm_id,
    tags,
    aeroway,
    access,
    bridge,
    highway,
    name,
    railway,
    ref,
    tunnel,
    waterway,
    z_order,
    way
  FROM (
    SELECT
      osm_id,
      tags,
      aeroway,
      access,
      bridge,
      highway,
      name,
      railway,
      ref,
      tunnel,
      waterway,
      z_order,
      ST_Simplify(way, ZRes(5)) AS way
    FROM 
      planet_osm_merge_line_transportation_gen_z8
    WHERE 
      ST_Length(way) > 50
    ) AS transportation_union
);

CREATE INDEX ON planet_osm_merge_line_transportation_gen_z7 USING gist (way);

-- planet_osm_merge_line_transportation_gen_z6
CREATE MATERIALIZED VIEW planet_osm_merge_line_transportation_gen_z6 AS (
  SELECT 
    osm_id,
    tags,
    aeroway,
    access,
    bridge,
    highway,
    name,
    railway,
    ref,
    tunnel,
    waterway,
    z_order,
    way
  FROM (
    SELECT
      osm_id,
      tags,
      aeroway,
      access,
      bridge,
      highway,
      name,
      railway,
      ref,
      tunnel,
      waterway,
      z_order,
      ST_Simplify(way, ZRes(4)) AS way
    FROM 
      planet_osm_merge_line_transportation_gen_z7
    WHERE 
      ST_Length(way) > 100
    ) AS transportation_union
);

CREATE INDEX ON planet_osm_merge_line_transportation_gen_z6 USING gist (way);

-- planet_osm_merge_line_transportation_gen_z5
CREATE MATERIALIZED VIEW planet_osm_merge_line_transportation_gen_z5 AS (
  SELECT 
    osm_id,
    tags,
    aeroway,
    access,
    bridge,
    highway,
    name,
    railway,
    ref,
    tunnel,
    waterway,
    z_order,
    way
  FROM (
    SELECT
      osm_id,
      tags,
      aeroway,
      access,
      bridge,
      highway,
      name,
      railway,
      ref,
      tunnel,
      waterway,
      z_order,
      ST_Simplify(way, ZRes(3)) AS way
    FROM 
      planet_osm_merge_line_transportation_gen_z6
    WHERE 
      ST_Length(way) > 500
    ) AS transportation_union
);

CREATE INDEX ON planet_osm_merge_line_transportation_gen_z5 USING gist (way);
