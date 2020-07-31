#!/bin/bash
# conectadb.sh
# Script simples que conecta em um banco de dados, com um usuário especificado
# e executa o comando que está entre aspas como último parâmetro.
#
# OBS: Este script foi feito utilizando o MariaDB, no Debian
#
# autor: Marco Antonio Damaceno
# data: 05/03/2020
# Versão 0.1

#arquivo de configuração com o usuário administrador do banco de dados
#não recomendo o uso do usuário root
source userdb.conf


#Mostra o uso correto do script
function PrintUsage() {

	echo "Uso: `basename $0` USUARIO HOST DB -grant/revoke 'COMANDO' - entre aspas"
	echo
	echo -e "\nconecta2.sh - Script simples que conecta em um banco de dados, com um usuário especificado"
	echo "e executa o comando que está entre aspas como último parâmetro."
        echo "-grant para GRANT, -revoke para REVOGAR permissões para o usuário informado."
        echo
        echo "OBS: Este script foi criado e testado utilizando MariaDB, em uma instalação Debian."
	echo "==============================================================================================="
	echo -e "EXEMPLO: ./`basename $0` usertest localhost mysql_bash -grant/revoke 'GRANT ALL PRIVILEGES ON * . *'"
        echo
        echo
	sleep 2
        echo "Pressione uma tecla para continuar..."
        read CONTINUA
	exit 1

}

#Definição das variáveis e dos parâmetros
MyUSER=${1:-"Usuário"}
MyHOST=${2:-"Host"}
MyDB=${3:-"Db"}
MyCOMMAND=${4:-"comando"}
MyCOMMAND2=${5:-"comando2"}

#Verifica se o primeiro pa
if [ $# -lt 5 ]; then
    echo "É necessário informar os parâmetros corretamente..."
    echo
    PrintUsage
    exit 1
fi

echo "Você digitou os seguintes parâmetros..."
echo -e "\nUsuário: $MyUSER"
echo "Host: $MyHOST"
echo "DB: $MyDB" 
echo "Comando a ser executado: $MyCOMMAND $MyCOMMAND2"

sleep 2
echo "Pressione uma tecla para cotinuar..."
read CONTINUA

#Executa as ações para -grant
if [ $MyCOMMAND = "-grant" ]; then

    echo -e "\nExecutando as ações solicitadas no Bando de Dados $MyDB..."
    echo
    mysql -u $userdb -p$passdb -e "$MyCOMMAND2 TO '$MyUSER'@'$MyHOST'" $MyDB
    mysql -u $userdb -p$passdb -e "flush privileges" $MyDB


    if [ $? = "0" ]; then
        echo -e "\nAs ações solicitadas foram executadas com sucesso!"
        sleep 2
        echo -e "\nPressione uma tecla para continuar..."
        read CONTINUA
        exit 0
    else
        echo -e "\nHouve um problema no processamento do comando!"
        sleep 2
        echo -e "\nPressione uma tecla para continuar..."
        read CONTINUA
        exit 1
    fi

fi

#Executa as ações para -revoke
if [ $MyCOMMAND = "-revoke" ]; then

    echo -e "\nExecutando as ações solicitadas no Bando de Dados $MyDB..."
    echo
    mysql -u $userdb -p$passdb -e "$MyCOMMAND2 FROM '$MyUSER'@'$MyHOST'" $MyDB
    mysql -u $userdb -p$passdb -e "flush privileges" $MyDB
    

    if [ $? = "0" ]; then
        echo -e "\nAs ações solicitadas foram executadas com sucesso!"
        sleep 2
        echo -e "\nPressione uma tecla para continuar..."
        read CONTINUA
        exit 0
    else
        echo -e "\nHouve um problema no processamento do comando!"
        sleep 2
        echo -e "\nPressione uma tecla para continuar..."
        read CONTINUA
        exit 1
    fi

fi
