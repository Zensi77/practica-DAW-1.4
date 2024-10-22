#!/bin/bash

source .env # Importamos variables de entorno

set -ex #-e rompe la ejecucion al haber un error y la x paso a paso
# apt update
# apt upgrade -y # La respuesta yes

# Seleccionar el servidor web que queremos configurar para ejecutar.
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" |  debconf-set-selections

# Confirmar que desea utilizar dbconfig-common para configurar la base de datos.
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections

# Seleccionar la contraseña para phpMyAdmin.
echo "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections

# AL configurar ya la respuesta del proceso de ejecucion de phpMyAdmin, ya lo podemos instalar 
sudo apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y

# Creamos un directorio para Adminer
mkdir -p /var/www/adminer

#Descargamos el adminer
wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php -P /var/www/html/adminer


# Cambio el nombre del archivo adminer.php para que sea mas accesible, poner adminer en la url y ya sale
mv  /var/www/html/adminer/adminer-4.8.1-mysql.php /var/www/html/adminer/index.php

# Creamos la base de datos
mysql -u root <<< "DROP DATABASE IF EXISTS $DB_NAME"
mysql -u root <<< "CREATE DATABASE $DB_NAME"

# Vamos a crear un usuario para la db y no usar root
mysql -u root <<< "DROP USER IF EXISTS '$DB_USER'@'%'"
mysql -u root <<< "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%'"

# Instalo GoAcces para procesar los archivos de logs y generarme una web con informacion de los logs 
apt install goaccess -y

mkdir -p /var/www/html/stats # Almacenar aqui las estadisticas

# El siguiente comando parsea el archivo de log access.log y genera un archivo HTML en tiempo real.
goaccess /var/log/apache2/access.log -o /var/www/html/stats/index.html --log-format=COMBINED --real-time-html --daemonize

# Copiamos el nuevo archivo de configuracion
cp ../conf/000-default-stats.conf /etc/apache2/sites-available

# Deshabilitamos el virtualhost 000-default.conf
a2dissite 000-default.conf

# Habilito el nuevo
a2ensite 000-default-stats.conf

# Reiniciamos apache
systemctl reload apache2

# Creamos el archivo .htpasswd
htpasswd -bc /etc/apache2/.htpasswd $STATS_USERNAME $STATS_PASSWORD

