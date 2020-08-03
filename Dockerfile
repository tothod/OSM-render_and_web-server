FROM ubuntu:20.04

# Enviroment variables
ENV TZ=Europe/Stockholm

# Install dependencis
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
  && apt-get update \
  && apt-get install -y -q autoconf \
  && apt-get install -y -q libtool \
  && apt-get install -y -q libxml2-dev \
  && apt-get install -y -q libbz2-dev \
  && apt-get install -y -q libgeos-dev \
  && apt-get install -y -q libgeos++-dev \
  && apt-get install -y -q libproj-dev \
  && apt-get install -y -q libmapnik-dev \
  && apt-get install -y -q python3-mapnik \
  && apt-get install -y -q apache2 \
  && apt-get install -y -q apache2-dev \
  && apt-get install -y -q python3-psycopg2 \
  && apt-get install -y -q curl \
  && apt-get install -y -q git \
  && apt-get install -y -q unzip \
  && apt-get install -y -q gdal-bin \
  && apt-get install -y -q mapnik-utils \
  && apt-get install -y -q node-carto \
  && apt-get install -y -q node-millstone \
  && apt-get install -y -q apache2-dev \
  && apt-get install -y -q wget \
  && apt-get install -y -q runit \
  && apt-get install -y -q sudo \
  && git clone -b switch2osm git://github.com/SomeoneElseOSM/mod_tile.git

# Install mod tile 
WORKDIR /mod_tile
RUN ./autogen.sh \
  && ./configure \
  && make \
  && make install \
  && make install-mod_tile \
  && ldconfig

# Add stylesheet
WORKDIR /
RUN mkdir -p /stylesheets
COPY ./stylesheets /stylesheets

# Add renderd config
COPY ./renderd/renderd.conf /usr/local/etc/renderd.conf

# Create needed directories
RUN mkdir -p /var/lib/mod_tile
RUN mkdir -p /etc/service/renderd
RUN mkdir -p /var/run/renderd

# Configure apache webserver
COPY ./apache2/mod_tile.conf /etc/apache2/conf-available/mod_tile.conf
COPY ./apache2/000-default.conf /etc/apache2/sites-enabled/000-default.conf
RUN a2enconf mod_tile

# Add webpage
COPY ./html/index.html /var/www/html/index.html

# Add directory with default files
RUN mkdir -p /defaultfiles/html \
	&& mkdir -p /defaultfiles/stylesheets \
	&& mkdir -p /defaultfiles/etc
COPY ./html/index.html /defaultfiles/html/index.html
COPY ./renderd/renderd.conf /defaultfiles/etc/renderd.conf
COPY ./stylesheets /defaultfiles/stylesheets


# Copy run script
COPY ./run.sh /run.sh  

# Create Volumes
VOLUME /var/www/html
VOLUME /stylesheets
VOLUME /var/lib/mod_tile
VOLUME /usr/local/etc

# Expose webport
EXPOSE 80

# Run command
CMD ["/bin/bash", "run.sh"]
