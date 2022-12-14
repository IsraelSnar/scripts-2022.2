#!/bin/bash
# Correção: 1,0

ip="vazio"
nome=
funcao=

post(){
	if [ $ip != "vazio" ]
	then
	   [ -f hosts.db ] || touch hosts.db;
	   if [[ $(grep "$nome" hosts.db) ]]; then
	      echo "informe outro nome, esse já existe"
	      exit 2
	   fi
	   echo $nome $ip >> hosts.db
	   echo "sucesso"
	else
	  echo "Informação incompleta informe '-i' e o IP para o completo cadastro"
	  exit 1;
	fi
}

buscar(){
	grep "$1" hosts.db | cut -d' ' -f 1
	
	if [ !$(grep "$1" hosts.db) 2> /dev/null ];then
		echo "nao encontrado nada da pesquisa"
	fi
}

delete(){
	grep -v $nome hosts.db > hosts2.db
	mv hosts2.db hosts.db
}

while getopts "d:i:a:r:l" OPTVAR;
do

	if [ $OPTVAR = "a" ]; then
	   funcao="a"
	   nome=$OPTARG
	elif [ $OPTVAR = "i" ];then
	   ip=$OPTARG
	elif [ $OPTVAR = "l" ];then
	   funcao="l"
	elif [ $OPTVAR = "r" ];then
	   funcao="r"
	   nome=$OPTARG
	elif [ $OPTVAR = "d" ];then
	   funcao="d"
	   nome=$OPTARG
	fi
done

case $funcao in
"a")
	post $nome $ip;
	;;
"d")
	delete;
	;;
"r")
	buscar $nome;
	;;
"l")
	cat hosts.db;
	;;
esac
