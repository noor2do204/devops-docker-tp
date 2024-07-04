#!/bin/bash

set -euo pipefail


#   set pour changer les valeurs,  -e option pour sortir en cas d'echec, -u option pour définir les paramètre non connus 
IMG=$(echo img$$)

docker image build --tag $IMG ./src # --load




#   construit une image docker de Dockerfile du répertoire ./src,   le tag est le nom unique IMG créé plus tôt,   
#   L'option '--load' s'assure que l'image est chargée dans le daemon Docker seulement si vous utilisez docker buildx.

USR=$(docker container run --rm --entrypoint=whoami $IMG )

#   on execute le conteneur Docker à partir de l'image construite ci-dessus.
#   Le conteneur est supprimé après son exécution (option --rm).
#   Le point d'entrée du conteneur est remplacé pour exécuter la commande 'whoami'.
#   La sortie de 'whoami' (qui est le nom d'utilisateur) est stockée dans la variable USR.


if [[ $USR == "root" ]]; then
echo "User cannot be root!"
fi
#   on vérifie si l'utilisateur à l'intérieur du conteneur est root.
#   on affiche le message suivant echo

docker container run --rm --detach --tmpfs /tmp --read-only $IMG > /dev/null
#   Exécution d'un conteneur Docker en mode détaché à partir de l'image construite ci-dessus.
#   Le conteneur est supprimé après son exécution (option --rm).
#   Un système de fichiers temporaire est monté à /tmp à l'intérieur du conteneur (option --tmpfs).
#   Le système de fichiers du conteneur est monté en lecture seule (option --read-only).
#   La sortie de cette commande est redirigée vers /dev/null pour la supprimer.

ID=$(docker container ls -laq)
#   Obtention de l'ID du dernier conteneur créé.

RUNNING=$(docker container inspect -f '{{.State.Status}}' $ID)
#   Vérification du statut du conteneur avec l'ID obtenu ci-dessus.
#   Le statut est extrait de la sortie de la commande 'docker container inspect' en utilisant une chaîne de format.

if [[ $RUNNING == "running" ]]; then
    docker kill $ID > /dev/null
else
echo "Container cannot run in read-only mode!"
fi
#   Vérification si le conteneur est en cours d'exécution.
#   Si c'est le cas, le conteneur est arrêté.
#   Si ce n'est pas le cas, un message d'erreur est imprimé.

docker rmi $IMG > /dev/null
#   Suppression de l'image Docker construite ci-dessus.
#   La sortie de cette commande est redirigée vers /dev/null pour la supprimer.
