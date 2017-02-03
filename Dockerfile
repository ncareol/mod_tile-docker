#
# ABOUT
#
# ncareol/mod_tile: Docker image for running Apache w/ mod_tile, for serving static,
# pregenerated OSM tiles
#

FROM debian:jessie
MAINTAINER Erik Johnson <ej@ucar.edu>

RUN apt-get update \
    && apt-get install -y git autoconf libtool \
        libxml2-dev libbz2-dev libssl-dev libpq-dev libgdal1-dev g++ \
        libmapnik-dev mapnik-utils python-mapnik

#
# apache
#

RUN apt-get install -y apache2 apache2-dev

ENV APACHE_RUN_USER     www-data
ENV APACHE_RUN_GROUP    www-data
ENV APACHE_LOG_DIR      /var/log/apache2
ENV APACHE_PID_FILE     /var/run/apache2.pid
ENV APACHE_RUN_DIR      /var/run/apache2
ENV APACHE_LOCK_DIR     /var/lock

#
# mod_tile
#

#
# Install
#
RUN cd /tmp && git clone git://github.com/openstreetmap/mod_tile.git && \
    cd /tmp/mod_tile && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    make install-mod_tile && \
    ldconfig && \
    cd /tmp && rm -rf /tmp/mod_tile

#
# Configure
#

RUN echo "LoadModule tile_module /usr/lib/apache2/modules/mod_tile.so" > /etc/apache2/mods-available/mod_tile.load

RUN ln -s /etc/apache2/mods-available/mod_tile.load /etc/apache2/mods-enabled/

COPY renderd.conf /etc

COPY mod_tile.conf /etc/apache2/sites-available/000-mod_tile.conf

RUN rm /etc/apache2/sites-enabled/000-default.conf \
    && ln -s /etc/apache2/sites-available/000-mod_tile.conf /etc/apache2/sites-enabled/

COPY index.html /var/www/html/index.html

EXPOSE 80

COPY apache2-foreground /usr/local/bin/

CMD ["apache2-foreground"]
