#!/bin/bash

askVhostPort() {
    while true; do
        read -p "Bonjour, veuillez mettre le port du vhost : " vhostport
        if [ -n "$vhostport" ]; then
            break
        else
            echo "❌ Veuillez mettre une valeur valide pour le port."
        fi
    done
    echo
}

askServerName() {
    while true; do
        read -p "Veuillez mettre l'URL de la redirection (ex : staff.ezariel.eu) : " serverNameRedirect
        if [ -n "$serverNameRedirect" ]; then
            cp "template-vhost.conf" "$serverNameRedirect.conf"
            break
        else
            echo "❌ Veuillez mettre une valeur valide pour le nom de domaine."
        fi
    done
    echo
}

askServerIp() {
    while true; do
        read -p "Veuillez mettre l'adresse IP de la machine cible : " serverIp
        if [ -n "$serverIp" ]; then
            break
        else
            echo "❌ Veuillez mettre une valeur valide pour l'adresse IP."
        fi
    done
    echo
}

askServerPort() {
    while true; do
        read -p "Veuillez mettre le port de la machine cible : " serverPort
        if [ -n "$serverPort" ]; then
            break
        else
            echo "❌ Veuillez mettre une valeur valide pour le port cible."
        fi
    done
    echo
}

modifyFile() {
    declare -A replacements=(
        ["{vhostPort}"]="$vhostport"
        ["{serverNameRedirect}"]="$serverNameRedirect"
        ["{serverIp}"]="$serverIp"
        ["{serverPort}"]="$serverPort"
    )

    for old_string in "${!replacements[@]}"; do
        new_string=${replacements["$old_string"]}
        sed -i "s|$old_string|$new_string|g" "$serverNameRedirect.conf"
    done
}

main() {
    askVhostPort
    askServerName
    askServerIp
    askServerPort
    modifyFile

    echo "➡️ Activation du site et redémarrage d'Apache..."
    sudo a2ensite "$serverNameRedirect.conf"
    sudo systemctl reload apache2
}

FILE="template-vhost.conf"
if [ -f "$FILE" ]; then
    echo "✅ $FILE trouvé."
    main
else
    echo "❌ $FILE introuvable. Veuillez vérifier qu'il est bien présent dans le dossier courant."
fi
