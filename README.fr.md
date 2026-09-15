# Laboratoire Docker Swarm

**Orchestration sur trois nœuds : réplication d'un service HTTP, répartition des tâches et remplacement d'un conteneur supprimé.**

[Rachid EL MAGROUA](https://github.com/rachidelmagrouaIng)

[English](README.md) · [Captures du projet](docs/evidence.md) · [Guide technique en anglais](docs/lab-guide.md)

## Présentation du projet

Ce dépôt présente mon travail sur Docker Swarm à partir de ma présentation « Docker Swarm — Orchestration des conteneurs ». Les captures originales montrent un cluster composé d'un manager et de deux workers, un service Apache avec trois réplicas et le remplacement d'un conteneur après sa suppression.

Le fichier `stack.yml` et les exercices du guide ont été ajoutés pour faciliter la reproduction du laboratoire. Ils ne correspondent pas aux fichiers source originaux et leur exécution sur un cluster reste à valider.

## Compétences mises en avant

- Administration Linux et gestion des nœuds Docker Swarm.
- Déploiement d'un service et analyse de la répartition des tâches.
- Compréhension de l'état souhaité et de la recréation des conteneurs.
- Documentation technique et prise en compte des limites de sécurité.

![Service original avec trois réplicas](docs/images/service-replicas.png)

## Démarrage

Préparer trois machines Linux dédiées au laboratoire avec Docker Engine installé. Vérifier les communications réseau décrites dans le [guide](docs/lab-guide.md).

Sur le manager :

```bash
docker swarm init --advertise-addr <IP_PRIVEE_MANAGER>
docker swarm join-token worker
```

Exécuter la commande générée sur chaque worker, sans publier le jeton. Ensuite, depuis le manager et le dossier du projet :

```bash
docker node ls
docker stack deploy -c stack.yml swarm-lab
docker stack services swarm-lab
docker service ps swarm-lab_web
curl --fail http://<IP_PRIVEE_NOEUD>:8080/
```

Attendre trois réplicas actifs. Le service affiche la page Apache par défaut.

## Limites et précisions

Un seul manager ne permet pas de tolérer sa perte pour les opérations de gestion. La conservation du nombre de réplicas ne constitue pas une mise à l'échelle automatique selon la charge. Les captures ne mesurent ni le temps de reprise ni la disponibilité du service. Les tests du nouveau déploiement restent à effectuer.

La présentation complète contient des jetons visibles dans certaines captures. Ce dépôt inclut uniquement des captures sélectionnées sans jeton, accompagnées d'explications. Voir les [notes de sécurité](docs/security.md).

