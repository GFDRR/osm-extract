OSM extract scripts
===================

Right now all is configured to use data for Nepal, it will be more generic in the future.

Installation instructions
-------------------------

 * Install osmosis
 * Install GDAL version 1.9 or newer (make sure it supports hstore and pbf reading).
 * Install postgres/postgis

Running
-------
 
 * make all

Other
-----

 * You can tweak that configuration file to add or remove fields on the table, and still keep all others as a hstore (key/value) fields.

Myanmar
-------
mkdir -p /var/www/myanmar/data
su - postgres
createdb myanmar_osm
psql myanmar_osm
CREATE EXTENSION postgis;
CREATE EXTENSION hstore;
make all COUNTRY=myanmar
