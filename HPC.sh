#!/bin/bash
# -- INFORMACOES DA CPU -- 
echo -e "CPU:\n" > info.txt
echo `cat /proc/cpuinfo | grep -i 'cpu MHz'` >> info.txt
echo `cat /proc/cpuinfo | grep -i 'vendor_id' | uniq ` >> info.txt
echo `cat /proc/cpuinfo | grep -i 'cpu cores' | uniq ` >> info.txt
echo `cat /proc/cpuinfo | grep -i 'cache size' | uniq ` >> info.txt

# -- INFORMACOES DA RAM -- 
echo -e "\n RAM: \n" >> info.txt
echo `sudo dmidecode --type 17 | grep -i 'Speed' | uniq ` >> info.txt
echo `cat /proc/meminfo | grep -i 'MemTotal' ` >> info.txt
echo `cat /proc/meminfo | grep -i 'MemFree' ` >> info.txt
echo `cat /proc/meminfo | grep -i 'MemAvailable' ` >> info.txt

# -- INFORMACOES DO HD -- 
echo -e "\n HD: \n" >> info.txt
echo ` fdisk -l | grep 'Disk /dev/sda'` >> info.txt
echo `sfdisk -l -uM` >> info.txt # particoes e tamanho 

# -- INFORMACOES DO BARRAMENTO -- 
echo `lspci` >> info.txt # informação dos barramentos pci e todos os dispositivos plugados a ele.
echo `lsusb` >> info.txt # informação dos barramentos usb e todos os dispositivos plugados a ele.
echo `lsmod` >> info.txt # informação dos barramentos modulo e todos os dispositivos plugados a ele.
 

dialog --title 'Informações do Sistema' --textbox info.txt 0 0

