#!/bin/bash
# Correção: não utilizou o comando tee, visto em sala.
# Nota: 0,5

apr="Olá $(whoami)"

dat="Hoje é dia $(date +%d) do mês $(date +%m) do ano de $(date +%Y)"

echo "$apr $dat"
echo "$apr $dat" >> saudacao.log
