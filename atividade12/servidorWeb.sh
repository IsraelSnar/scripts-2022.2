#!/bin/bash

if [[ $# < 1 ]]; then
echo "informe nome da chave como parametro"
exit 0
fi

echo "Criando máquina"

sG=''
# id da vpc
vpcId=$(aws ec2 describe-vpcs --query "Vpcs[].VpcId" --output text)

# criar grupo de seguranca
sG=$(aws ec2 create-security-group --group-name servidorWeb --description "ServidorWeb" --vpc-id $vpcId --output text) > /dev/null
err=$?

if [[ $err != 0 ]]; then
	#gpName="servidorWeb"$str
	echo "o grupo de seguranca 'servidorWeb' ja existia, criando um novo"
	sG=$(aws ec2 create-security-group --group-name servidorWeb$RANDOM --description "ServidorWeb" --vpc-id $vpcId --output text) > /dev/null
fi

# adicionando novas regras
aws ec2 authorize-security-group-ingress --group-id $sG --protocol tcp --port 22 --cidr 0.0.0.0/0 > /dev/null && echo "Regra SSH OK"
aws ec2 authorize-security-group-ingress --group-id $sG --protocol tcp --port 80 --cidr 0.0.0.0/0 > /dev/null && echo "Regra HTTP OK"

# sub-rede 
idSubNet=$(shuf -i 0-5 -n 1)
subNet=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=${vpcId}" --query "Subnets[$idSubNet].SubnetId" --output text)

# criar maquina 
#aws ec2 run-instances --image-id ami-08c40ec9ead489470 --instance-type t2.micro --key-name $1 --subnet-id $subNet --security-group-ids $sG --user-data file://install.sh > /dev/null

# aws ec2 describe-instances --query "Reservations[].Instances[].InstanceId" |tail -n 2 | head -n1 | tr -d '"'

idIns=$(aws ec2 run-instances --image-id ami-08c40ec9ead489470 --instance-type t2.micro --key-name $1 --subnet-id $subNet --security-group-ids $sG --user-data file://install.sh --query "Instances[].InstanceId" --output text)

# pegar IP publico da ultima instancia criada
#aws ec2 describe-instances --query "Reservations[1].Instances[].PublicIpAddress" --output text
ipPb=$(aws ec2 describe-instances --query "Reservations[].Instances[].PublicIpAddress" --instance-id $idIns --output text)

echo "Configurando maquina, isso levará um pouco de tempo, aguarde\!\!\!"

./carregando.sh

echo "Acesse http://${ipPb}"



