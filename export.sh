PLANET_FILE="planet-latest.osm.pbf"	
osmosis --read-pbf-fast file="$PLANET_FILE"  --tf accept-ways "building=*"  --write-pbf file="buildings.osm.pbf"
ogr2ogr -f PGDump buildings.sql buildings.osm.pbf -lco COLUMN_TYPES=other_tags=hstore
