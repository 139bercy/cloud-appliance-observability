# Technologies

## Conformité à la matrice technologique

### Socle

Ces éléments représentent les briques sous-jacentes nécessaires à l'exécution 
de la partie métier.

Nom de l'outil | Fonction      | Support SLL
---------------|---------------|------------
CentOS 8       | Système       |
Traefik        | Répartiteur   |
Podman         | Exécution     |

### Intégration cloud

Ces éléments représentent les briques sous-jacentes nécessaires à l'intégration 
des solutions logicielles avec les autres applicances.

Nom de l'outil | Fonction             | Support SLL
---------------|----------------------|------------
Consul         | Mise en réseau cloud |
Telegraf       | Client de métrologie |

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
Openstack HEAT   | Déployeur     |

### Forge

[`Gitlab` interministérielle sur le RIE](https://forge.dgfip.finances.rie.gouv.fr/dgfip/cloud/deploiements/cloud-appliance-observability.git)

### CI / CD

Les usines logicielles de la DGFIP sont utilisées

## Environnements de développement et de tests

Hébergement infonuagique interne.
