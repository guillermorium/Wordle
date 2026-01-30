#!/bin/bash
# This is an implmentation of the popular game "Wordle" in bash.

ruta_dict=/home/usuario/wordle/diccionario.txt

# VERSION 1
while [[ $wanna_play=="y" ]]; do

    read -p "¿Cuántas letras quieres que tenga la palabra?" repeticiones    # number of letters of the word
    formato=$(yes "\w" | head -n $repeticiones | tr -d '\n')    # construct the chain \w\w...\w to filter the words with correct extension

    mapfile -t words < <(grep '^'$foramto'$' $ruta_dict | tr '[a-z]' '[A-Z]')   # array with words on dictionary archive
    palabra=${words[$((RANDOM % ${#words[@]}))]}    # correct word we want to guess 
    correct_guess=($(echo "$palabra" | sed -e 's/./& /g'))  # correct word as an array
    incorrect=1 # will be used to see if player has guessed the word
    number_guesses=1

    while [[ $incorrect -eq 1 && $number_guesses -le 6 ]]; do
        ##### READING THE INPUT
        read -p "Escoge una palabra de $repeticiones letras:" lectura && lectura="${lectura^^}" # reading the player word
        guess=($(echo "$lectura" | sed -e 's/./& /g'))  # convert the player word into an array of its letters

        # ensure the player word has the right length and converts it into an array at the end
        while [[ ${#guess[@]} != $repeticiones ]]; do
            echo "- Por favor introduzca una palabra de $repeticiones letras."
            read -p "Escoge una palabra de $repeticiones letras:" lectura && lectura="${lectura^^}"
            guess=guess=($(echo "$lectura" | sed -e 's/./& /g'))
        done

        ##### PRINTING IT BEAUTIFUL
        echo "----- Intento ( $number_guesses / 6 ) -----"  # show the number of tries for the input
        # try is done
        ((number_guesses++))

        ##### CHECKING THE CORRECT LETTERS
        declare -a checking=("r" "r" "r" "r" "r")

        # filling green letters
        for (( i=0; i<${#guess[@]}; i++ )); do
            if [[ "${guess[$i]}" == "${correct_guess[$i]}" ]]; then checking[$i]="g"; fi
        done

        # filling yellow letters
        for (( i=0; i<${#guess[@]}; i++ )); do
            if [[ "${checking[$i]}" == "g" ]]; then continue; fi
            for (( j=0; j<${#guess[@]}; j++ )); do
                if [[ "${guess[$i]}" == "${correct_guesses[$j]}" && $i != $j && "${checking[$j]}" != "g" ]]; then
                    checking[$i]="y"
                    break
                fi
            done
        done

        print "         |"

        # printing the coloured output
        for (( i=0; i<${#guess[@]}; i++ )); do
            if [[ "${checking[$i]}" == "g" ]]; then
                printf "\e[42m${guess[$i]}\e[0m|"
            elif [[ "${checking[$i]}" == "y" ]]; then
                printf "\e[43m${guess[$i]}\e[0m|"
            else
                printf "\e[41m${guess[$i]}\e[0m|"
            fi
        done

        printf "\n"
        echo "-------------------------------------------"

        # check if the word is correct
        if [[ "$lectura" == "$palabra" ]]; then
            incorrect=0
            echo "¡ENHORABUENA!"
            printf "Has acertado en %s intentos\\n" "$(($number_guesses-1))"
            number_guesses=7   # to stop the game because player won
        fi
    done

    if [[ $incorrect -eq 1 ]]; then
        echo "¡HAS PERDIDO!"
        printf "La respuesta correcta era %s\n" "$palabra"
    fi
    sleep 1.3
    read -p "¿Quieres jugar otra vez? (y/n): ? wanna_play
done

# VERSION 2
wanna_play() {
    read -p "Do you want to play Wordle? (y/n): " answer
    case $answer in
        [Yy]* ) return 0;;
        [Nn]* ) echo "Maybe next time!"; exit;;
        * ) echo "Please answer yes or no."; wanna_play;;
    esac
}