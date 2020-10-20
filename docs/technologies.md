-   [Technologies](#technologies)
    -   [Conformité à la matrice
        technologique](#conformité-à-la-matrice-technologique)
        -   [Socle](#socle)
        -   [Intégration cloud](#intégration-cloud)
        -   [Métrologie et supervision](#métrologie-et-supervision)
        -   [Gestion des journaux](#gestion-des-journaux)
    -   [Outils de développement](#outils-de-développement)
        -   [Construction](#construction)
        -   [Forge](#forge)
        -   [Intégration et déploiement
            continus](#intégration-développement-continus)
    -   [Environnements de développement et de
        tests](#environnements-de-développement-et-de-tests)
        -   [SI-1A](#si-1a)
        -   [partenaires extérieurs](#partenaires-extérieurs)
    -   [Stratégie de montée de
        version](#stratégie-de-montée-de-version)

Technologies
============

Conformité à la matrice technologique
-------------------------------------

### Socle

Ces éléments représentent les briques sous-jacentes nécessaires à
l'exécution de la partie métier.

  Nom de l'outil | Fonction     | Support SLL
  ---------------| -------------|-------------
  CentOS 8       | Système      |
  Traefik        | Répartiteur  |
  Podman         | Exécution    |

Centos 8 sera prochainement disponible.

### Intégration cloud

Ces éléments représentent les briques sous-jacentes nécessaires à
l'intégration des solutions logicielles avec les autres applicances.

  Nom de l'outil | Fonction             | Support SLL
  ---------------|----------------------|-------------
  Consul         | Mise en réseau cloud |
  Telegraf       | Client de métrologie |

### Métrologie et supervision

Ces éléments représentent les outils de gestion de métriques et
d'alertes.

  Nom de l'outil | Fonction                      | Support SLL
  ---------------|--------------------------------|-------------
  Grafana        | IHM de métrologie              |
  InfluxDB       | Outils de métriques et alertes |

### Gestion des journaux

Ces éléments représentent les outils de gestion des journaux
d'évènements.

  Nom de l'outil | Fonction         | Support SLL
  ---------------|------------------|-------------
  Graylog        | Gestion des logs |
  MongoDB        | NoSQL            |
  Elasticsearch  | Base de logs     |

Outils de développement
-----------------------

### Construction

Les utilitaires de construction permettent de déployer la pile
logicielle.

  Nom de l'outil | Fonction  | Support SLL
  ---------------|-----------|-------------
  Ansible        | Déployeur | Oui
  Terraform      | Déployeur |

### Forge

[`Gitlab` interministérielle sur le
RIE](https://forge.dgfip.finances.rie.gouv.fr/dgfip/cloud/deploiements/cloud-appliance-observability.git)

### Intégration et déploiement continus

Les usines logicielles de la DGFIP sont utilisées (cf. Jenkins de la PIC
Cloud).

Environnements de développement et de tests
-------------------------------------------

### SI-1A

Le développement de l'appliance est fait par SI-1A via 3 couloirs
(production, secours, test) hébergés sur l'infonuagique interne.

### partenaires extérieurs

Les partenaires extérieurs doivent utiliser leurs bacs à sable.

Stratégie de montée de version
------------------------------

Le chef de projet décide de la reconstruction de son appliance avec la
nouvelle version disponible. De cette façon l'appliance restaurera la
dernière version en cours. Les actions de post-configuration du projet
pourront être relancées.
