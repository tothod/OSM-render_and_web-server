# osm-render_and_web-server

A basic image for rendering/serving tiles using OpenStreetMap data from an external PostgreSQL/postgis database.

## Running

This document assumes that OpenStreetMap data has already been imported into a PostgreSQL/postgis db.

Command to start:
docker run -p 80:80 -v /runenv/html:/var/www/html -v /runenv/modtile:/var/lib/mod_tile -v /runenv/renderd:/usr/local/etc -v /runenv/stylesheets:/stylesheets tothod/osm-render_and_web-server

Once the container is up you should be able to see a map
once you point your browser to http://127.0.0.1
