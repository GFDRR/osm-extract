Building extract scripts
========================


Installation instructions
-------------------------

 * Install osmosis
 * Install GDAL version 1.9 or newer (make sure it supports hstore and pbf reading).
 * Install postgres/postgis
 * Download a recent planet file in PBF format from OSM (Around 20 something gigabytes)
 * Run the steps in extract.sh from your shell, make sure ogr2ogr is reading the osm configuration file in the repo.
 * You can tweak that configuration file to add or remove fields on the table, and still keep all others as a hstore (key/value) fields.

