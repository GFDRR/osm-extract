# Install gdal 1.10 or newer and compile using the following:
# ./configure --with-spatialite=yes --with-expat=yes --with-python=yes
# Without it, the OSM format will not be enabled.

# Install latest osmosis to get the read-pbf-fast command. older versions
# like the one shipped with Ubuntu 14.04 do not have this option.

# Once you have them, make sure gdal/apps and osmosis/bin are added to our path before running this file.
ifeq ($(COUNTRY),)
abort:
	@echo Variable COUNTRY not set && false
endif

DB=$(COUNTRY)_osm
EXPORT_DIR=/var/www/html/$(COUNTRY)/data

bangladesh-latest.pbf:
	curl -o $@ 'http://download.geofabrik.de/asia/bangladesh-latest.osm.pbf'

nepal-latest.pbf: 
	curl -o $@ 'http://labs.geofabrik.de/nepal/latest.osm.pbf'

dominica-latest.pbf:
	curl -o $@ 'http://download.openstreetmap.fr/extracts/central-america/country-latest.osm.pbf'

country-latest.pbf: $(COUNTRY)-latest.pbf
	cp $< $@

buildings.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "building=*"  --write-pbf file="$@"

bridges.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "bridge=*"  --write-pbf file="$@"

idp_camps.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --wkv keyValueList="idp:camp_site=spontaneous_camp,damage:event.dominica_earthquake_2015" --used-node  --write-pbf  file="$@"

huts.pbf: buildings.pbf
	osmosis --read-pbf-fast file="$<" --tf accept-ways "building=hut" --used-node --write-pbf file="$@"

trees.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --tf accept-nodes "natural=tree" --tf reject-ways --tf reject-relations --write-pbf file="$@"

schools_point.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --nkv keyValueList="amenity.school,amenity.university,amenity.college,amenity.kindergarten" --write-pbf file="$@"

schools_polygon.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --wkv keyValueList="amenity.school,amenity.university,amenity.college,amenity.kindergarten" --used-node --write-pbf file="$@"

medical_point.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --nkv keyValueList="amenity.hospital,amenity.doctors,amenity.doctor,amenity.clinic,amenity.health_post" --write-pbf file="$@"

medical_polygon.pbf: buildings.pbf
	osmosis --read-pbf-fast file="$<" --wkv keyValueList="amenity.hospital,amenity.doctors,amenity.doctor,amenity.clinic,amenity.health_post" --used-node --write-pbf file="$@"
  
roads.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "highway=*" --used-node --write-pbf file="$@"

rivers.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --wkv keyValueList="waterway.river,waterway.stream,waterway.ditch" --used-node --write-pbf file="$@"
  
riverbanks.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --wkv keyValueList="waterway.riverbank" --used-node --write-pbf file="$@"

lakes.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --wkv keyValueList="natural.water,water.lake" --used-node --write-pbf file="$@"
 
beaches.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --wkv keyValueList="natural.beach" --used-node --write-pbf file="$@"

farms.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --wkv keyValueList="landuse.farm,landuse.farmland,landuse.farmyard" --used-node --write-pbf file="$@"
 
forest.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --wkv keyValueList="landuse.forest" --used-node --write-pbf file="$@"
 
grassland.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --wkv keyValueList="landuse.grass,landuse.grassland,natural.wood,natural.grassland" --used-node --write-pbf file="$@"
 
military.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "landuse=military" --used-node --write-pbf file="$@"
 
orchards.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "landuse=orchard" --used-node --write-pbf file="$@"

residential.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "landuse=residential" --used-node --write-pbf file="$@"

village_green.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "landuse=village_green" --used-node --write-pbf file="$@"

wetlands.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-ways "landuse=wetland" --used-node --write-pbf file="$@"

cities.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-nodes "place=city" --tf reject-ways --tf reject-relations --write-pbf file="$@"

hamlets.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-nodes "place=hamlet" --tf reject-ways --tf reject-relations  --write-pbf file="$@"

neighborhoods.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --nkv keyValueList="place.neighborhood,place.neighbourhood" --tf reject-ways --tf reject-relations  --write-pbf file="$@"

villages.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<"  --tf accept-nodes "place=village" --tf reject-ways --tf reject-relations --write-pbf file="$@"

placenames.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --nkv keyValueList="place.city,place.hamlet,place.neighborhood,place.neighbourhood,place.village" --tf reject-ways --tf reject-relations --write-pbf file="$@"


all_roads.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --wkv keyValueList="highway.unclassified,highway.tertiary,highway.residential,highway.service,highway.secondary,highway.track,highway.footway,highway.path,highway.classified,highway.primary,highway.trunk,highway.motorway,highway.construction,highway.proposed,highway.cycleway,highway.living_street,highway.steps,highway.road,highway.pedestrian,highway.construction,highway.bridleway,highway.platformhighway.proposed" --used-node --write-pbf file="$@"

main_roads.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --wkv keyValueList="highway.motorway,highway.trunk,highway.primary" --used-node --write-pbf file="$@"

paths.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --wkv keyValueList="highway.path,highway.trunk,highway.primary" --used-node  --write-pbf file="$@"

tracks.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<"  --wkv keyValueList="highway.track" --used-node --write-pbf file="$@"

aerodromes_point.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --nkv keyValueList="aeroway.aerodrome,aeroway.international" --write-pbf file="$@"

aerodromes_polygon.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<"  --wkv keyValueList="aeroway.aerodrome,aeroway.international" --used-node --write-pbf file="$@"

banks.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --tf accept-nodes "amenity=bank" --tf reject-ways --tf reject-relations --write-pbf file="$@"

fire_stations.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --tf accept-nodes "amenity=fire_station" --tf reject-ways --tf reject-relations  --write-pbf file="$@"

hotels.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --nkv keyValueList="tourism.hotel,amenity.hotel" --tf reject-ways --tf reject-relations  --write-pbf file="$@"

police_stations.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --nkv keyValueList="amenity.police,tourism.police" --tf reject-ways --tf reject-relations  --write-pbf file="$@"

restaurants.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --nkv keyValueList="amenity.restaurant,amenity.restaurants" --tf reject-ways --tf reject-relations --write-pbf file="$@"

train_stations.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --tf accept-nodes "railway=station" --tf reject-ways --tf reject-relations  --write-pbf file="$@"

helipads.pbf: country-latest.pbf
	osmosis --read-pbf-fast file="$<" --wkv keyValueList="aeroway.helipad" --used-node --write-pbf file="$@"

ifeq ($(COUNTRY), dominica)
 SQL_EXPORTS = buildings.sql schools_point.sql schools_polygon.sql medical_point.sql medical_polygon.sql rivers.sql lakes.sql farms.sql forest.sql grassland.sql orchards.sql hamlets.sql villages.sql placenames.sql all_roads.sql main_roads.sql paths.sql tracks.sql aerodromes_point.sql aerodromes_polygon.sql banks.sql  hotels.sql police_stations.sql restaurants.sql bridges.sql
endif

ifeq ($(COUNTRY), nepal)
 SQL_EXPORTS = buildings.sql schools_point.sql schools_polygon.sql medical_point.sql medical_polygon.sql rivers.sql riverbanks.sql lakes.sql farms.sql forest.sql grassland.sql military.sql orchards.sql residential.sql village_green.sql cities.sql hamlets.sql neighborhoods.sql villages.sql placenames.sql all_roads.sql main_roads.sql paths.sql tracks.sql aerodromes_point.sql aerodromes_polygon.sql banks.sql  hotels.sql police_stations.sql restaurants.sql train_stations.sql idp_camps.sql helipads.sql
endif

ifeq ($(COUNTRY), bangladesh)
 SQL_EXPORTS = buildings.sql schools_point.sql schools_polygon.sql medical_point.sql medical_polygon.sql rivers.sql riverbanks.sql lakes.sql farms.sql forest.sql grassland.sql military.sql orchards.sql residential.sql cities.sql hamlets.sql neighborhoods.sql villages.sql placenames.sql all_roads.sql main_roads.sql paths.sql tracks.sql aerodromes_point.sql aerodromes_polygon.sql banks.sql  hotels.sql police_stations.sql restaurants.sql train_stations.sql helipads.sql
endif


EXPORTS = $(SQL_EXPORTS:.sql=)
PBF_EXPORTS = $(SQL_EXPORTS:.sql=.pbf)
POSTGIS_EXPORTS = $(SQL_EXPORTS:.sql=.postgis)
SQL_ZIP_EXPORTS = $(SQL_EXPORTS:.sql=.sql.zip)
SHP_ZIP_EXPORTS = $(SQL_EXPORTS:.sql=.shp.zip)
GEOJSON_EXPORTS = $(SQL_EXPORTS:.sql=.json)
KML_EXPORTS = $(SQL_EXPORTS:.sql=.kml)

%.sql: %.pbf
	ogr2ogr -f PGDump $@ $< -lco COLUMN_TYPES=other_tags=hstore --config OSM_CONFIG_FILE conf/$(basename $@).ini

%.shp: %.postgis
	pgsql2shp -f $(basename $@) $(DB) public.$(basename $<)

%.json: %.shp
	ogr2ogr -f GeoJSON -t_srs crs:84 $@ $<

%.kml: %.shp
	ogr2ogr -f KML -t_srs crs:84 $@ $<

%.shp.zip: %.shp
	zip $@ $< $(basename $<).prj  $(basename $<).dbf $(basename $<).shx

%.sql.zip: %.sql
	zip $@ $<

%.postgis: %.sql
	psql -f $< $(DB)
	psql -f conf/$(basename $@)_alter.sql $(DB)
	psql -f conf/clean.sql -q $(DB)

all: $(PBF_EXPORTS) $(SQL_EXPORTS) $(SQL_ZIP_EXPORTS) $(SHP_ZIP_EXPORTS) $(GEOJSON_EXPORTS) $(KML_EXPORTS) stats.js
	cp *.pbf $(EXPORT_DIR)
	cp *.sql.zip $(EXPORT_DIR)
	cp *.shp.zip $(EXPORT_DIR)
	cp *.json $(EXPORT_DIR)
	cp *.kml $(EXPORT_DIR)
	cp stats.js $(EXPORT_DIR)

postgis: $(POSTGIS_EXPORTS)

stats.js: 
	python stats.py --names="$(EXPORTS)" >> $@

.PHONY: clean
clean:
	rm -rf *.pbf
	rm -rf *.zip
	rm -rf *.sql
	rm -rf *.shp
	rm -rf *.dbf
	rm -rf *.shx
	rm -rf *.prj
	rm -rf *.json
	rm -rf *.kml
	rm -rf stats.js
	psql -f conf/clean.sql -q $(DB)
