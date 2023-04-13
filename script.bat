#!/bin/bash


askVhostPort(){
    read -p "Bonjour Veuillez mettre le port du vhost "$'\n'  vhostport
    if [ -z "$vhostport" ]; then
        echo "Veuillez mettre une valeur valide"
        read -p "Bonjour Veuillez mettre le port du vhost "$'\n'  vhostport
    else
        echo $'\n'
    fi

}
askServerName(){
    read -p "Veuillez mettre l url de la redirection ex : staff.ezariel.eu "$'\n'  serverNameRedirect
    cp "template-vhost.conf" "$serverNameRedirect.conf"
    if [ -z "$serverNameRedirect" ]; then
        echo "Veuillez mettre une valeur valide"
        read -p "Veuillez mettre l url de la redirection ex : staff.ezariel.eu "$'\n'  serverNameRedirect
        cp "template-vhost.conf" "$serverNameRedirect.conf"
    else
        echo $'\n'
    fi

}
askServerIp(){
    read -p "Veuillez mettre l'adresse ip de la machine cible "$'\n'  serverIp
    if [ -z "$serverIp" ]; then
        echo "Veuillez mettre une valeur valide"
        read -p "Veuillez mettre l'adresse ip de la machine cible "$'\n'  serverIp
    else
        echo $'\n'
    fi

}
askServerPort(){
    read -p "Veuillez mettre le port de la machine cible "$'\n'  serverPort
    if [ -z "$serverPort" ]; then
        echo "Veuillez mettre une valeur valide"
        read -p "Veuillez mettre le port la machine cible "$'\n'  serverPort
    else
        echo $'\n'
    fi

}
modifyFile(){
    declare -A replacements=(
      ["{vhostPort}"]="$vhostport"
      ["{serverNameRedirect}"]="$serverNameRedirect"
      ["{serverIp}"]="$serverIp"
      ["{serverPort}"]="$serverPort"
    )

    for old_string in "${!replacements[@]}"
    do
      new_string=${replacements["$old_string"]}
      sed -i "s/$old_string/$new_string/g" "$serverNameRedirect.conf"
    done
}

main(){
    askVhostPort
    askServerName
    askServerIp
    askServerPort
    modifyFile
    echo "execution des commandes a2ensite $serverNameRedirect.conf et service apache2 restart"
    sleep 2s
    exec "a2ensite $serverNameRedirect.conf"
    sleep 2s
    exec "service apache2 restart"
}


FILE=template-vhost.conf
if [ -f "$FILE" ]; then
    echo "$FILE exists."
    main
else 
    echo "$FILE does not exist."
fi
