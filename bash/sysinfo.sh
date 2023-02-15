#!/bin/bash
#this is runing a srcipt that is going to make variables that have information on the OS ->
#available for the script
source /etc/os-release


#this part of the script is going to colect the information that is going to be->
#displayed on the echo command
title=$(hostname)
var1=$(hostname -a)
var2=$(hostname -I)
var3=$(df -h /root --output=avail | tail -n +2)


#this is going to print the following information 
#(the fuly qualified domain name of the host)
#(the operating system and the curent version of it)
#(the IP address of the host machine)
#(the amont of disk space avalable on the Root filesystem )
cat <<EOF
$title
===========================================
FQDN:                    $var1
OS:                      $PRETTY_NAME
ip:                      $var2
disk space in root:     $var3
===========================================
EOF
