This repository contains some tools to convert raw data provided by [OpenSnowMap](https://www.opensnowmap.org) to `mbtiles` file that can be used for example using [MapLibre](https://maplibre.org).

# Source

Data provided by OpenSnowMap: https://www.opensnowmap.org/download/relief/

# Tools

The following tools are used for the conversion:

* ogr2ogr
* tippecanoe
* tile-join

Using the provided Dockerfile you can build a container image with these tools.

Build image:
```sh
docker build -t opensnowmap-utils .
```

Run bash in image:
```sh
docker run --rm -ti -v /data:/data opensnowmap-utils
```

# Contours

The contours MBTiles file is generated using the script `generate_mbtiles.sh`.

The input to this script are the extracted `*.shp.gz` files. Each file is unzipped and converted to `geojson`. Afterwards `mbtiles` files are generated for various zoom levels. Finally the `mbtiles` file are merged to a single file (per shape file).

After running this script you have many individual `mbtiles` files which have to be merged to a single `mbtiles` file using `tile-join`.

