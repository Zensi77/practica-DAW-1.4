[<img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGCSSlV43jGuvxhn5DFag0D_GlgdLk1HceUQ&s" align="right" width="25%" padding-right="350">]()

# `PRACTICA-DAW-1.4`

<p align="left">
		<em>Hecho con</em>
</p>
<p align="center">
	<img src="https://img.shields.io/badge/GNU%20Bash-4EAA25.svg?style=flat&logo=GNU-Bash&logoColor=white" alt="GNU%20Bash">
	<img src="https://img.shields.io/badge/.ENV-ECD53F.svg?style=flat&logo=dotenv&logoColor=black" alt=".ENV">
</p>

<br>

##### 🔗 Contenidos

- [📍 Introduccion](#-Introduccion)
- [📂 Estructura del repositorio](#-)
- [🧩 Modulos](#-modules)
- [🚀 Inicio](#Inicio)
    - [📦 Instalacion](#-instalacion)
    - [🤖 Uso](#uso)

---

## 📍 Introduccion
En este repositorio se encuentra la practica 1.2 de la asignatura de Despliegue de Aplicaciones Web. En ella se ha instalado un certificado autofirmado SSL en el servidor Apache.

---
## 📂 Estructura del repositorio

```sh
└── practica-DAW-1.2/
    ├── README.md
    ├── conf
    │   └── 000-default.conf
    │   └── default-ssl.conf
    └── scripts
        ├── .env.example
        ├── deploy.sh
        ├── install_LAMP.sh
        ├── install_tools.sh
        └── setup_selfsigned_cert.sh
```

---

## 🧩 Modulos

<details closed><summary>scripts</summary>

| Archivo | Resumen |
| --- | --- |
| [.env](https://github.com/Zensi77/practica-DAW-1.4/blob/main/scripts/.env) | <code>❯ Archivo de ejemplo de variables de entorno</code> |
| [install_tools.sh](https://github.com/Zensi77/practica-DAW-1.4/blob/main/scripts/install_tools.sh) | <code>❯ Instalacion herramientas auxiliares a la pila LAMP</code> |
| [install_LAMP.sh](https://github.com/Zensi77/practica-DAW-1.4/blob/main/scripts/install_LAMP.sh) | <code>❯ Instalacion pila LAMP</code> |
| [deploy.sh](https://github.com/Zensi77/practica-DAW-1.4/blob/main/scripts/deploy.sh) | <code>❯ Script de despliegue de la aplicacion php en Apache</code> |
| [setup_selfsigned_cert.sh](https://github.com/Zensi77/practica-DAW-1.4/blob/main/scripts/setup_selfsigned_cert.sh) | <code>❯ Script de creacion de certificado autofirmado SSL</code> |

</details>

<details closed><summary>conf</summary>

| File | Summary |
| --- | --- |
| [000-default.conf](https://github.com/Zensi77/practica-DAW-1.2/blob/main/conf/000-default.conf) | <code>❯ Archivo de configuracion de Apache usado</code> |
| [default-ssl.conf](https://github.com/Zensi77/practica-DAW-1.4/blob/main/scripts/default-ssl.conf) | <code>❯ Archivo de configuracion de Apache usado </code> |

</details>

---

## 🚀 Inicio

### 📦 Instalacion

Build the project from source:

1. Clona el repositorio:
```sh
❯ git clone https://github.com/Zensi77/practica-DAW-1.4
```

2. Navega al directorio del repositorio:
```sh
❯ cd practica-DAW-1.4
```

### 🤖 Uso
> [!IMPORTANT]
> Para el uso del scripts es necesario dar permisos de ejecucion a los mismos.
> ```sh
> ❯ chmod +x scripts/*.sh
> ```

1. Configurar las variables de entorno en el archivo `.env`.

Usted puede copiar el archivo de ejemplo `.env.example` y modificarlo a su gusto.

2. Si usted desea instalar la pila LAMP, ejecute el siguiente comando:
```sh
❯ sudo ./scripts/install_LAMP.sh
```
Este script instala Apache, MySQL y PHP en el servidor.

3. Si usted desea instalar las herramientas auxiliares a la pila LAMP, ejecute el siguiente comando:
```sh
❯ sudo ./scripts/install_tools.sh
```
Este script instala las herramientas phpmyadmin, adminer(phpmyadmin alternativo), goaccess(analizador de logs en tiempo real)

> [!NOTE]
> Para mas informacion de estos 2 scripts, vaya a [practica-DAW-1.1](https://github.com/Zensi77/practica-DAW-1.1/blob/main/README.md)

4. Para la instalacion del certificado autofirmado SSL, se va a usar openssl, ejecutando el siguiente comando:
```sh
openssl req \
  -x509 \
  -nodes \
  -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/apache-selfsigned.key \
  -out /etc/ssl/certs/apache-selfsigned.crt \
  -subj "/C=$OPENSSL_COUNTRY/ST=$OPENSSL_PROVINCE/L=$OPENSSL_LOCALITY/O=$OPENSSL_ORGANIZATION/OU=$OPENSSL_ORGUNIT/CN=$OPENSSL_COMMON_NAME/emailAddress=$OPENSSL_EMAIL"
```
Aqui se define la duracion del certificado en dias, el tamaño de la clave, la ruta de los archivos de la clave y el certificado, y la informacion del certificado(C=Country, ST=State, L=Locality, O=Organization, OU=Organizational Unit, CN=Common Name, emailAddress), estos valores se definen en el archivo `.env`.


5. Para configurar el certificado en Apache, se debe habilitar el modulo ssl y habilitar el archivo de configuracion default-ssl.conf, ejecutando el siguiente comando:
```sh
❯ cp ../conf/default-ssl.conf /etc/apache2/sites-available
❯ a2ensite default-ssl.conf
❯ a2enmod ssl
``` 
En este archivo se define la ruta de los archivos de la clave y el certificado, para que Apache pueda usarlos.

6. Añado el siguiente bloque de codigo al archivo de configuracion de Apache `000-default.conf`:
```sh
    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
```
El cual realiza una redireccion de http a https, para que la aplicacion redirija a https automaticamente todas las peticiones, para esto se debe habilitar el modulo rewrite de Apache para que pueda reescribir la ruta, ejecutando el siguiente comando:
```sh
❯ a2enmod rewrite
```

7. Reiniciar el servidor Apache, para que los cambios surtan efecto:
```sh
❯ systemctl restart apache2
```

8. Todos estos pasos se pueden realizar ejecutando el siguiente script:
```sh
❯ sudo ./scripts/setup_selfsigned_cert.sh
```

> ![IMPORTANT]
> Aunque la aplicacion se redirige a https, se debe tener en cuenta que el certificado es autofirmado, por lo que el navegador mostrara un mensaje de advertencia al intentar acceder a la aplicacion, mostrando que la conexion no es segura, para evitar esto se debe comprar un certificado SSL a una entidad certificadora.
