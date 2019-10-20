#!/bin/bash
echo -e "CPU:\n" > info.txt
echo `cat /proc/cpuinfo | grep -i 'cpu MHz'` >> info.txt
echo `cat /proc/cpuinfo | grep -i 'vendor_id' | uniq ` >> info.txt
echo `cat /proc/cpuinfo | grep -i 'cpu cores' | uniq ` >> info.txt
echo `cat /proc/cpuinfo | grep -i 'cache size' | uniq ` >> info.txt
echo -e "\n RAM: \n" >> info.txt
echo `sudo dmidecode --type 17 | grep -i 'Speed' | uniq ` >> info.txt
echo `cat /proc/meminfo | grep -i 'MemTotal' ` >> info.txt
echo `cat /proc/meminfo | grep -i 'MemFree' ` >> info.txt
echo `cat /proc/meminfo | grep -i 'MemAvailable' ` >> info.txt
echo -e "\n HD: \n" >> info.txt
echo ` fdisk -l | grep 'Disk /dev/sda'` >> info.txt

dialog --title 'Informações do Sistema' --textbox info.txt 0 0

