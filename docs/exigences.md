# Exigences et contraintes générales

## Dépendances externes

* Dépôt `git` d'hébergement des scripts d'installation :
  * github : [cloud-appliance-observability](https://github.com/139bercy/cloud-appliance-observability) ;
  * gitlab : mirroir pour installer hors-ligne.

* Services infonuagiques :
  * stockage objects `swift` pour les sauvegardes ;
  * service d'orchestration `HEAT` pour l'installation de la solution ;
  * portail de gestion des services d'infonuagiques pour piloter le cycle de 
  vie du produit.

* Services socles :
  * dépôts de la distribution ;
  * dépôts de conteneurs [Hub Docker](https://hub.docker.com) et 
  [RedHat Quay](https://quay.io) ;
  * services mandataires internet.

## Migrations techniques

Les appliances sont auto-configurées. Les migrations et mises à jour consistent 
à une reconstruction complète avec une restauration de la dernière sauvegarde.

Afin d'éviter une migration technique majeure, il est préférable d'utiliser 
la version `2.0-beta` d'`InfluxDB` directement. En effet, son cycle de vie est 
beaucoup plus rapide que les projets internes.

## Contraintes

### Réglementaires

Les journaux d'évènements nominatifs engendrent des contraintes légales :

* durée de rétention d'une année calendaire ;
* droit à en connaître ;
* déclarations CNIL.

### Législatives

N.A.

### Internes

## PRA / PCA

La solution, dans sa version 1.0, est capable de s'auto-restaurer en utilisant 
le stockage objets de l'hébergeur.

Le processus de PRA/PCA consiste en la reconstruction de l'outil avec sa 
restauration intégrée.

## Matrice DICT

N.A.
