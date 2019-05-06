#!/bin/bash

pass(){
	Rpassword=$(cat /dev/urandom |tr -dc '[A-Z][a-z][0-9]*=!+%_;:' |head -c 8)
}
pass
i=0
while [ $i -le 100 ];
do
	set $i++
	if [[ $Rpassword =~ [^a-zA-Z\d\s:] ]]; then
		echo $Rpassword
		pass
		continue
	else
		pass	
	fi
done

#file="$1"
#while read -r line;
#do 
#
	#user=$(echo "${line}" |cut -d ";" -f1)
	#password=$(echo "${line}" |cut -d ";" -f1)
	##useradd ${user} -m 
	#printf "${password}\n${password}" | passwd ${user}
#done < users.txt
#
