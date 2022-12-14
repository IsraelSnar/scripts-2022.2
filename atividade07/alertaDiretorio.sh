#!/bin/bash
# Correção: 2,0

tempo=$1
dir="$2"

ls $dir > dirs.tmp
qtd=$(ls -la $dir | grep -e "^d" -e "^-" | wc -l)

echo "Processando e esperando..."

while [ '1' -eq '1' ]; do

sleep $tempo;

# Verificar se tem algo diferente
qtdN=$(ls -la $dir|grep -e "^d" -e "^-"|wc -l)
if [ $qtdN -eq $qtd ]
then
	echo "igual" > /dev/null
else
	#echo "diferente"

	# Identificar se foi deletado
	for i in $(cat dirs.tmp)
	do
		if [ -f "$dir/$i" ]; then
			echo "$i ta aqui" > /dev/null
		elif [ -d "$dir/$i" ]; then
			echo "$i ta ainda" > /dev/null
		else
			#echo "$i cade vc?"
			#echo "$i foi removido dessa pasta, possivelmente deletado, movido ou renomeado"
			echo "[$(date +'%d-%m-%Y')] ($qtd->$qtdN) deletado: $i" >> dirSensors.log
		fi
	done

	# Identificar se foi adicionado
	#echo "vendo se foi adicionado arquivo"

	for i in $(ls $dir)
	do
		if [[ $(grep "$i" dirs.tmp) ]] # &> /dev/null
		then
			echo "foi encontrado" > /dev/null
		else
			#echo "$i meu Deus cade tu"
			echo "[$(date +'%d-%m-%Y')] ($qtd->$qtdN) adicionado: $i" >> dirSensors.log
		fi
	done

	ls $dir > dirs.tmp
	qtd=$(ls -la $dir | grep -e "^d" -e "^-" | wc -l)

fi

done;
