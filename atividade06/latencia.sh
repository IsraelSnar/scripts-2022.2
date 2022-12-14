#!/bin/bash
# Nota: 1,5
clear

file=$1

if [[ $@ -eq '0' ]]
then
echo "Adicione arquivo com a lista de IP's, 1 por linha"
exit 1
fi

#[ -f $file ] || echo "Adicione arquivo com 1 ip por linha" exit;

[ -f ipavg.txt ] && rm ipavg.txt

for ip in $(cat $file)
do

echo -e "\033[01;32mProcessando(\033[05;33m${ip}\033[0m) ...\033[01;32m\033[0m"

ping $ip -c 10 > prov.tmp

avg=$(tail -n 1 prov.tmp | cut -d'/' -f 5)

echo "$avg	$ip" >> ipavg.txt

done

#clear
cat ipavg.txt | sort -n

rm *.tmp
