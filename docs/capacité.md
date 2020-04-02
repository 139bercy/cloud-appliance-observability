-   [Plan de capacité](#plan-de-capacité)
    -   [Évaluation des volumes de
        données](#évaluation-des-volumes-de-données)
    -   [Évaluation de la puissance
        nécessaire](#évaluation-de-la-puissance-nécessaire)

Plan de capacité
================

Évaluation des volumes de données
---------------------------------

Type de données                   | Nombre  | Taille
----------------------------------|---------|---------
Messages pauvres (syslog)         | 100 000 |
Messages riches (exceptions Java) | 100 000 |
Métriques                         | 100 000 |

Évaluation de la puissance nécessaire
-------------------------------------

Taille de l'injection    | Nombre de vCPU | Consommation mémoire
-------------------------|----------------|-----------------------
1000 messages / seconde  |                |
1000 métriques / seconde |                |

