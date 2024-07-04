#!/bin/sh
# Ce script est utilisé pour créer un fichier de timestamp et y écrire la date et l'heure actuelles.

set -eux
# Setting shell options for better error handling and debugging.
# 'e' option will cause the shell to exit if any invoked command fails.
# 'u' option treats unset variables and parameters as an error.
# 'x' option prints each command that gets executed to the terminal, useful for debugging.
touch /tmp/started.time
# Cette commande crée un fichier nommé 'started.time' dans le répertoire '/home/www'.
# Si le fichier existe déjà, la commande ne le modifie pas mais met à jour ses horodatages d'accès et de modification.

if [ $? -ne 0 ]; then
    exit
fi

date > /tmp/started.time
exec "$@"
#   j'ai modifiÃ© le chemin (au lieu de /home/www    j'ai mit /tmp car pas besoin de droit)
