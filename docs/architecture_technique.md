# Architecture technique

## Contexte

## Orientations techniques

* Stockage des données dans Swift dans un format générique
* Applications sur étagère en conteneurs

## Évolution des outils

* Intégration des appliances à l'offre de services Nuage
* Mise à jour des versions selon les publications des éditeurs

## Proposition

Mettre à disposition des équipes projet d'une part une machine clé-en-main pour
stocker, mettre à disposition les métriques, gérer les alertes et d'autre part
une machine clé-en-main pour stocker, mettre à disposition les journaux
d'évènements, gérer les alertes.

Les éléments techniques clés sont :

* l'utilisation du processus de `cloud-init` pour l'auto-configuration ;
* l'utilisation des conteneurs officiels des outils d'observabilité ;
* le pilotage des solutions d'observabilité par webservices ;
* une résilience des solutions par reconstruction totale et par une
  automatisation des sauvegardes / restaurations des données.

## Schéma technique

## Schéma des flux

Source     | Destinations      | Port          | Usage
-----------|-------------------|---------------|--------------------
Appliances | Gitlab            | HTTPS (443)   | Dépôts
Appliances | API cloud         | HTTPS         | Sauvegardes
Appliances | Proxy             | HTTP (8080)   | Ressources internet
Appliances | Services socles   | HTTP (80/443) | Installation
Appliances | Services externes | HTTP (80/443) | Sondes métier
Métier     | Appliances        | HTTP (80/443) | Webservices
Appliances | Appliances        | HTTP (80/443) | Webservices
Mandataire | Appliances        | HTTP (80/443) | Webservices

## Spécification des instances

Caractéristiques minimales :

Appliance | vCPU | Mémoire | Volumes Cinder
----------|------|---------|----------------
Logs      |  2   |  4 Go   |      3
Metrics   |  2   |  2 Go   |      2

## Budget

Coût de puissance de calcul :

Type               | Prix unitaire   | Quantité | Durée | Total annuel
-------------------|-----------------|----------|-------|--------------
vCPU               |        € / min  |     4    | 365 j |       €
RAM                |        € / Go   |     6    | 365 j |       €
Stockage éphémaire |        € / Go   |    20    | 365 j |       €
Stockage bloc      |        € / Go   |   236    | 365 j |       €
Stockage objets    |        € / Go   |   500    | 365 j |       €
