set -x
rm *.db
chmod +x hosts.sh
 ./hosts.sh -a routerlab -i 192.168.0.1
 ./hosts.sh -a lab01 -i 192.168.0.100
 ./hosts.sh -a lab02 -i 192.168.0.101
 ./hosts.sh -l
read
./hosts.sh -d routerlab
./hosts.sh -d lab01
./hosts.sh -l
read
./hosts.sh lab02
read
./hosts.sh -r 192.168.0.101
read
set +x
