#!/bin/bash

grSgNm="wordpress"
ipMy=$(wget -qO- http://ipecho.net/plain)

if [[ $# < 3 ]]; then
echo "informe os parametros"
echo "nomedachave usuario senha"
exit 0
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
cat << EOF > ud_servidor.sh
#!/bin/bash
sudo apt update -y
sudo apt install mysql-server -y
sudo systemctl enable mysql
sudo systemctl start mysql
sed -i 31,32d /etc/mysql/mysql.conf.d/mysqld.cnf
echo -e "bind-address		= 0.0.0.0\nmysqlx-bind-address	= 0.0.0.0" >> /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql
echo -e "sudo mysql<<EOF\nCREATE DATABASE scripts;\nCREATE USER '"$2"'@'%' IDENTIFIED BY '"$3"';\nGRANT ALL PRIVILEGES ON scripts.* TO '"$2"'@'%';\nUSE scripts;\nEOF\nrm /home/ubuntu/scripts.sh" > /home/ubuntu/scripts.sh
chmod +x /home/ubuntu/scripts.sh
#sudo sed -i 21d /etc/mysql/mysql.conf.d/mysqld.cnf
#echo "port = 3306" >> /etc/mysql/mysql.conf.d/mysqld.cnf
/home/ubuntu/scripts.sh
EOF

sleep 1

# criar maquina - ID da instancia
idIns=$(aws ec2 run-instances --image-id ami-08c40ec9ead489470 --instance-type t2.micro --key-name $1 --subnet-id $subNet --security-group-ids $sG --user-data file://ud_servidor.sh --query "Instances[].InstanceId" --output text)

while [[ $sts != "running" ]]; do
        sleep 2
        sts=$(aws ec2 describe-instances --instance-id $idIns --query "Reservations[].Instances[].State.Name" --output text)
done

# IP privado
ipPv=$(aws ec2 describe-instances --query "Reservations[].Instances[].PrivateIpAddress" --instance-id $idIns --output text)

echo "IP privado do servidor: "$ipPv
echo $ipPv > ippv2.tmp

############ Servidor/Cliente HTTP ############

cat << EOF > ud_ss.sh
#!/bin/bash
sudo apt update -y
apt install php mysql-client -y
apt install php-mysql php-curl libapache2-mod-php php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y
systemctl start apache2
systemctl enable apache2
echo -e "[client]\nuser="$2"\npassword="$3 > /root/.my.cnf
cd /home/ubuntu
wget -c -P /home/ubuntu https://wordpress.org/latest.tar.gz
echo -e "<?php\ndefine( 'DB_NAME', 'scripts' );\ndefine( 'DB_USER', '$2' );\ndefine( 'DB_PASSWORD', '$3' );\ndefine( 'DB_HOST', '$ipPv' );\ndefine( 'DB_CHARSET', 'utf8' );\ndefine( 'DB_COLLATE', '' );\n\$(curl -s https://api.wordpress.org/secret-key/1.1/salt)\n\\\$table_prefix= 'wp_';\ndefine( 'WP_DEBUG', false );\nif ( ! defined( 'ABSPATH' ) ) {define( 'ABSPATH', __DIR__ . '/' );}\nrequire_once ABSPATH . 'wp-settings.php';" > wp-config.php
tar -xzf /home/ubuntu/latest.tar.gz
cp wp-config.php /home/ubuntu/wordpress/
sudo cp -fr /home/ubuntu/wordpress /var/www/html/
chown -R www-data:www-data /var/www/html/wordpress
find /var/www/html/wordpress/ -type d -exec chmod 750 {} \\;
find /var/www/html/wordpress/ -type f -exec chmod 640 {} \\;
cat << FOE > /etc/apache2/sites-available/wordpress.conf
<Directory /var/www/html/wordpress/>
    AllowOverride All
</Directory>
FOE
a2enmod rewrite
a2ensite wordpress
systemctl restart apache2
EOF

# criar maquina - ID da instancia
idInsDois=$(aws ec2 run-instances --image-id ami-08c40ec9ead489470 --instance-type t2.micro --key-name $1 --subnet-id $subNet --security-group-ids $sG --user-data file://ud_ss.sh --query "Instances[].InstanceId" --output text)

while [[ $STATUS2 != "running" ]]; do
        sleep 2
        STATUS2=$(aws ec2 describe-instances --instance-id $idInsDois --query "Reservations[].Instances[].State.Name" --output text)
done

ipS=$(aws ec2 describe-instances --instance-id $idInsDois --query "Reservations[].Instances[].PublicIpAddress" --output text)

a=0

while [[ $ON != "HTTP" ]]; do 
	sleep 2
	a=$(($a+2))
	ON=$(curl -Is http://$ipS/wordpress/ | sed 's/\//\n/g' | head -1)
	if [[ $a -ge 120 ]]; then echo "demorou demais http"; break; fi;
done

echo "IP Público do Servidor de Aplicação: "$ipS
echo -e "\nAcesse  http://"$ipS"/wordpress  para finalizar a configuração."
