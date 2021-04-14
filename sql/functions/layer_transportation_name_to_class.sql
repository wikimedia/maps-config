/*
  accepts a road name type value and maps the value to a class
*/
CREATE OR REPLACE FUNCTION public.layer_transportation_name_to_class(type text)
  RETURNS text
AS
  $$
    declare
      class_name text;

    BEGIN
      SELECT
        CASE
          WHEN type IN ('motorway', 'motorway_link', 'driveway') THEN 'highway'
          WHEN type IN ('primary', 'primary_link', 'trunk', 'trunk_link', 'secondary', 'secondary_link', 'tertiary', 'tertiary_link') THEN 'main'
          WHEN type IN ('residential', 'unclassified', 'living_street') THEN 'street'
          WHEN type IN ('pedestrian', 'construction', 'private') THEN 'street_limited'
          WHEN type IN ('rail', 'monorail', 'narrow_gauge', 'subway', 'tram') THEN 'major_rail'
          WHEN type IN ('service', 'track') THEN 'service'
          WHEN type IN ('path', 'cycleway', 'ski', 'steps', 'bridleway', 'footway') THEN 'path'
          WHEN type IN ('funicular', 'light_rail', 'preserved') THEN 'minor_rail'
          ELSE bail_out('Unexpected name type=%s', type::TEXT)
        END INTO class_name
      ;

      RETURN class_name;
    END;
  $$ language 'plpgsql';