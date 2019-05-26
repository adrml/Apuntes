#!/bin/bash

#((++i))  -> incremento de variable +1 -> Chuletilla que no tiene nada que ver XD

sillyuser(){
	#comando help de toda la vida xP
echo "Este script  se encarga de crear usuarios apartir de un archivo.
Recibe como parametros un fichero con usuarios(nombre y apellidos en orden) delimitados por comas
y la longitud que debe tener el password de estos , los creará y enviará las credenciales al usuario root via mail

Uso:

nombrescript -f ficherousuarios.csv -l longituddelpassword

Ejemplos:

./adduser.sh -f Users.csv -l 8

./adduser.sh --file Users.csv --length 8"
exit
}

pass(){
	#Funcion encargada de generar un password con complejidad minima indicada por el parametro length	
	password=$(cat /dev/urandom |tr -dc '[A-Z][a-z][0-9]*=!+%_;:' |head -c $length )
}


checkfile()
{

	#Comrpueba si el parametro se ha pasado , si se ha pasado comprueba que el fichero exista y sea accesible

	if [[ -z $datafile ]]; then 
		echo "El parametro de fichero esta vacío o no se ha indicado"
	elif [[ ! -e $datafile ]]; then 
		echo "El fichero $datafile no existe o no es accesible"
		exit
	fi
}

checklength()
{

	#Comrpueba si el parametro se ha pasado , si se ha pasado comprueba que sea en formato numerico
	regnum='^[0-9]+$'
	if [[ -z $length ]]; then 
		echo "El parametro de longitud esta vacío o no se ha indicado"
		exit
	elif [[ ! $length =~ $regnum ]]; then 
		echo "El parametro de longitud no está en formato numerico"
		exit
	fi
}
genpass()
{
	found=0
	while [ $found -eq 0 ]		#Bucle encargado de iterar hasta encontrar un password que cumpla los requisitos de complejidad
	do 
		pass
		if [[ $password =~ [^a-zA-Z\d\s:] ]]; then
			found=1
		else
			pass
		fi
	done
}
checkuser()
{
	if id $username > /dev/null 2>&1 ; then
		return 0 
	else 
		return 1
	fi
}


while [ $# -ne 0 ]
do 
	case "$1" in 
		-h|--help)
			sillyuser;
			shift;
			;;
		-f|--file)
			datafile="$2";
			shift;
			;;
		-l|--length)
			length="$2";
			shift;
			;;
		*)
			echo -e "\n Parametro no valido \n"
			sillyuser;
			shift;
			;;
	esac
	shift
done

checkfile 	#llamado a la funcion encargada que comprobar si el fichero existe y es accesible
checklength	#llamado a la funcion encargada que comprobar si el parametro de longitud se ha pasado en y en formato correcto 

while read -r line;
do 
	username=$(echo "${line}" |cut -d "," -f1)	   #Extracción de la primera columna que contiene el nombre del usuario 
	surname=$(echo "${line}" |cut -d "," -f2)	   #Extracción de la segunda columna que contiene el apellido del usuario 
	ssurname=$(echo "${line}" |cut -d "," -f3)	   #Extracción de la segunda columna que contiene el apellido del usuario 
	if checkuser -eq 1; then 
		echo "El usuario $username no se creará porque ya existe"			#Comprueba que si el usuario ya existe
		continue
	fi
	useradd ${username} -m --comment "${username} ${surname} ${ssurname}" > /dev/null
	echo "Usuario $username creado"
	genpass 			#Llamado a la funcion que genera el password
	if [[ $? -eq 0 ]]; then 
		echo -e "El usuario $username se ha creado con password $password \n" >> creationusers.log
	else 
		echo -e "--El usuario $username NO se ha creado debido a un ERROR--" >> creationusers.log
	fi
	echo "Aplicando el password a $username :"
	printf "${password}\n${password}" | passwd ${username}
done < $datafile

#Envio del log por mail a la cuenta del administrador

	#echo "Reporte de creación de usuarios" | mailx -s 'Reporte de usuarios' -a ./creationusers.log admin@correofalso.local

