#!/bin/bash
echo " "
echo "====== Checking if directories are empty and copies files if needed======"
echo " " 
if [ "$(ls -A /stylesheets)" ]; then
     echo "Files exists in stylesheets no action taken."
else
    echo "Stylesheets is Empty copying default files"
	cp -r /defaultfiles/stylesheets/* /stylesheets
fi
if [ "$(ls -A /var/www/html)" ]; then
     echo "Files exists in webroot no action taken."
else
    echo "Webroot is Empty copying default files"
	cp -r /defaultfiles/html/index.html /var/www/html/index.html
fi
if [ "$(ls -A /usr/local/etc)" ]; then
     echo "Renderd config exists no action taken."
else
    echo "Renderd config is missing copying default file"
	cp /defaultfiles/etc/* /usr/local/etc
fi
echo " "
echo "================ Starting apache2 ======================"
echo " "
service apache2 start
echo " "
echo "================ Starting renderd ======================"
echo " "
renderd -f -c /usr/local/etc/renderd.conf  &
child=$!
wait "$child"
echo " "
echo "====== You should not see this something has gone wrong   =========="
echo " "