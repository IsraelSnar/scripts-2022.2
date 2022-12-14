#!/bin/bash
# Nota: 0,5

maior=$1

if [[ "$maior" =~ [0-9] ]]; then &> /dev/null;
	if [ $2 -gt $maior ]; then
		maior=$2

	fi

	#if [[ "$maior" =~ [0-9] ]]; then &> /dev/null;
	#echo "sim" > /dev/null;
	#else
	#maior=$2
	#fi
else
	echo "'$maior' não é número"
	maior=$2
fi

if [[ "$maior" =~ [0-9] ]]; then &> /dev/null;
        if [ $3 -gt $maior ]; then
                maior=$3
        fi
else
        echo "'$maior' não é número"
	maior=$3
fi

echo "O maior de todos é: $maior"
