FROM ubuntu:22.04 as build

ENV TZ="Europe/Berlin"
RUN apt update \
 && apt install -y git g++ cmake libsqlite3-dev libexpat1-dev libcurl4-gnutls-dev zlib1g-dev libtiff5-dev libgeotiff-dev libpng-dev libjpeg8-dev libqhull-dev liblerc-dev libqb-dev libgeos-dev swig4.0 jq sqlite3

WORKDIR /usr/src

RUN git clone https://github.com/OSGeo/GDAL.git

RUN mkdir GDAL/build

WORKDIR /usr/src/GDAL/build

RUN cmake -DCMAKE_INSTALL_PREFIX=/usr ..
RUN cmake --build .
RUN cmake --build . --target install

WORKDIR /usr/src

RUN git clone https://github.com/mapbox/tippecanoe.git
WORKDIR /usr/src/tippecanoe
RUN make -j
RUN make install

WORKDIR /usr/src
RUN git clone https://github.com/mapbox/mbutil.git
WORKDIR /usr/src/mbutil
RUN apt install -y python3 python3-pip
RUN python3 setup.py install

COPY generate_mbtiles.sh /usr/local/bin

WORKDIR /data

CMD ["bash"]
