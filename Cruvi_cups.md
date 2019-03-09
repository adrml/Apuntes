# Apuntes Examen Sistemas UF2

##  Servidores de impresión


###LPD

**LPD, sistema de impresión Berkeley

Gestor tradicional de UNIX de la plataforma UNIX BSD, controlado por el demonio de impresoras de linea(Line printer daemon). 

Utiliza el protocolo **LPD/LPR** donde los clientes se comunican con el demonio mediante el dispositivo /dev/printer y utilizando el archivo de configuración /etc/printcap que determina el directorip de la cola de trabajos de impresión.


###LPRng



### CUPS


**CUPS**(common Unix Printing System)
...
Es el sistema de impresión mas comun en UNIX que utiliza el protocolo **IPP**(Internet Printing protocol) y integra **PostScript** que es uno de los lenguages de definición de paginas estandards.
...


Archivos de de configuración

- Configuración del servidor: **/etc/cups/cupsd.conf**

- Definición de impresoras: **/etc/cups/printers.conf**

- Archivo **PPD**(PostScript printer description): **/etc/cups/ppd**, contiene las opciones de configuración de la impresora (medida y orientación del papel, resolución, escala..)

- Clases de impresoras: **/etc/cups/classes.conf**, contiene la lista de las clases de impresoras definidas localmente.

- Tipos MIME: **/etc/cups/mime.types**( o /etc/share/cups/mime/mime.types), indica el tipo de archivos MIME admitidos.

- Reglas de conversión: **/etc/cups/mime.convs(o /usr/share/cups/mime/mime.convs) define cual o que filtros estan disponibles para convertir archivos de un formato a otro.



### Comandos para la gestióm de la impressora

- Listar dispositivos
...
# lpinfo -v
...

- Listar contraladores

...
#lpinfo -m
...

- Establecer impresora predeterminada

...
$ lpoptions -d <printer>
...

- Comprobar el estado
...
$ lpstat -s
$ lpstat -p <printer>
...

- Habilitar&Deshabilitar impresora

...
cupsenable nombre-impresora
cupsdisable nombre-impresora
...


### Comandos basicos de configuración

- Cambiar tamaño margenes

...
lpoptions -o page-top=
lpoptions -o page-bottom=
lpoptions -o page-right=
lpoptions -o page-left=
...

-Cambiar formato pagina

...
lpoptions -o PageSize= A*

