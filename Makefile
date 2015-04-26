
nepal-latest.osm.pbf:
	curl -o $@ 'http://download.geofabrik.de/asia/nepal-latest.osm.pbf'

buildings.pbf: nepal-latest.osm.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "building=*"  --write-pbf file="$@"

buildings.sql: buildings.pbf
	ogr2ogr -f PGDump $< $@ -lco COLUMN_TYPES=other_tags=hstore --config OSM_CONFIG_FILE conf/buildings.ini

roads.pbf: nepal-latest.osm.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "building=*"  --write-pbf file="$@"

roads.sql: roads.pbf
	ogr2ogr -f PGDump $< $@ -lco COLUMN_TYPES=other_tags=hstore --config OSM_CONFIG_FILE conf/roads.ini


