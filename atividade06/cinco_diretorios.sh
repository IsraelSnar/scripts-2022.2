#!/bin/bash
# Nota: 1,5

[ -d cinco ] || mkdir cinco

for i in $(seq 1 5)
do

	[ -d cinco/dir$i ] || mkdir cinco/dir$i

	for j in $(seq 1 4)
	do
		touch cinco/dir$i/arq$j.txt
		for k in $(seq 1 $j)
		do
			echo $j >> cinco/dir$i/arq$j.txt
		done
	done

done
