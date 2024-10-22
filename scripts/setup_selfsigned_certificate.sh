#!/bin/bash

source .env # Importamos variables de entorno

set -ex #-e rompe la ejecucion al haber un error y la x paso a paso
apt update
apt upgrade -y # La respuesta yes
