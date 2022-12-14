#!/bin/bash

sudo apt update

sudo timedatectl set-timezone America/Fortaleza

sudo apt install -y apache2

sudo chmod 777 /var/www/html/index.html
echo "" > /var/www/html/index.html

cat << EOF > online.sh
#!/bin/bash
time=0
echo "<html><head><meta charset='utf-8'></head><body>" > /var/www/html/index.html
while true
do
   echo "<ul>"
   echo "<li>"\$(date +%H:%M:%S-%D)" Servidor Ativo</li>" >> /var/www/html/index.html
   echo "<li>Memória Usada: "\$(free -h | tail -n 2 | head -n 1 | tr -s ' ' | cut -d' ' -f 3)"</li>" >> /var/www/html/index.html # used
   echo "<li>Memória Livre: "\$(free -h | tail -n 2 | head -n 1 | tr -s ' ' | cut -d' ' -f 4)"</li>" >> /var/www/html/index.html # free
   echo "<li>Bytes recebidos: "\$(cat /proc/net/dev | tail -n 1 | tr -s ' ' | cut -d' ' -f 3)"</li>" >> /var/www/html/index.html # receive
   echo "<li>Bytes transmitidos: "\$(cat /proc/net/dev | tail -n 1 | tr -s ' ' | cut -d' ' -f 11)"</li>" >> /var/www/html/index.html # transmit
   echo "<li>Tempo Ativo: "\$(uptime -p)"</li>" >> /var/www/html/index.html # transmit
   
   sleep 5   
done
EOF

sudo mv online.sh /usr/share/
sudo chmod +x /usr/share/online.sh

cat << EOF > online.service
[Unit]
After=network.target

[Service]
ExecStart=/usr/share/online.sh

[Install]
WantedBy=default.target
EOF

sudo mv online.service /etc/systemd/system/
sudo systemctl enable online.service
sudo systemctl start online.service

