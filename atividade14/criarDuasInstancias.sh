#!/bin/bash

grSgNm="duasmaquinas"
ipMy=$(wget -qO- http://ipecho.net/plain)

if [[ $# < 3 ]]; then
echo "informe os parametros"
echo "nomedachave usuario senha"
exit 1
fi

echo "Criando máquina"

sG=''
# id da vpc
vpcId=$(aws ec2 describe-vpcs --query "Vpcs[].VpcId" --output text)

# criar grupo de seguranca
sG=$(aws ec2 create-security-group --group-name $grSgNm$RANDOM --description "Instancia" --vpc-id $vpcId --output text) > /dev/null

# adicionando novas regras
aws ec2 authorize-security-group-ingress --group-id $sG --protocol tcp --port 22 --cidr "$ipMy/32" > /dev/null && echo "Regra SSH OK"
aws ec2 authorize-security-group-ingress --group-id $sG --protocol tcp --port 80 --cidr 0.0.0.0/0 > /dev/null && echo "Regra HTTP OK"
aws ec2 authorize-security-group-ingress --group-id $sG --protocol tcp --port 3306 --source-group $sG > /dev/null && echo "Regra Mysql OK"

# sub-rede 
idSubNet=$(shuf -i 0-5 -n 1)
subNet=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=${vpcId}" --query "Subnets[$idSubNet].SubnetId" --output text)

# user data servidor
cat << EOF > ud_servidorud.sh
#!/bin/bash
sudo apt update -y
sudo apt install mysql-server -y
sudo systemctl start mysql
sudo systemctl enable mysql
sed -i 31,32d /etc/mysql/mysql.conf.d/mysqld.cnf
echo -e "bind-address		= 0.0.0.0\nmysqlx-bind-address	= 0.0.0.0" >> /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql
echo -e "sudo mysql<<EOF\nCREATE DATABASE scripts;\nCREATE USER '$2'@'%' IDENTIFIED BY '$3';\nGRANT ALL PRIVILEGES ON scripts.* TO '$2'@'%';\nUSE scripts;\nEOF\n#rm /home/ubuntu/scripts.sh" > /home/ubuntu/scripts.sh
chmod +x /home/ubuntu/scripts.sh
systemctl restart mysql
cd /home/ubuntu
./scripts.sh
EOF

# criar maquina - ID da instancia
idIns=$(aws ec2 run-instances --image-id ami-08c40ec9ead489470 --instance-type t2.micro --key-name $1 --subnet-id $subNet --security-group-ids $sG --user-data file://ud_servidorud.sh --query "Instances[].InstanceId" --output text)

# IP privado
ipPv=$(aws ec2 describe-instances --query "Reservations[].Instances[].PrivateIpAddress" --instance-id $idIns --output text)

while [[ $sts != "running" ]]; do
        sleep 2
        sts=$(aws ec2 describe-instances --instance-id $idIns --query "Reservations[].Instances[].State.Name" --output text)
done

echo "IP privado do servidor: "$ipPv
echo $ipPv > ippv.tmp

sleep 20

echo "Criando cliente"
# user data cliente
cat << EOF > clienteud.sh
#!/bin/bash
sudo apt update -y
sudo apt install mysql-client -y
sleep 30
echo -e "[client]\nuser="$2"\npassword="$3 > /root/.my.cnf
echo -e "sudo mysql -u $2 scripts -h $ipPv<<EOF\nUSE scripts;\nCREATE TABLE teste ( atividade INT );\nEOF\n#rm /home/ubuntu/scripts.sh" > /home/ubuntu/scripts.sh
chmod +x /home/ubuntu/scripts.sh
cd /home/ubuntu
./scripts.sh
EOF

# Criando a cliente
idInsDois=$(aws ec2 run-instances --image-id ami-08c40ec9ead489470 --instance-type t2.micro --key-name $1 --subnet-id $subNet --security-group-ids $sG --user-data file://clienteud.sh --query "Instances[].InstanceId" --output text)

# IP publico
ipPbCl=$(aws ec2 describe-instances --query "Reservations[].Instances[].PublicIpAddress" --instance-id $idInsDois --output text)

echo "IP do cliente "$ipPbCl
sleep 80
ssh -i ../scripts.pem ubuntu@$ipPbCl
