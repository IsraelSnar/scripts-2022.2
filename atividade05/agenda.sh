#!/bin/bash
# Nota: 1,5

comand=$1
sim=0
case ${comand} in
"adicionar")
	#echo "adicionar";;

	[ -f agenda.db ] || touch agenda.db;
	nome=$2
	mail=$3
	echo "$nome:$mail" >> agenda.db
#	if ![[$* == '-y' || $* == '-s' ]]; then
#		echo "criado"
#	else
#		echo "Deseja adicionar $nome:$mail a sua agenda?"
#		read -r b
#	fi;;
	#echo $conf;;
	echo "Criado com sucesso: '"$(tail -n 1 agenda.db)"'"
	sim=1;;
"remover")
	#echo "remover";;
	del=$2

	if [ $(cat agenda.db | cut -d':' -f 2 | grep -i "$del") ]
	then
		#echo "foi encontrado"
		nomDel=$(cat agenda.db | grep -i "$del" | cut -d':' -f 1)
		cat agenda.db | grep -i -v "$del" > agenda.tmp
		mv agenda.tmp agenda.db
		echo "$nomDel foi removido da agenda"
	else
		echo "não existe esse contato na sua lista de contatos"
	fi
	#if [ $? ]; then echo "deu certo"; fi
	sim=1;;
"listar")
	#echo "listar"
	[ -f agenda.db ] && cat agenda.db || echo "arquivo vazio";
	#cat agenda.db
	sim=1;;

esac

#echo $sim

if [ $sim == '0' ]
then
echo "comando não encontrado"
echo "os comandos são: 'adicionar' 'remover' 'listar'"
fi
