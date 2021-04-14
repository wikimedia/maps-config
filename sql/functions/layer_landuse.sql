CREATE OR REPLACE FUNCTION public.layer_landuse(bbox geometry, zoom_level integer)
    RETURNS TABLE(osm_id bigint, geometry geometry, class text, z_order integer, way_area real) 
    LANGUAGE 'sql'
    COST 100
    IMMUTABLE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
  SELECT
    osm_id,
    way,
    CASE
      WHEN "natural" = 'wood' OR landuse IN ('wood', 'forest') THEN 'wood'
      WHEN leisure IN ('national_reserve', 'nature_reserve', 'golf_course') OR boundary = 'national_park' THEN 'park'
      WHEN landuse IN ('cemetery', 'industrial') THEN landuse
      WHEN aeroway IS NOT NULL AND aeroway <> '' THEN 'industrial'
      WHEN landuse = 'village_green' OR leisure IN ('park', 'playground') THEN 'park'
      WHEN amenity IN ('school', 'university') THEN 'school'
      WHEN amenity = 'hospital' THEN 'hospital'
      ELSE bail_out('Unexpected landuse row with osm_id=%s', osm_id::TEXT)
    END AS class,
    z_order,
    way_area
  FROM 
    planet_osm_polygon
  WHERE
    (
      (
        (
          "natural" = 'wood' OR landuse IN ('wood', 'forest')
          OR leisure IN ('national_reserve', 'nature_reserve', 'golf_course')
          OR boundary = 'national_park'
        )
        AND zoom_level >= 7
      ) OR (
        (
          landuse IN ('cemetery', 'industrial', 'village_green')
          OR (aeroway IS NOT NULL AND aeroway <> '')
          OR leisure IN ('park', 'playground')
          OR amenity IN ('school', 'university')
        )
        AND zoom_level >= 10
      ) OR (
        amenity = 'hospital'
        AND zoom_level >= 12
      )
    )
    AND 
      way && bbox
    ORDER BY z_order, way_area DESC
  ;
$BODY$;

