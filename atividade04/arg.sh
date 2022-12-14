#!/bin/bash

#[ -f turma.txt ] && echo 'crie o arquivo "turma.txt"'; exit 0;

[ -d turmas ] || mkdir turmas;

sed -i 's/ A /INF/' turma.txt

sed -i 's/ B /LOG/' turma.txt

sed -i 's/ C /RED/' turma.txt

cat turma.txt | grep 'INF' > turmas/inf.txt

cat turma.txt | grep 'LOG' > turmas/log.txt

cat turma.txt | grep 'RED' > turmas/red.txt

for i in {2..8};
do

j=`cat turma.txt | head -n$i | tail -n 1 | tr  -s '[:blank:]' ' ' | sed -e 's/ /+/g' -e 's/[a-zA-Z]*//g' -e 's/++//g' -e 's/^/\(/' -e 's/$/\)\/3/' | bc`

#echo $j

if [ $j -le 6 ];
	then
	n=$(cat turma.txt | head -n $i | tail -n 1 | tr -s '[:blank:]' ' ' | sed -e 's/[0-9]*//g' -e 's/ $//')

	echo $n $j >> rec.tmp;
fi

done

grep -E '[0-9]$' rec.tmp > recuperacao.txt

rm *.tmp
