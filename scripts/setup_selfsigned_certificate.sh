#!/bin/bash

set -ex #-e rompe la ejecucion al haber un error y la x paso a paso

source .env # Importamos variables de entorno

apt update
apt upgrade -y # La respuesta yes

# Creamos el certificado autofirmado
openssl req \
  -x509 \
  -nodes \
  -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/apache-selfsigned.key \
  -out /etc/ssl/certs/apache-selfsigned.crt \
  -subj "/C=$OPENSSL_COUNTRY/ST=$OPENSSL_PROVINCE/L=$OPENSSL_LOCALITY/O=$OPENSSL_ORGANIZATION/OU=$OPENSSL_ORGUNIT/CN=$OPENSSL_COMMON_NAME/emailAddress=$OPENSSL_EMAIL"

# Copiamos el archivo de configuracion de apache con SSL/TSL
cp ../conf/default-ssl.conf /etc/apache2/sites-available

# Lo habilitamos
a2ensite default-ssl.conf

# Hablimitamos el modulo SSL/TSL
a2enmod ssl

# Cambio la configuracion de apache para que todo el trafico sea redirigido a https
cp ../conf/000-default.conf /etc/apache2/sites-available
a2ensite 000-default.conf

# Habilitamos el modulo rewrite
a2enmod rewrite

# Reiniciamos apache
systemctl restart apache2