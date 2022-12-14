#!/bin/bash
# Nota: 1,0

# Para ignorar letras maiusculas e minusculas usei o atributo -i
# Caso quisesse contar as linhas o atributo -n
# Para pesquisar algo diferente do informado utilizei atributo -v

grep -v -i sshd auth.log

grep -i "session opened for user j" auth.log

grep -i "session opened for user r" auth.log

grep -i -E "^[a-z]{3} 1[1-2] .{0,52}: session opened" auth.log
