#!/bin/bash
sudo apt install -y nload dialog
while(:;) do
	OPCAO=$(dialog --stdout --nocancel --title 'Menu' --menu 'Escolha a opcao desejada' 0 0 0 1 "Informações do Sistema" 2 "Firewall" 3 "Proxy")
	case "$OPCAO" in
	1)
	#Inicio informações do sistema
		while(:;) do
		SELECAO=$(dialog --stdout --nocancel --title 'Menu' --menu 'Escolha a informacao desejada' 15 40 9 1 "CPU"  2 "Ram" 3 "HD" 4 "Barramento" 5 "GPU" 6 "Tráfego" 7 "Interfaces de Rede rastreáveis" 0 "Sair")
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
			rm info.txt 
			;;
	
		2)	
		
		# -- INFORMACOES DA RAM -- 
			echo -e  "RAM: \n" >> info.txt
			echo `sudo dmidecode --type 17  | grep  -P '(?<=Speed).*(?=MHz)'` >> info.txt 
			echo `cat /proc/meminfo | grep -i 'MemTotal' ` >> info.txt 
			echo `cat /proc/meminfo | grep -i 'MemFree' ` >> info.txt 
			echo `cat /proc/meminfo | grep -i 'MemAvailable' ` >> info.txt 
			dialog --title 'Informações do Sistema' --textbox info.txt 0 0 
			rm info.txt 
			;;
			
		3)
		# -- INFORMACOES DO HD -- 
			echo -e "\n HD: \n" > info.txt 
			sudo fdisk -l -uM >> info.txt  # particoes e tamanho
			dialog --title 'Informações do Sistema' --textbox info.txt 0 0 
			rm info.txt 
			;;
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
			rm info.txt 
			;;
		5)
		# -- INFORMACOES DA GPU 
			echo -e "GPUs instaladas:\n" > info.txt
			sudo lshw -numeric -C display | grep product > info.txt
			dialog --title 'Informações do Sistema' --textbox info.txt 0 0
			echo -e "GPU Nvidia: \n" > info.txt 
			nvidia-smi >> info.txt 
			dialog --title 'Informações do Sistema' --textbox info.txt 0 0
			rm info.txt
			;;
		6)
		# INFORMAÇÕES DE TRAFEGO DE REDE
			nload -m
			;;
		7)
			ifconfig > info.txt
			dialog --title 'Interfaces de Rede - Escolha uma para rastrear' --textbox info.txt 0 0
			network_interface=$( dialog --inputbox --stdout 'Digite a interface de rede a ser rastreada:' 0 0  )
			clear
			sudo tcpdump -i $network_interface
			;;
		0)
			break;;
		esac
		done
		;;	
	#fim INformacoes do sistema
	2)
	#Inicio Firewall
	 	system_ip=$(dialog --inputbox --stdout 'Digite o IP do servidor:' 0 0 )
		 iptables -t nat -A POSTROUTING -s $system_ip/24 -j MASQUERADE
		 echo "1" >/proc/sys/net/ipv4/ip_forward
		 dialog --title 'AVISO' --infobox 'O sistema está habilitado como servidor' 0 0
		 sleep 5
		while(:;) do
		REGRA=$(dialog --stdout --nocancel --title 'Menu' --menu 'O que deseja Fazer' 0 0 0 1 "Ver Regras Habilitadas" 2 "Remover todas as Regras" 3 "Bloquear IP" 4 "Roteamento" 0 "Sair")
		case "$REGRA" in
		0)
			break;;
		1)
			echo -e "Regras de Firewall implementadas " > info.txt
			iptables -L >> info.txt
			dialog --title 'Firewall' --textbox info.txt 0 0
			rm info.txt
			;;
		2)
			iptables -F
			;;
		3)
			blocked_ip=$(dialog --inputbox --stdout 'Digite o IP a ser bloqueado:' 0 0 )
			iptables -I INPUT -s $blocked_ip -j DROP
			;;
		4)	
			ROTEAMENTO=$( dialog --stdout --radiolist 'Aperte barra de espaco para selecionar:' 0 0 0 1 'PREROUTING' off 2 'POSTROUTING' off 3 'FORWARD' on )
			case "$ROTEAMENTO" in
			1)
				source_ip=$(dialog --inputbox --stdout 'Digite o IP fonte:' 0 0 )
				destiny_ip=$(dialog --inputbox --stdout 'Digite o IP de destino:' 0 0 )
				ls /sys/class/net > info.txt
				dialog --title 'Interfaces disponiveis para seleção' --textbox info.txt 0 0
				select_interface=$(dialog --inputbox --stdout 'Digite a interface de rede a ser utilizada:' 0 0 )
				iptables -t nat -A PREROUTING -s $source_ip -i $select_interface -j DNAT --to $destiny_ip
				;;
			2)	

				source_ip=$(dialog --inputbox --stdout 'Digite o IP fonte:' 0 0 )
                                modified_ip=$(dialog --inputbox --stdout 'Digite o IP modificado:' 0 0 )
                                ls /sys/class/net > info.txt
                                dialog --title 'Interfaces disponiveis para seleção' --textbox info.txt 0 0
                                select_interface=$(dialog --inputbox --stdout 'Digite a interface de rede a ser utilizada:' 0 0 )
                                iptables -t nat -A POSTROUTING -s $source_ip -o $select_interface -j SNAT --to $modified_ip
                                ;;
				
			3)
				dialog --title 'AVISO' --infobox 'Essa regra irá permitir a entrada de pacotes de protocolo tcp na porta e ip desejados, cuidado pois permitir pacotes pode colocar o seu sistema em risco' 0 0
				source_ip=$(dialog --inputbox --stdout 'Digite o IP Desejado:' 0 0 )
				port=$(dialog --inputbox --stdout 'Digite a porta desejada' 0 0)


				iptables -A FORWARD -p tcp -d $source_ip --dport $port -j ACCEPT

				;;


			esac

	
			;;
		esac
		done
		;;
	#Fim FIrewall
	3)
	#Inicio Proxy
		while(:;) do
		SELECAO=$(dialog --stdout --nocancel --title 'Menu' --menu 'Escolha a informacao desejada' 15 40 9 1 "Bloquear Site"  2 "Limpar Sites Bloqueados")
		case "$SELECAO" in
		1)
			bloc_site=$(dialog --inputbox --stdout 'Digite o Site que deseja bloquear no modelo > .blockedsite.com:' 0 0 )
		#	block_site >> inserir aqui arquivo dos sites bloqueados  FUNÇÃO QUE DETERMINA OS SITES BLOQUEADOS
			dialog 'AVISO' --infobox 'Espere alguns minutos para a aplicaçao das regras' 0 0
			sleep 3
			sudo systemctl restart squid #restarta o squid para aplicação das regras
			;;
		2)
		#       "" >> inserir aqui arquivo dos sites bloqueados  FUNÇÃO QUE DETERMINA OS SITES BLOQUEADOS
                	dialog --title 'AVISO' --infobox 'Espere alguns minutos para a aplicaçao das regras' 0 0
			sleep 3       
	       		sudo systemctl restart squid #restarta o squid para aplicação das regras
			


			;;
		esac

	#Fim Proxy
	done
	;;
		
	esac

done
