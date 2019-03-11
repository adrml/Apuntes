# Apuntes Examen Sistemas UF2

# Indice 
1. [SSH](#SSH)
2. [Telnet](#TELNET)
3. [RDP](#RDP)
4. [Servidores de impresion](#ServidoresImpresion)

 4.1. [LPD](#LPD)

4.2. [CUPS](#CUPS)

4.2.1. [Comandos](#Comandos)

5. [LDAP](#LDAP)

5.1. [Config servidor](#ConfigServidor)

6. [SAMBA 4](#SAMBA4)

6.1. [Errores](#Errores)


7. [SAMBARecursos](#SAMBA)

7.1 [AccederARecursos](#AccederARecursos)

## SSH <a name="SSH"></a>

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
##  ServidoresImpresion <a name="ServidoresImpresion"></a>

### LPD 

_**sistema de impresión Berkeley**
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
## Comandos<a name="Comandos"></a>

- Imprimir

```
$ lp archivo
```

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
$ lpoptions -d <printer>
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

### ConfigServidor   <a name="ConfigServidor"></a>

1. Instalamos el servicio SLAPD en el servidor, junto con las utilidades ldap
```
	sudo apt install slapd ldap-utils
	dpkg-reconfigure slapd
```
2. Configuramos usuarios y grupos
	
- Creamos un grupo y un usuario de prueba mediante un archivo .ldif
	
```
dn: ou=usuarios,dc=asix,dc=local
objectClass: organizationalUnit
ou: usuarios

dn: ou=grupos,dc=asix,dc=local
objectClass: organizationalUnit
ou: grupos

dn: cn=clase,ou=grupos,dc=asix,dc=local
objectClass: posixGroup
cn: clase
gidNumber: 5000

dn: uid=hector,ou=usuarios,dc=asix,dc=local
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: hector
sn: martinez
givenName: hector
cn: hector martinez
displayName: hector martinez
uidNumber: 10000
gidNumber: 5000
userPassword: hector
gecos: hector martinez
loginShell: /bin/bash
homeDirectory: /home/hector
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

Documentacion ubuntu:
***https://help.ubuntu.com/lts/serverguide/openldap-server.html.en***

conf cliente:
***https://www.tecmint.com/configure-ldap-client-to-connect-external-authentication/***

**DN:** Cada entrada tiene un atributo especial llamado distinguished
name o nombre distinguido (DN), que lo identifica unívocamente en la base de
datos del directorio. Por tanto, puede decirse que el DN se utiliza para referirse a
una entrada sin ambigüedades. Es el identificador único de un atributo.

### SAMBA4 <a name="SAMBA4"></a>

En este post explicaré como utilizar samba como AD (active directory) y DC (domain controller).

A partir de la versión 4.0 de samba, este, permite usar el servicio de samba como AD DC. Esto se utiliza para conectar clientes Windows a un servidor Linux con samba4.

Podemos realizar las siguientes acciones: Crear, borrar o deshabilitar usuarios y grupos del dominio, podemos crear nuevas unidades organizativas, podemos crear, editar y administrar políticas de dominio o podemos administrar el servicio DNS del dominio samba4.

 

En mi caso voy a hacer las pruebas con un Ubuntu 18.04 (bionic) y con un windows 10 como cliente.

Lo primero que tenemos que configurar en nuestra maquina es el FQDS, en mi caso es ” server.estamosrodeados.local “.

Tenemos que instalar el servicio de samba, winbind y kerberos.

```
    sudo apt -y install samba smbclient winbind krb5-config
```

Al instalar estos servicios nos deberá saltar una ventana con las configuraciones de kerberos. Al poner el FQDN en nuestro equipo, todos o la mayoría de campos deberían estar pre rellenados. Pongo un ejemplo de los siguientes:

![Kerberos1](https://estamosrodeados.com/wp-content/uploads/2019/02/kerberos1.png)
![Kerberos2](https://estamosrodeados.com/wp-content/uploads/2019/02/kerberos2.png)
![Kerberos3](https://estamosrodeados.com/wp-content/uploads/2019/02/kerberos3.png)

En el siguiente paso tendremos que configurar samba, para esto tenemos que crear un nuevo fichero de configuración de este servicio. Por si acaso nos equivocamos y queremos volver atrás es recomendable guardar el antiguo fichero de configuración.

```
    sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.copy
```

Para crear el nuevo fichero de configuración de samba debemos ejecutar el siguiente comando e introducir los campos demandados.

```
    cd /etc/samba
    sudo samba-tool domain provision
```

    La mayoría de elementos vienen ya pre escogidos, pero para que se vea claro, volveré a escribirlo todo.
    (Las letras en azul son las que he añadido yo)
    Realm [ESTAMOSRODEADOS.LOCAL]: ESTAMOSRODEADOS.LOCAL
    Domain [ESTAMOSRODEADOS]: ESTAMOSRODEADOS
    Server Role (dc, member, standalone) [dc]: dc
    DNS backend (SAMBA_INTERNAL, BIND9_FLATFILE, BIND9_DLZ, NONE) [SAMBA_INTERNAL]: SAMBA_INTERNAL
    DNS forwarder IP address (write ‘none’ to disable forwarding) [10.0.2.3]:127.0.0.53
```
    A Kerberos configuration suitable for Samba 4 has been generated at /var/lib/samba/private/krb5.conf
    Once the above files are installed, your Samba4 server will be ready to use
    Server Role: active directory domain controller
    Hostname: server
    NetBIOS Domain: ESTAMOSRODEADOS
    DNS Domain: estamosrodeados.local
    DOMAIN SID: S-1-5-21-2691178573-1269443594-560944578
```    
 

Ahora tenemos que mover el fichero que nos acaba de crear el comando anterior al directorio ” **/etc** “.

```
    sudo mv /var/lib/samba/private/krb5.conf /etc
```

Tenemos que ejecutar los siguientes comandos:

```
    systemctl stop smbd winbind systemd-resolved

    systemctl disable smbd nmbd winbind systemd-resolved
```

Una vez hecho esto, tenemos que ejecutar lo siguiente:

```
    systemctl start samba-ad-dc

    systemctl enable samba-ad-dc
```

Si al ejecutar el comando anterior nos da el siguiente error puedes ir al final de este post donde documento como solucionarlo.

    > root@server:/etc/samba# systemctl start samba-ad-dc

    > Failed to start samba-ad-dc.service: Unit samba-ad-dc.service is masked.

Con esto ya tenemos el controlador de dominio creado y configurado.
Ahora vamos a crear un nuevo usuario del dominio. En mi caso, este usuario se llama ” pollo “.

```
    samba-tool user create pollo
```

Para listar los usuarios creados en nuestro dominio hay que ejecutar el siguiente comando:

``` 
   samba-tool user list
```

 

## Conectar el cliente Windows al AD DC

Para poder conectarnos a nuestro servidor, tenemos que estar en la misma red, es importante poner como DNS la ip del servidor.  ej:

```
IP servidor: 192.168.57.100

IP cliente: 192.168.57.101
```

![IPS](https://estamosrodeados.com/wp-content/uploads/2019/02/Cliente-windows-ad-dc.png)

Una vez configurada la red tenemos que seguir los siguientes pasos:

>  Equipo > Propiedades > Cambiar configuración > Cambiar 

Nos aparecerá la ventana en la que tenemos que introducir el dominio al que queremos unirnos.

![dominio](https://estamosrodeados.com/wp-content/uploads/2019/02/cliente-dominio-ad-dc-249x300.png)

Tenemos que introducir la contraseña que hemos configurado antes.

![dominio2](https://estamosrodeados.com/wp-content/uploads/2019/02/dominio-windows-ad-dc3-300x116.png)

Para comprobar que todo funciona correctamente deberíamos acceder al usuario creado anteriormente, en mi caso ” pollo “.

 

### Errores

Para resolver el error al reiniciar el proceso **samba-ad-dc** hay que ejecutar los siguientes comandos.

>    root@server:/etc/samba# systemctl start samba-ad-dc

>    Failed to start samba-ad-dc.service: Unit samba-ad-dc.service is masked


```
    sudo systemctl unmask samba-ad-dc

    sudo systemctl enable samba-ad-dc

    sudo systemctl restart samba-ad-dc
```
***https://estamosrodeados.com/linux/samba4-como-ad-dc/***

## Conectar el cliente Ubuntu al AD DC

Primero instalamos los siguientes servicios.

```
	apt -y install winbind libpam-winbind libnss-winbind krb5-config resolvconf
```


## SAMBA

Samba es una implementación libre del protocolo **SMB** *Server Message Protocol* , utiliza el puerto 445 (TCP y UDP)

La configuración de Samba se logra editando un solo archivo ubicado en ``/etc/samba/smb.conf``, un ejemplo de una configuración básica:
```
	#============== Global Settings ===================#
	[global]
	 workgroup = PRUEBAGROUP
	 server string = Samba %v
	 wins support = no
	 load printers = no

	#======= Seguridad =======#
	 security = user
	 map to guest = bad user
	 guest ok = yes
	 public = yes
	 hosts allow = 127.0.0.1 192.168.22.0/24
	 hosts deny = 0.0.0.0/0

	#============== Share Definitions ==================#
	[Musica]
	 comment = Música prueba.
	 path = /home/Datos/Musica/
	 available = yes
	 browsable = yes
	 writable = no

	[Videos]
	 copy = Musica
	 comment = Videos prueba.
	 path = /home/Datos/Videos/

	[Box]
	 copy = Musica
	 comment = Otros datos.
	 path = /home/Datos/Box/
	 writable = yes
```
### AccederARecursos <a name="AccederARecursos"></a>

Tanto desde Windows como desde Linux se puede acceder de forma muy sencilla.

**Accedo desde Windows a Linux**

Desde Windows podemos acceder a los recursos compartidos en la máquina Linux simplemente utilizando el Entorno de Red y navegando por los recursos que encontremos.

**Acceso desde Linux a Windows**

Para acceder a los recursos compartidos por Windows, si usamos Konqueror o Nautils, es tan simple como escribir en al barra de direcciones:
```
    smb://nombre_maquina_windows
```

De todos modos, disponemos también de **herramientas gráficas** que van muy bien y hacen esta tarea tan sencilla como navegar por directorios. Algunas de ellas son:

> komba

> smb4k

> xfsamba

También podemos utilizar la **línea de comandos** de la siguiente manera

```smbclient -L <host>``` Nos muestra los recursos compartidos en el equipo. Podemos especificar el usuario (la contraseña la preguntará) con ```smbclient -L <host> -U <usuario>```

```smbmount //host/nombredelrecurso /mnt/samba``` &rarr; Nos montara el recurso compartido llamado nombredelrecurso en el directorio /mnt/samba. 
Antes de hacer esto, el directorio /mnt/samba debe existir.

Una vez montado podremos navegar por **/mnt/samba** como si fuera el directorio compartido de windows. 
Para especificar el nombre de usuario usaremos &rarr; ```smbmount //host/nombredelrecurso /mnt/samba -o username=<usuario>```

```smbumount /mnt/samba``` Desmontara el recurso compartido que habíamos montado en /mnt/samba. Hay que hacerlo antes de apagar el ordenador windows, ya que si no saldrán mensajes de error.

```nmblookup <host>``` Nos devuelve la Ip del <host> presente en la red.

```nbtscan <red/mascara>``` Nos escaneara la red en busca de equipos que comparten recursos.

 Por ejemplo: ```nbtscan 192.168.0.0/24``` nos escanearía la red en busca de equipos.

```smbstatus``` Nos permite ver quien está conectado al servidor Samba.

