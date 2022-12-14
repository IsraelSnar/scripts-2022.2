set -x
wget http://joao.marcelo.nom.br/disciplinas/20212/scripts/atividades/arquivos/auth.log
awk -f questao01_1.awk auth.log 
read
awk -f questao01_2.awk auth.log 
read
awk -f questao01_3.awk auth.log 
read
awk -f questao01_4.awk auth.log 
read

echo "108.138.85.9" > ips.txt
echo "8.8.8.8">> ips.txt
echo "200.129.39.9" >> ips.txt
awk -f ips_latencia.awk ips.txt
read
