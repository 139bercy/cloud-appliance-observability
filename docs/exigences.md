-   [Exigences et contraintes
    générales](#exigences-et-contraintes-générales)
    -   [Dépendances externes](#dépendances-externes)
    -   [Migrations techniques](#migrations-techniques)
    -   [Contraintes](#contraintes)
        -   [Réglementaires](#réglementaires)
        -   [Législatives](#législatives)
        -   [Internes](#internes)
    -   [PRA / PCA](#pra-pca)
    -   [Matrice DICT](#matrice-dict)

Exigences et contraintes générales
==================================

Dépendances externes
--------------------

-   [Forge `gitlab`
    interministérielle](https://forge.dgfip.finances.rie.gouv.fr) :
    -   dépôt de l'appliance :
        -   [cloud-appliance-observability](https://forge.dgfip.finances.gouv.fr/dgfip/cloud/deploiements/cloud-appliance-observability)
            ;
    -   rôles `ansible` synchronisés depuis `github` :
        -   [ansible-bootstrap-system](https://forge.dgfip.finances.rie.gouv.fr/dgfip/cloud/ansible-roles/ansible-bootstrap-system)
            ;
        -   [ansible-consul](https://forge.dgfip.finances.rie.gouv.fr/dgfip/cloud/ansible-roles/ansible-consul)
            ;
        -   [ansible-dnsmasq](https://forge.dgfip.finances.rie.gouv.fr/dgfip/cloud/ansible-roles/ansible-dnsmasq)
            ;
        -   [ansible-get-swift-objects](https://forge.dgfip.finances.rie.gouv.fr/dgfip/cloud/ansible-roles/ansible-get-swift-objects)
            ;
        -   [ansible-graylog-input](https://forge.dgfip.finances.rie.gouv.fr/dgfip/cloud/ansible-roles/ansible-graylog-input)
            ;
        -   [ansible-influxdb-bucket](https://forge.dgfip.finances.rie.gouv.fr/dgfip/cloud/ansible-roles/ansible-influxdb-bucket)
            ;
        -   [ansible-influxdb-scraper](https://forge.dgfip.finances.rie.gouv.fr/dgfip/cloud/ansible-roles/ansible-influxdb-scraper)
            ;
        -   [ansible-podman](https://forge.dgfip.finances.rie.gouv.fr/dgfip/cloud/ansible-roles/ansible-podman)
            ;
        -   [ansible-rclone](https://forge.dgfip.finances.rie.gouv.fr/dgfip/cloud/ansible-roles/ansible-rclone)
            ;
        -   [ansible-telegraf](https://forge.dgfip.finances.rie.gouv.fr/dgfip/cloud/ansible-roles/ansible-telegraf).
-   Services infonuagiques :
    -   stockage objects `swift` pour les sauvegardes ;
    -   outil `terraform` pour l'installation de la solution ;
    -   portail de gestion des services infonuagiques pour piloter le
        cycle de vie du produit.
-   Services socles :
    -   dépôts de la distribution ;
    -   dépôts de conteneurs [Hub Docker](https://hub.docker.com) et
        [RedHat Quay](https://quay.io) ;
    -   services mandataires internet.

Migrations techniques
---------------------

Les appliances sont auto-configurées. Les migrations et mises à jour
consistent à une reconstruction complète avec une restauration de la
dernière sauvegarde.

Afin d'éviter une migration technique majeure, il est préférable
d'utiliser la version `2.0-beta` d'`InfluxDB` directement. En effet, son
cycle de vie est beaucoup plus rapide que les projets internes.

Le format utilisé pour la sauvegarde est totalement générique et est de
fait exportable dans d'autres types d'outils.

Contraintes
-----------

### Réglementaires

Les journaux d'évènements nominatifs engendrent des contraintes légales
:

-   durée de rétention d'une année calendaire ;
-   droit à en connaître ;
-   déclarations CNIL.

### Législatives

N.A.

### Internes

PRA / PCA
---------

La solution, dans sa version 1.0, est capable de s'auto-restaurer en
utilisant le stockage objets de l'hébergeur.

Le processus de PRA/PCA consiste en la reconstruction de l'outil avec sa
restauration intégrée.

Matrice DICT
------------

N.A.
