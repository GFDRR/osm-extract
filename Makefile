# Install gdal 1.10 or newer and compile using the following:
# ./configure --with-spatialite=yes --with-expat=yes --with-python=yes
# Without it, the OSM format will not be enabled.

# Install latest osmosis to get the read-pbf-fast command. older versions
# like the one shipped with Ubuntu 14.04 do not have this option.

# Once you have them, make sure gdal/apps and osmosis/bin are added to our path before running this file.

DB=nepal_osm

nepal-latest.pbf: 
	curl -o $@ 'http://labs.geofabrik.de/nepal/latest.osm.pbf'

buildings.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "building=*"  --write-pbf file="$@"

roads.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "highway=*"  --write-pbf file="$@"

%.sql: %.pbf
	ogr2ogr -f PGDump $@ $< -lco COLUMN_TYPES=other_tags=hstore --config OSM_CONFIG_FILE conf/$(basename $@).ini

%.postgis: %.sql
	psql -f $< $(DB)
	psql -f conf/$(basename $@)_alter.sql $(DB)
	psql -f clean.sql -q $(DB)
