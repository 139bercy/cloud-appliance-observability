# Architecture Applicative

## Schéma fonctionnel

![Architecture applicative](./placement.png)

## Description des briques

La solution se présente sous la forme d'une paire d'instances auto-configurées. 
Celles-ci sont prêtes à recevoir des données de la part des ressources du 
projet.

Fonctionnalités :

* tableaux de bord personnalisables ;
* règles de réécriture de messages ;
* seuils d'alertes ;
* gestion des rétentions.

![Architecture interne](./briques.png)

## Dimensionnement

En fonction de la quantité de données à traiter (nombre de messages, nombre de 
métriques, fréquence d'envoi) ainsi que de la durée de rétention, les gabarits 
et la taille du stockage sont à sélectionner.

## Projection à 5 ans

En fonction de la vie du projet utilisateur.

## Performances

* TODO: faire des tirs de performances.
* Expériences précédentes : 6000 messages / seconde sans problème.
