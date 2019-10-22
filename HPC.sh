#!/bin/bash
# -- INFORMACOES DA CPU -- 
echo -e "CPU:\n" > info.txt
echo `lscpu | grep -i 'cpu MHz:'` >> info.txt
echo `lscpu | grep -i 'cpu max MHz'` >> info.txt
echo `lscpu | grep -i 'cpu min MHz'` >> info.txt
echo `lscpu | grep -i 'vendor_id' ` >> info.txt
echo `lscpu | grep -i 'per socket' ` >> info.txt
echo `lscpu | grep -i 'socket(s)' ` >> info.txt
echo `lscpu | grep -i 'Model Name' ` >> info.txt
echo `cat /proc/cpuinfo | grep -i 'cache size' | uniq ` >> info.txt
dialog --title 'Informações do Sistema' --textbox info.txt 0 0

# -- INFORMACOES DA RAM -- 
echo -e "RAM: \n" > info.txt
echo `sudo dmidecode --type 17  | grep  -P '(?<=Speed).*(?=MHz)'` >> info.txt
echo `cat /proc/meminfo | grep -i 'MemTotal' ` >> info.txt
echo `cat /proc/meminfo | grep -i 'MemFree' ` >> info.txt
echo `cat /proc/meminfo | grep -i 'MemAvailable' ` >> info.txt
dialog --title 'Informações do Sistema' --textbox info.txt 0 0
rm info.txt
# -- INFORMACOES DO HD -- 
echo -e "\n HD: \n" > info.txt
sudo fdisk -l -uM >> info.txt # particoes e tamanho 
dialog --title 'Informações do Sistema' --textbox info.txt 0 0
# -- INFORMACOES DO BARRAMENTO -- 
echo -e "Barramento PCI: \n" > info.txt
lspci >> info.txt # informação dos barramentos pci e todos os dispositivos plugados a ele.
dialog --title 'Informações do Sistema' --textbox info.txt 0 0
echo -e "Barramento USB: \n" > info.txt
lsusb >> info.txt # informação dos barramentos usb e todos os dispositivos plugados a ele.
dialog --title 'Informações do Sistema' --textbox info.txt 0 0
echo -e "Barramento Modular: \n" > info.txt
lsmod >> info.txt # informação dos barramentos modulo e todos os dispositivos plugados a ele.
dialog --title 'Informações do Sistema' --textbox info.txt 0 0
rm info.txt
# -- INFORMACOES DA GPU --
echo -e "GPU: \n" > info.txt
nvidia-smi >> info.txt
dialog --title 'Informações do Sistema' --textbox info.txt 0 0

clear
