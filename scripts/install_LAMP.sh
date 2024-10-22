#!/bin/bash

set -ex #-e rompe la ejecucion al haber un error y la x paso a paso
apt update
apt upgrade -y # La respuesta yes

#Instalamos el servidor web Apache
# apt install apache2 -y

# Copiamos nuestro archivo de configuracion de VirtualHost
cp ../conf/000-default.conf /etc/apache2/sites-available

a2enmod rewrite # Habilita modulo rewrite

sudo apt install php libapache2-mod-php php-mysql -y # Instalamos paquetes necesarios para usar php

systemctl restart apache2

# Copiar el archivo /php/index.php a /var/www/html/
#cp ../php/index.php /var/www/html/

# Modificamos el propietario de /var/www/html a www-data que es Apache
chown -R  www-data:www-data /var/www/html

# Instalamos mysql-server
apt install mysql-server -y