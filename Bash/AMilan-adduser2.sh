#!/bin/bash

file="users.txt"
while read -r line;
do 
	password=$(cat /dev/random)
	user=$(echo "${line}" |cut -d ";" -f1)
	password=$(echo "${line}" |cut -d ";" -f1)
	useradd ${user} -m 
	printf "${password}\n${password}" | passwd ${user}
done < users.txt
