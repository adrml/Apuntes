# Apuntes Examen Sistemas UF2

##  SSH

El servicio OpenSSH (**sshd**)  usa por defecto el puerto **22/TCP**.

Para realizar una conexión a un equipo mediante ssh se utiliza el comando:

```
    user@host:port o user@host -p port
```

La configuración del servicio sshd en linux se encuentra en el archivo de configuracion:

```    
/etc/ssh/sshd_config
```

Ejemplo de archivo de configuración: 

      Port 22 -> Puerto de escucha

      ListenAddress 192.168.1.1 -> IP de conexión

      HostKey /etc/ssh/ssh_host_key -> Claves privadas ssh 

      PermitRootLogin no -> No permitir que el usuario root se conecte 

      PasswordAuthentication yes -> Obligar autenticación por password

      PermitEmptyPasswords no ->  denegar login a usuarios sin password

      ServerKeyBits 1024 -> bits de clave RSA generadas al iniciar el servicio

      AllowUsers adr -> usuario/s (separados por comas) admitido para hacer login

      LoginGraceTime 600 -> tiempo que el usuario será valido sin haber iniciado en el sistema

      PrintMotd yes -> Enseñar el mensaje del dia

      Banner no/ "Filepath/filename.msg" -> Mostrar banner por pantalla al iniciar conexión

      MaxSessions 1 -> Numero maximo de sesiones aceptadas
___

##  TELNET

El servicio telnet (**telnetd**) usa por defecto el puerto **23/TCP**

Para realizar una conexión a un equipo mediante telnet se utiliza uno de los comandos:

```
telnet host.local/IP 
```

```
telnet -l user host:port
```
- **/etc/securetty** ====> Este archivo contiene el nombre de las terminales a las cuales tiene acceso el usuario root a través de telnet
- **/etc/motd** =========> Este archivo de texto contiene un mensaje que es impreso justo después del login de una sesión telnet
- **/etc/issue.net** ====> Este archivo de texto contiene un mensaje que es impreso justo antes del login de una sesión telnet. Puede contener:

| Abreviación	| Explicación                                                    | Comando equivalente	|
|---------------|----------------------------------------------------------------|----------------------|
|    **%t**     | Muestra la tty actual	                                         |                 	|
|    **%h**	| Muestra el FQDN del servidor o equipo al que te conectas       | hostname -f		|
|    **%D**   	| Muestra el dominio NIS del servidor o equipo al que te conectas| hostname -d		|
|    **%d**	| Muestra la hora y fecha actuales				 |			|
|    **%s**  	| Muestra el nombre del sistema operativo	                 | uname -s		|
|    **%m** 	| Muestra el tipo de hardware (arquitectura del procesador)	 | uname -i		|
|    **%r** 	| Muestra la versión del kernel	                                 | uname -r		|
|    **%v** 	| Muestra la versión del kernel	                                 | uname -v		|
|    **%%** 	| Muestra el carácter "%"                                        |			|

___

##  RDP

El Servicio RDP (**RemoteDesktopProtocol**) 
- Puerto por defecto ===> 3389/TCP
___
##  Servidores de impresión

**LPD**, sistema de impresión Berkeley

Gestor tradicional de UNIX de la plataforma UNIX BSD, controlado por el demonio de impresoras de linea(Line printer daemon).

Utiliza el protocolo **LPD/LPR** donde los clientes se comunican con el demonio mediante el dispositivo /dev/printer y utilizando el archivo de configuración /etc/printcap que determina el directorip de la cola de trabajos de impresión


##CUPS

**CUPS**(common Unix Printing System)

Es el sistema de impresión mas comun en UNIX que utiliza el protocolo **IPP**(Internet Printing protocol)
 y integra **PostScript** que es uno de los lenguages de definición de paginas estandards.

Archivos de de configuración

- El servidor de impresoras (**cups**) por defecto solo escucha en loopback 127.0.0.1 por el puerto **631** , para habilitar la esucha en otros canales se debe editar el archivo:

```
/etc/cups/cupsd.conf
```

- El panel de configuración web que brinda cups para hacer la mayoria de configuraciones es accesible mediante:

```
https://localhost|serverip:631/admin
```

- Las opciones de impresión de cada usuario se guardan en:

```
~/.cups/lpoptions
```

- Las generales o de cada usuario en:

```
/etc/cups/lpoptions
```

- Definición de impresoras: 

```
**/etc/cups/printers.conf**
```

- Archivo **PPD**(PostScript printer description): 
```
**/etc/cups/ppd**, contiene las opciones de configuración de la impresora (medida y orientación del papel, resolución, escala..)
```
- Clases de impresoras: 
```
**/etc/cups/classes.conf**, contiene la lista de las clases de impresoras definidas localmente.
```

- Tipos MIME: 
```
**/etc/cups/mime.types**( o /etc/share/cups/mime/mime.types), indica el tipo de archivos MIME admitidos.
```
- Reglas de conversión: 
```
**/etc/cups/mime.convs**(o /usr/share/cups/mime/mime.convs) define cual o que filtros estan disponibles para convertir archivos de un formato a otro.
```
## Comandos para la gestióm de la impressora

- Listar dispositivos

```
$ lpinfo -v
```
- Listar contraladores
```
$ lpinfo -m
```

- Establecer impresora predeterminada

```
$ poptions -d <printer>
```

- Comprobar el estado

```
$ lpstat -s
$ lpstat -p <printer>
```

- Habilitar&Deshabilitar impresora

```
- cupsenable nombre-impresora
- cupsdisable nombre-impresora
```


### Comandos basicos de configuración

- Cambiar tamaño margenes

```
-lpoptions -o page-top=
-lpoptions -o page-bottom=
-lpoptions -o page-right=
-lpoptions -o page-left=
```

-Cambiar formato pagina

```
lpoptions -o PageSize= A*
```

- Limpiar cola de Impresión

```
$ lprm #Elimina únicamente la última entrada
$ lprm - #Elimina todas las entradas
```

___

## LDAP

El protocolo LDAP usa por defecto el puerto **389/TCP**

El protocolo LDAPS (LDAP+(TLS or SSL)) usa por defecto el puerto **636/TCP**

1. Instalamos el servicio SLAPD en el servidor, junto con las utilidades ldap
```
	sudo apt install slapd ldap-utils	
```
2. Configuramos usuarios y grupos
	
	- Creamos un grupo y un usuario de prueba mediante un archivo .ldif
	
	- Configuramos la contraseña del usuario
	
	- Añadimos el usuario al grupo
	
3. Comandos de "SLAPD"

Comandos de modificación del dominio LDAP:

```
ldapsearch options|file
```

```
ldapmodify options|file
```

```
ldapadd options|file
```
  
Ejemplo de arbol de directorios para LDAP:

![Arbol de directorios](https://www.researchgate.net/profile/Ramon_Anglada_Martinez/publication/262512581/figure/fig1/AS:478136199585792@1491007961309/Figura-1-Ejemplo-de-Arbol-de-Directorio-LDAP-tomada-de-11-OpenLdap-es-una-de-las.png)






