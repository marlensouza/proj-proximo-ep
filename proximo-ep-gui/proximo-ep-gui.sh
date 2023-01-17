#!/usr/bin/env bash
#
# Autor......: Marlen Souza
# nome.......: Proximo-ep
# versão.....: 0.5
# descrição..: Permite assistir epsódios
#              de séries em ordem e não se
#              perder na sequência.


# Variáveis de ambiente
#
# $ENTRADA             Recebe as entradas do YAD.
# $PATH_FILE           O caminho do diretório onde se encontra a série.
# $CHECA_ESPACO_PATH   Recebe via AWK o número de campos que há na string. A partir disso
#                      é possível saber ser o nome do diretório contem espaços.
# $NUMERO_EP           Recebe a quantidade de episódios que serão assistidos em sequência.
# CHECA_COUNT_FILE     Serve para verificar se o arquivo (proximo-*) de contagem de episódio existe.
# $Nep                 Recebe o valor numérico do episódio que virá na sequência, baseado
#                      no aquivo proximo-NUM que se encontra no diretório onde está a série.
# $NepM                A partir dessa variável que o arquivo proximo-NUM receberá o valor que
#                      permite identificar qual será o próximo episódio.
#
# Funções principais
#
# Gui()                Executa o YAD. Torna possível que a aplicação possa ter uma interface gráfica
# func_proximo()       É o motor da aplicação. É o código responsável pelas funcionálidades da aplicação
#


Gui(){

	yad --form --title "Proximo-ep v0.4" --field " Diretório da série:DIR" --field " Ver quantos episódio?:NUM" --width=500 --height=80 --button=Ok --button=Cancel | tr "\|" "\n"

}

ENTRADA=$(Gui)

PATH_FILE=$(echo "$ENTRADA" | awk 'NR == 1 { print $1 }')
CHECA_ESPACO_PATH=$(echo "$ENTRADA" | awk 'NR == 1 { print NF }')

NUMERO_EP=$(echo "$ENTRADA" | awk 'NR == 2 { print $1 }')

CHECA_COUNT_FILE=$( ls "$PATH_FILE"/proximo* 2>&- )

# A função "func_proximo()" é a responsável por executar a lógica principal
func_proximo(){


   Nep=$( ls "$PATH_FILE"/proximo* | awk -F"/" '{print $NF }' |awk -F"-" '{ print $2 }' )

   find "$PATH_FILE" -maxdepth 1 -type f -regextype posix-egrep -iregex ".*\/.*\b${Nep}\b.*\.(mkv|mp4)$" -exec vlc --play-and-exit {} \; 2>&-

   NepM=$( awk 'BEGIN{ print '"$Nep"' + 1 }' )

   if [[ "$NepM" -lt 10 ]]
      then
       NepM=$(echo "0$NepM")
   fi

   mv "$PATH_FILE"/proximo-"$Nep" "$PATH_FILE"/proximo-"$NepM"


}

func_erro(){

	yad --center --skip-taskbar --on-top --title="Erro" --justify-center --text="$MENSAGEM_ERRO" --button=Ok:2 --width 280

}

if [[ -z "$ENTRADA" ]]
then
      exit 2

elif [[ "$CHECA_ESPACO_PATH" != 1 ]]
      then

	MENSAGEM_ERRO="     Nome de diretório com espaço\!"

	func_erro

elif [[ -z "$CHECA_COUNT_FILE" ]]
     then

	MENSAGEM_ERRO="     Arquivo \"proximo-00\" não encontrado\!"

        func_erro

elif ([[ -n "$NUMERO_EP" ]] && [[ "$NUMERO_EP" -gt 0 ]])
	then

		for i in $(seq "$NUMERO_EP")
		do
			func_proximo
		done

elif [[ "$NUMERO_EP" -gt 0 ]]
	then

	        func_proximo

fi
