#!/bin/bash

set -e

for filename in ./*.shp.gz; do
    basename="./$(basename "$filename" .shp.gz)"
    geojson="${basename}.geojson"

    echo Checking "$basename"

    if [ ! -f "${basename}.mbtiles" ]; then
    	if [ ! -f $geojson ]; then
          echo Converting "$basename" to GeoJSON
          rm -f "${basename}.shp"
          gunzip --keep "$filename"
          ogr2ogr -f GeoJSON "${basename}.geojson" -t_srs EPSG:4326 "${basename}.shp"
          rm -f "${basename}.shp"
          rm -f ${basename}_*_TMP.mbtiles ${basename}.mbtiles
        fi

        echo Converting "$basename" to MBTiles
        rm -f ${basename}_*_TMP.mbtiles ${basename}.mbtiles
        tippecanoe --quiet -Z6 -z9 -r1 -C "jq '. | select( (.properties.height % 1000) == 0 )'" -l contours -n contours -o "${basename}_09_TMP.mbtiles" "$geojson" || true
        tippecanoe --quiet -Z10 -z10 -r1 -C "jq '. | select( (.properties.height % 250) == 0 )'" -l contours -n contours -o "${basename}_10_TMP.mbtiles" "$geojson" || true
        tippecanoe --quiet -Z11 -z11 -r1 -C "jq '. | select( (.properties.height % 100) == 0 )'" -l contours -n contours -o "${basename}_11_TMP.mbtiles" "$geojson" || true
        tippecanoe --quiet -Z12 -z12 -r1 -C "jq '. | select( (.properties.height % 50) == 0 )'" -l contours -n contours -o "${basename}_12_TMP.mbtiles" "$geojson" || true
        tippecanoe --quiet -Z13 -z13 -r1 -C "jq '. | select( (.properties.height % 20) == 0 )'" -l contours -n contours -o "${basename}_13_TMP.mbtiles" "$geojson" || true
        tippecanoe --quiet -Z14 -z14 -r1 -C "jq '. | select( (.properties.height % 10) == 0 )'" -l contours -n contours -o "${basename}_14_TMP.mbtiles" "$geojson" || true
        tile-join -o ${basename}.mbtiles ${basename}_*_TMP.mbtiles
        rm -f ${basename}_*_TMP.mbtiles
    fi
done
