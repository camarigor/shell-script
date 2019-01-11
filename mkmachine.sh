#!/bin/bash

# this script automates the process of creating a systemd-nspawn container on archlinux
# run it with uid=0
# you need arch-install-scripts package

# asking the user for the container name
echo -n "Enter the container's name: "
read container_name
# asking the user for the container base dir
echo -n "Enter the full path which will contain the container: (e.g. ~/machines)"
read container_dir
# asking the user for the network interface
echo -n "Enter the network interface: "
read interface

# creating the container directory
mkdir -p $container_dir/$container_name

# installing the basic linux stuff
pacstrap -i -c -d $container_dir/$container_name base base-devel vim 

# customizing the template unit file
sed -i "/ExecStart=.*/c\ExecStart=\/usr\/bin\/systemd-nspawn --quiet --keep-unit --boot --link-journal=try-guest --network-macvlan=$interface --private-network --settings=override --machine=\%i -D $container_dir/\%i" /usr/lib/systemd/system/systemd-nspawn@.service

# writing the container network config file
cat > $container_dir/$container_name/etc/systemd/network/mv-$interface.network << EOF
[Match]
Name=mv-$interface
[Network]
DHCP=yes
EOF

# enabling any shell
#rm $container_dir/$container_name/etc/securetty

# removing root passwd at first login, be sure to set passwd root
sed '$ a pts/0' $container_dir/$container_name/etc/securetty
sed '$ a pts/1' $container_dir/$container_name/etc/securetty

# enabling and starting the machined
systemctl enable systemd-machined
systemctl start systemd-machined

# enabling and starting the container
systemctl enable systemd-nspawn@$container_name
systemctl start systemd-nspawn@$container_name

echo "DONE! You should now be able to see the new container under 'machinectl list'. Configure your iptables properly!"
