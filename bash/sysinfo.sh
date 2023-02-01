#!/bin/bash
#this is runing a srcip that is going to make variables that have information on the OS ->
#avalable for the script
source /etc/os-release


#this part of the script is going to colect the information the is going to be->
#displayed
var1=$(hostname -A)
var2=$(hostname -I)
var3=$(df -h /root --output=avail | tail -n +2)


#this is going to print the folowing information 
#(the fuly qualifyde domain name of the host)
#(the operating system and the curent version of it)
#(the IP address of the host machine)
#(the amont of disk space avalable on the Root filesystem )
echo "
===========================================
FQDN:                    $var1
OS:                      $PRETTY_NAME
ip:                      $var2
disk space in root:     $var3
===========================================
"
