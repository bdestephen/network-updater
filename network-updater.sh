#!/bin/bash

# DeStephen Network Restart v1.0
# http://destephen.com
#
echo ""
echo "Use of this script requires elevated access."
echo ""
(( EUID != 0 )) && exec sudo -- "$0" "$@"
#
networkfile="/etc/network/interfaces"
if [ ! -f $networkfile ]; then
  echo ""
  echo "The file '$networkfile' doesn't exist!"
  echo ""
  exit 1
fi
#
writedhcpfile()
    {
    mv -f /etc/network/interfaces /etc/network/interfaces.old
    cat << EOF > $1
    # This file describes the network interfaces available on your system
    # and how to activate them. For more information, see interfaces(5).
    # The loopback network interface
    auto lo
    iface lo inet loopback

     auto eth0
    iface eth0 inet dhcp
EOF
#
      echo ""
      echo "Your new network configuration was saved in the '$networkfile' file."
      echo ""

    reboot

      echo ""
      echo "This appliance is being restarted."
      echo ""
      exit 0
    }
#
writestaticfile()
  {
  read -p "Enter the IP address            : " staticip
  read -p "Enter the subnet mask           : " netmask
  read -p "Enter the default gateway       : " routerip
  read -p "Enter the broadcast address     : " broadcast
  read -p "Enter the domain name           : " domain
  read -p "Enter the primary DNS Server    : " domainserver
  mv -f /etc/network/interfaces /etc/network/interfaces.old
  cat << EOF > $networkfile
  # This file describes the network interfaces available on your system
  # and how to activate them. For more information, see interfaces(5).
  # The loopback network interface
  auto lo
  iface lo inet loopback

  auto eth0
  iface eth0 inet static
          address $staticip
          netmask $netmask
          gateway $routerip
          broadcast $broadcast
          dns-nameservers $domainserver
          dns-search $domain
EOF
#
    echo ""
    echo "Your new network configuration was saved in the '$networkfile' file."
    echo ""

  reboot

    echo ""
    echo "This appliance is being restarted."
    echo ""
    exit 0
  }
#
while true; do
  echo ""
  echo "Use of this script will restart the appliance."
  echo ""
  echo ""
  echo ""
  echo ""
  echo ""
  echo "What action would you like to preform?"
  echo ""
  echo "Press 1 to set appliance to use DHCP"
  echo "Press 2 to set appliance to use Static Addressing"
  echo ""
  read -p "What action would you like to preform (1 or 2)? " decision
  case $decision in
    "1") writedhcpfile $networkfile;;
    "2") writestaticfile $networkfile;;
     * ) echo "Please enter 1 or 2!";;
  esac
done
#
