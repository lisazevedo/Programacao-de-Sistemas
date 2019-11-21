#!/bin/bash
# sudo apt install -y nload dialog
while(:;) do
SELECAO=$(dialog --stdout --nocancel --title 'Menu' --menu 'Escolha a informacao desejada' 15 40 9 1 "CPU"  2 "Ram" 3 "HD" 4 "Barramento" 5 "GPU" 6 "Tráfego")
# [$? -ne 0 && break]
case "$SELECAO" in
1)
#  -- INFORMAÇÃO DA CPU --
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
rm info.txt ;;

2)	

# -- INFORMACOES DA RAM -- 
echo -e  "RAM: \n" >> info.txt
echo `sudo dmidecode --type 17  | grep  -P '(?<=Speed).*(?=MHz)'` >> info.txt 
echo `cat /proc/meminfo | grep -i 'MemTotal' ` >> info.txt 
echo `cat /proc/meminfo | grep -i 'MemFree' ` >> info.txt 
echo `cat /proc/meminfo | grep -i 'MemAvailable' ` >> info.txt 
dialog --title 'Informações do Sistema' --textbox info.txt 0 0 
rm info.txt ;;

3)
# -- INFORMACOES DO HD -- 
echo -e "\n HD: \n" > info.txt 
sudo fdisk -l -uM >> info.txt  # particoes e tamanho
dialog --title 'Informações do Sistema' --textbox info.txt 0 0 
rm info.txt ;;
# -- INFORMACOES DO BARRAMENTO --
4)
echo -e "Barramento PCI: \n" > info.txt 
lspci >> info.txt # informação dos barramentos pci e todos os dispositivos plugados a ele.
dialog --title 'Informações do Sistema' --textbox info.txt 0 0 
echo -e "Barramento USB: \n" > info.txt 
lsusb >> info.txt # informação dos barramentos usb e todos os dispositivos plugados a ele.
dialog --title 'Informações do Sistema' --textbox info.txt 0 0 
echo -e "Barramento Modular: \n" > info.txt 
lsmod >> info.txt # informação dos barramentos modulo e todos os dispositivos plugados a ele.
dialog --title 'Informações do Sistema' --textbox info.txt 0 0
rm info.txt ;;
5)
# -- INFORMACOES DA GPU 
echo -e "GPUs instaladas:\n" > info.txt
echo -e `lshw -numeric -C display | grep vendor` >> info.txt
dialog --title 'Informações do Sistema' --textbox info.txt 0 0
echo -e "GPU Nvidia: \n" > info.txt 
nvidia-smi >> info.txt 
dialog --title 'Informações do Sistema' --textbox info.txt 0 0
rm info.txt;;
6)
# INFORMAÇÕES DE TRAFEGO DE REDE
nload -m
;;
esac
clear
done
