CREATE OR REPLACE FUNCTION extract_names (tags hstore)
  RETURNS hstore
  AS
  $$
    SELECT
      hstore(array_agg(key), array_agg(value))
      FROM (
        SELECT
            SUBSTRING(key FROM 6) AS key,
            value
          FROM each(tags)
          WHERE key LIKE 'name:%'
      ) AS s(key, value)
      WHERE key NOT LIKE '%:%' -- Anything with a : still is a multi-level one, and not a simple language code
      AND key !~ '.*\d.*' -- matches something like name:en1
      AND key NOT IN ('prefix', 'genitive', 'etymology', 'botanical', 'source', 'left', 'right') -- blacklist common not-languages
  $$
LANGUAGE SQL
IMMUTABLE
STRICT;

--
-- Safe string to int conversion, on invalid input retrns 0 instead of raising an error
--
CREATE OR REPLACE FUNCTION to_int(s TEXT) RETURNS INTEGER
AS $$
BEGIN
    RETURN CASE WHEN s~E'^\\d+$' THEN s::INTEGER ELSE 0 END;
END;
$$ LANGUAGE plpgsql;

--
-- Raise an error in contexts where a return is expected
-- msg is a format string with param1..3 as optional parameters
-- See http://www.postgresql.org/docs/9.4/static/functions-string.html#FUNCTIONS-STRING-FORMAT for details
--
CREATE OR REPLACE FUNCTION bail_out(msg TEXT, param1 TEXT DEFAULT '', param2 TEXT DEFAULT '', param3 TEXT DEFAULT '') RETURNS TEXT
AS $$
BEGIN
    RAISE NOTICE '%', pg_catalog.format(msg, param1, param2, param3);
    RETURN '';
END;
$$ LANGUAGE plpgsql;

--
-- Returns processed map object name based on its name column
--
CREATE OR REPLACE FUNCTION get_label_name(name TEXT) RETURNS TEXT
AS $$
BEGIN
    RETURN pg_catalog.regexp_replace(name, '\s*;.*$', '');
END;
$$ LANGUAGE plpgsql;
