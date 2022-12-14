#!/bin/python3
# Correção: 0,0

import sys
opFile=sys.argv[1]
arquivo = open(opFile, 'r')

aTx=''
for l in arquivo:
	aTx=aTx+l

aTx = aTx.replace(".", "")
aTx = aTx.replace(",", "")
aTx = aTx.replace("\n", " ")
dTx = aTx.split(" ")

fTx = [] # onde fica as palavra
cTx = [] # onde fica a quantidade de vez

for i in dTx:
	if (i not in fTx): # se não tiver a palavra ainda
		fTx.append(i)
		cTx.append(1)
	else: # se tiver a palavra soma + 1
		cTx[fTx.index(i)] = cTx[fTx.index(i)] + 1

cTx.pop() # Apaga ultimo valor do array, sendo que ele é nulo
fTx.pop() # Apaga o ultimo valor do array

for w in fTx:
	print(f"{w}:{cTx[fTx.index(w)]}")

