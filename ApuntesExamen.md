# Apuntes Examen Sistemas UF2

##  SSH

El servicio OpenSSH (**sshd**)  usa por defecto el puerto **22/TCP**.

Para realizar una conexión a un equipo mediante ssh se utiliza el comando:

```
    user@host:port o user@host -p port
```
Con el siguiente comando podemos ejecutar un programa en modo grafico desde ssh usando los recursos de la otra maquina. (redirection X11)

```
    $ ssh -X user@host
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
- **/etc/securetty** &rarr; Este archivo contiene el nombre de las terminales a las cuales tiene acceso el usuario root a través de telnet
- **/etc/motd** &rarr; Este archivo de texto contiene un mensaje que es impreso justo después del login de una sesión telnet
- **/etc/issue.net** &rarr; Este archivo de texto contiene un mensaje que es impreso justo antes del login de una sesión telnet. Puede contener:

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
- Puerto por defecto &rarr; 3389/TCP

RPD es un protocolo diseñado por Windows que permite acceder a un escritorio remoto desde un punto distante, incluso dentro de nuestra propia red, formando un entorno cliente-servidor.
Se puede acceder a este servicio desde cualquier Windows, Apple, Android, tableta o móvil.
___
##  Servidores de impresión

### LPD, sistema de impresión Berkeley

Gestor tradicional de UNIX de la plataforma UNIX BSD, controlado por el demonio de impresoras de linea(Line printer daemon).

Utiliza el protocolo **LPD/LPR** donde los clientes se comunican con el demonio mediante el dispositivo /dev/printer y utilizando el archivo de configuración **/etc/printcap** que determina el directorip de la cola de trabajos de impresión

### CUPS (Common Unix Printing System)

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
/etc/cups/printers.conf
```

- Archivo **PPD**(PostScript printer description): 
```
/etc/cups/ppd contiene las opciones de configuración de la impresora (medida y orientación del papel, resolución, escala..)
```
- Clases de impresoras: 
```
/etc/cups/classes.conf contiene la lista de las clases de impresoras definidas localmente.
```

- Tipos MIME: 
```
/etc/cups/mime.types o /etc/share/cups/mime/mime.types), indica el tipo de archivos MIME admitidos.
```
- Reglas de conversión: 
```
/etc/cups/mime.convs o /usr/share/cups/mime/mime.convs) define cual o que filtros estan disponibles para convertir archivos de un formato a otro.
```
## Comandos para la gestión de la impresora

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

El protocolo **LDAP** usa por defecto el puerto **389/TCP**

El protocolo **LDAPS** (LDAP+(TLS or SSL)) usa por defecto el puerto **636/TCP**

### Els models LDAP(En catalán!)
```
L’LDAP és un estàndard i no pas un maquinari o programari que es pot
comprar. El que s’instal·la en l’equip client o servidor és la
implementació d’aquest protocol; la qüestió de com emmagatzemar o
tractar les dades es deixa als proveïdors de l’aplicació de la norma
final.

 #### Implementacions del protocol LDAP

 Existeixen diverses implementacions del protocol LDAP realitzades per
 diferents companyies, entre d’altres:

-   ActiveDirectori -> és la implementació de Microsoft en els seus
    sistemes operatius Windows Server.

-   RedHatDirectoryServer o 389DirectoryServer -> una implementació
    realitzada per RedHat/Fedora.

-   ApacheDS -> un servei de directori que ofereix l’Apache
    Software Foundation.

-   OpenDS -> una implementació Java del protocol LDAP.

-   OpenLDAP -> una implementació lliure de l’estàndard.

Tot i la llibertat d’implementació, el sistema pot caracteritzar-se
segons algun dels quatre models següents:

1.  El model d’informació descriu l’estructura de la informació
    emmagatze-mada en el directori LDAP.

2.  El model de noms descriu com s’organitza i identifica la
    informació en el directori LDAP.

3.  El model funcional descriu quines operacions poden ser
    realitzades amb la informació emmagatzemada en el directori LDAP.

4.  El model de seguretat descriu com es pot protegir la informació
    continguda en el directori LDAP davant d’intents d’accés
    no autoritzats.
```

### Configuración en el servidor

1. Instalamos el servicio SLAPD en el servidor, junto con las utilidades ldap
```
	sudo apt install slapd ldap-utils	
```
2. Configuramos usuarios y grupos
	
- Creamos un grupo y un usuario de prueba mediante un archivo .ldif
	
```
		dn: ou=grupos,dc=banderas,dc=org
		objectClass: top
		objectClass: organizationalUnit
		ou: grupos
			
		dn: ou=usuarios,dc=banderas,dc=org
		objectClass: top
		objectClass: organizationalUnit
		ou: usuarios
			
		dn: cn=asix,ou=grupos,dc=banderas,dc=org
		objectClass: posixGroup
		cn: asix
		gidNumber: 5000
	
		dn: uid=sergi,ou=usuarios,dc=banderas,dc=org
		objectClass: posixAccount
		objectClass: shadowAccount
		objectClass: inetOrgPerson
		uid: sergi
		cn: sergi
		sn: banderas
		uidNumber: 5000
		gidNumber: 5000
		homeDirectory: /home/sergi
		loginShell: /bin/bash
		userPassword: Hola123
		mail: sergi@banderas.org	
```
```
sudo ldapadd -a -v -D cn=admin,dc=banderas,dc=org -H ldapi:/// -x -W -f main.ldif
```
- Configuramos la contraseña del usuario
```
ldappasswd -H ldapi:/// -D cn=admin,dc=banderas,dc=org -x -W -S "uid=sergi,ou=usuarios,dc=banderas,dc=org"
```
- Añadimos el usuario al grupo mediante archivo .ldif
```
		dn: cn=asix,ou=grupos,dc=banderas,dc=org
		changetype: modify
		add: memberUid
		memberUid: sergi
```
```
sudo ldapmodify -a -v -D cn=admin,dc=banderas,dc=org -H ldapi:/// -x -W -f addgroupmember.ldif
```
3. Comandos de "ldap-utils":
	
	- ldapadd
		- c **&rarr;** continua a pesar de producirse errores.
		- D dn **&rarr;** especifica el dn del administrador o usuario con privilegios para llevar a cabo la acción.
		- f ldif **&rarr;** especifica el archivo .ldif a usar.
		- H uri **&rarr;** especifica la uri del servidor LDAP. Si el servidor es localhost se usa "ldapi:///" como uri.
		- v **&rarr;** modo verbose. Si quieres mas detalles usa "-d -1" para el modo debug mostrándolo todo.
		- W **&rarr;** se usa para que nos pregunte el password del usuario al cual corresponde el dn de la opción "-D".
		- x **&rarr;** usar autenticación simple en vez de SASL.
		- Ejemplo **&rarr;** ldapadd -a -c -D cn=admin,dc=banderas,dc=org -H ldapi:/// -v -W -x -f main.ldif
	- ldapdelete
		- D dn **&rarr;** especifica el dn del administrador o usuario con privilegios para llevar a cabo la acción.
		- H uri **&rarr;** especifica la uri del servidor LDAP. Si el servidor es localhost se usa "ldapi:///" como uri.
		- v **&rarr;** modo verbose. Si quieres mas detalles usa "-d -1" para el modo debug mostrándolo todo.
		- W **&rarr;** se usa para que nos pregunte el password del usuario al cual corresponde el dn de la opción "-D".
		- Al final añadimos el dn a eliminar.
		- Ejemplo **&rarr;** ldapdelete -D cn=admin,dc=banderas,dc=org -H ldapi:/// -W "cn=asix,dc=banderas,dc=org"
	- ldapmodify
		- D dn **&rarr;** especifica el dn del administrador o usuario con privilegios para llevar a cabo la acción.
		- f ldif **&rarr;** especifica el archivo .ldif a usar.
		- H uri **&rarr;** especifica la uri del servidor LDAP. Si el servidor es localhost se usa "ldapi:///" como uri.
		- v **&rarr;** modo verbose. Si quieres mas detalles usa "-d -1" para el modo debug mostrándolo todo.
		- W **&rarr;** se usa para que nos pregunte el password del usuario al cual corresponde el dn de la opción "-D".
		- x **&rarr;** usar autenticación simple en vez de SASL.
		- Ejemplo **&rarr;** ldapmodify -D cn=admin,dc=banderas,dc=org -H ldapi:/// -v -W -x -f addgroupmember.ldif
	- ldappasswd
		- D dn **&rarr;** especifica el dn del administrador o usuario con privilegios para llevar a cabo la acción.
		- H uri **&rarr;** especifica la uri del servidor LDAP. Si el servidor es localhost se usa "ldapi:///" como uri.
		- S **&rarr;** se usa para que nos pregunte el nuevo password del usuario. 
		- v **&rarr;** modo verbose. Si quieres mas detalles usa "-d -1" para el modo debug mostrándolo todo.
		- W **&rarr;** se usa para que nos pregunte el password del usuario al cual corresponde el dn de la opción "-D"
		- x **&rarr;** usar autenticación simple en vez de SASL.
	- ldapsearch
		- b dn **&rarr;** dn a partir del cual se hará la búsqueda.
			Por ejemplo: buscar en todo el directorio (-b dc=banderas,dc=org)
		- D dn **&rarr;** especifica el dn del administrador o usuario con privilegios para llevar a cabo la acción.
		- H uri **&rarr;** especifica la uri del servidor LDAP. Si el servidor es localhost se usa "ldapi:///" como uri.
		- v **&rarr;** modo verbose. Si quieres mas detalles usa "-d -1" para el modo debug mostrándolo todo.
		- W **&rarr;** se usa para que nos pregunte el password del usuario al cual corresponde el dn de la opción "-D".
		- x **&rarr;** usar autenticación simple en vez de SASL.
		- Al final se añade el atributo a buscar y filtros si hacen falta.
		- Ejemplo **&rarr;** ldapsearch -b dc=banderas,dc=org -D cn=admin,dc=banderas,dc=org -H ldapi:/// -W -x 'uid=sergi' mail 
			Este ejemplo busca en todo el dominio el mail de los dn cuyo uid sea igual a "sergi".


Ejemplo de arbol de directorios para LDAP:

![Arbol de directorios](https://www.researchgate.net/profile/Ramon_Anglada_Martinez/publication/262512581/figure/fig1/AS:478136199585792@1491007961309/Figura-1-Ejemplo-de-Arbol-de-Directorio-LDAP-tomada-de-11-OpenLdap-es-una-de-las.png)






