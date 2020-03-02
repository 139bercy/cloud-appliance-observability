# Technologies

## Conformité à la matrice technologique

### Socle

Ces éléments représentent les briques sous-jacentes nécessaires à l'exécution 
de la partie métier.

Nom de l'outil   | Fonction          | Support SLL
-----------------|-------------------|------------
Centos 8         | Système           |
Traefik          | Répartiteur       |
Podman           | Exécution         |

Centos 8 sera prochainement disponible.

### Métrologie et supervision

Ces éléments représentent les outils de gestion de métriques et d'alertes.

Nom de l'outil   | Fonction                       | Support SLL
-----------------|--------------------------------|------------
Grafana          | IHM de métrologie              |
InfluxDB         | Outils de métriques et alertes |

### Gestion des journaux

Ces éléments représentent les outils de gestion des journaux d'évènements.

Nom de l'outil   | Fonction          | Support SLL
-----------------|-------------------|------------
Graylog          | Gestion des logs  |
MongoDB          | NoSQL             |
Elasticsearch    | Base de logs      |


## Outils de développement

### Construction

Les utilitaires de construction permettent de déployer la pile logicielle.

Nom de l'outil   | Fonction               | Support SLL
-----------------|------------------------|------------
Ansible          | Déployeur              | Oui
Makefile         | Enchaînement de tâches |

### Forge

Forge interne hébergé sur le gitlab interministériel.

### Intégration continue / Développement continu

L'intégration continue et le développement continu fonctionneront via la brique Jenkins de la PIC Cloud.

## Environnements de développement et de tests


### SI-1A

Le développement de l'appliance est fait par SI-1A via 3 couloirs (production, secours, test) hébergés sur l'infonuagique interne.  

### partenaires extérieurs

Les partenaires extérieurs doivent utiliser leurs bacs à sable.

## Stratégie de montée de version

Le chef de projet décide de la reconstruction de son appliance avec la nouvelle version disponible.
De cette façon l'appliance restaurera la dernière version en cours.
Les actions de post-configuration du projet pourront être relancées.