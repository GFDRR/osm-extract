# Install gdal 1.10 or newer and compile using the following:
# ./configure --with-spatialite=yes --with-expat=yes --with-python=yes
# Without it, the OSM format will not be enabled.

# Install latest osmosis to get the read-pbf-fast command. older versions
# like the one shipped with Ubuntu 14.04 do not have this option.

# Once you have them, make sure gdal/apps and osmosis/bin are added to our path before running this file.

DB=nepal_osm
DATA_DIR=data
EXPORT_DIR=/var/www/html/data

nepal-latest.pbf: 
	curl -o $@ 'http://labs.geofabrik.de/nepal/latest.osm.pbf'

buildings.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "building=*"  --write-pbf file="$@"

damage.pbf: buildings.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "building=damaged" --tf accept-ways "buildings=collapsed"  --write-pbf file="$@"


huts.pbf: buildings.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "building=hut" --write-pbf file="$@"

trees.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-nodes "natural=tree" --write-pbf file="$@"

schools.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-nodes "amenity=school" --tf accept-nodes "amenity=university"  --tf accept-nodes "amenity=college" --tf accept-nodes "amenity=kindergarten"  --write-pbf file="$@"

medical_points.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-nodes "amenity=hospital" --tf accept-nodes "amenity=doctors"  --tf accept-nodes "amenity=doctor" --tf accept-nodes "amenity=clinic"  --tf accept-nodes "amenity=health_post"   --write-pbf file="$@"

medical_polygons.pbf: buildings.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "amenity=hospital" --tf accept-ways "amenity=doctors"  --tf accept-ways "amenity=doctor" --tf accept-ways "amenity=clinic"  --tf accept-ways "amenity=health_post"   --write-pbf file="$@"
  
roads.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "highway=*"  --write-pbf file="$@"

rivers.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "waterway=river" --tf accept-ways "waterway=stream"  --tf accept-ways "waterway=ditch" --write-pbf file="$@"
  
riverbanks.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "waterway=riverbank" --write-pbf file="$@"

lakes.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "natural=water" --tf accept-ways "water=lake" --write-pbf file="$@"
 
beaches.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "natural=beach" --write-pbf file="$@"

farms.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "landuse=farm" --tf accept-ways "landuse=farmland" --tf accept-ways "landuse=farmyard" --write-pbf file="$@"
 
forest.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "landuse=forest" --write-pbf file="$@"
 
grassland.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "landuse=grass" --tf accept-ways "landuse=grassland" --tf accept-ways "natural=wood"  --tf accept-ways "natural=grassland" --write-pbf file="$@"
 
military.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "landuse=military" --write-pbf file="$@"
 
orchards.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "landuse=orchard" --write-pbf file="$@"

residential.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "landuse=residential" --write-pbf file="$@"

village_green.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "landuse=village_green" --write-pbf file="$@"

wetlands.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "landuse=wetland" --write-pbf file="$@"

cities.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-nodes "place=city" --write-pbf file="$@"

hamlets.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-nodes "place=hamlet" --write-pbf file="$@"

neighborhoods.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-nodes "place=neighborhood" --tf accept-nodes "place=neighbourhood"  --write-pbf file="$@"

villages.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-nodes "place=village" --write-pbf file="$@"

placenames.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-nodes "place=city" --tf accept-nodes "place=hamlet" --tf accept-nodes "place=neighborhood" --tf accept-nodes "place=neighbourhood" --tf accept-nodes "place=village"   --write-pbf file="$@"


all_roads.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "highway=tertiary" --tf accept-ways "highway=residential" --tf accept-ways "highway=service" --tf accept-ways "highway=secondary" --tf accept-ways "highway=track" --tf accept-ways "highway=footway" --tf accept-ways "highway=path" --tf accept-ways "highway=unclassified" --tf accept-ways "highway=primary" --tf accept-ways "highway=trunk" --tf accept-ways "highway=motorway" --tf accept-ways "highway=construction" --tf accept-ways "highway=proposed" --tf accept-ways "highway=cycleway" --tf accept-ways "highway=living_street" --tf accept-ways "highway=steps" --tf accept-ways "highway=road" --tf accept-ways "highway=pedestrian" --tf accept-ways "highway=construction" --tf accept-ways "highway=bridleway" --tf accept-ways "highway=platform" --tf accept-ways "highway=proposed" --write-pbf file="$@"

main_roads.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "highway=motorway" --tf accept-ways "highway=trunk" --tf accept-ways "highway=primary"   --write-pbf file="$@"

paths.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "highway=path" --tf accept-ways "highway=trunk" --tf accept-ways "highway=primary"   --write-pbf file="$@"

tracks.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "highway=tracks" --write-pbf file="$@"

aerodromes_point.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-nodes "aeroway=aerodrome"  --tf accept-nodes "aeroway=international"  --write-pbf file="$@"

aerodromes_polygon.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "aeroway=aerodrome"  --tf accept-ways "aeroway=international"  --write-pbf file="$@"


banks.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-nodes "amenity=bank" --write-pbf file="$@"

fire_stations.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-nodes "amenity=fire_station" --write-pbf file="$@"

hotels.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-nodes "turism=hotel" --write-pbf file="$@"


police_stations.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-nodes "amenity=police"  --tf accept-nodes "tourism=police"  --write-pbf file="$@"

restaurants.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-nodes "amenity=restaurant"  --tf accept-nodes "amenity=restaurants"  --write-pbf file="$@"

train_stations.pbf: nepal-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-nodes "railway=station"  --write-pbf file="$@"

SQL_EXPORTS = buildings.sql damage.sql huts.sql trees.sql schools.sql medical_points.sql medical_polygons.sql roads.sql  rivers.sql riverbanks.sql lakes.sql beaches.sql farms.sql forest.sql grassland.sql military.sql orchards.sql residential.sql village_green.sql wetlands.sql cities.sql hamlets.sql neighborhoods.sql villages.sql placenames.sql all_roads.sql main_roads.sql paths.sql tracks.sql aerodromes_point.sql aerodromes_polygon.sql banks.sql fire_stations.sql hotels.sql police_stations.sql restaurants.sql train_stations.sql

PBF_EXPORTS = $(SQL_EXPORTS:.sql=.pbf)
SQL_ZIP_EXPORTS = $(SQL_EXPORTS:.sql=.sql.zip)

%.sql: %.pbf
	ogr2ogr -f PGDump $@ $< -lco COLUMN_TYPES=other_tags=hstore --config OSM_CONFIG_FILE conf/$(basename $@).ini

%.sql.zip: %.sql
	zip $@ $<

%.postgis: %.sql
	psql -f $< $(DB)
	psql -f conf/$(basename $@)_alter.sql $(DB)
	psql -f conf/clean.sql -q $(DB)

all: $(PBF_EXPORTS)
	cp *.pbf /var/www/html/data


.PHONY: clean
clean:
	rm -rf nepal-latest.pbf
	rm -rf buildings.pbf roads.pbf
	rm -rf buildings.zip roads.zip
	rm -rf buildings.sql roads.sql
