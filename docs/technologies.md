# Technologies

## Conformité à la matrice technologique

### Socle

Ces éléments représentent les briques sous-jacentes nécessaires à l'exécution 
de la partie métier.

Nom de l'outil   | Fonction          | Support SLL
-----------------|-------------------|------------
Ubuntu 18.04 LTS | Système           |
Traefik          | Répartiteur       |
Podman           | Exécution         |

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

Nom de l'outil   | Fonction      | Support SLL
-----------------|---------------|------------
Ansible          | Déployeur     | Oui
Makefile         | Orchestration |

### Forge

[Groupe des Ministères Économiques et Financiers](https://github.com/139bercy/cloud-appliance-observability)

### CI / CD

TODO: à réfléchir avec les cibles `Makefile`.

## Environnements de développement et de tests

Hébergement infonuagique interne.
