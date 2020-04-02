# Architecture Applicative

## Schéma fonctionnel

Deux cas d'utilisation sont proposés : un déploiement dédié à un projet et un
autre mutualisé.

Dans le premier cas, les appliances d'observabilité sont installées dans le même
espace projet que les ressources métier. Cette approche n'est pas ètrs
efficiente en terme de consommation de ressources. En effet, plusieurs freins
apparaissent :

* la surconsommation des ressources : les projets n'ont pas une taille critique
nécessitant des outils dédiés. La réservation de puissance et d'espace mémoire
n'est donc pas optimal et ne participe pas à l'approche éco-responsable et
économique ;

* la multiplication des outils d'exploitation : la décentralisation des outils
d'exploitation permet de répartir les efforts et les contraintes sur plusieurs
systèmes. À cet effet, un juste milieu doit être trouvé entre le pure
centralisé et le complètement dédié. Il est donc possible de déployer les
services clés-en-main par équipe d'exploitation mutualisée, par exemple :

  * par ESI d'exploitation ;
  * par bureau de développement ;
  * par domaine métier (cf. plan d'occupation des sols).

### Déploiement dédié

Les services d'observabilité sont déployés dans la salle blanche virtuelle de
l'application à exploiter. Le réseau où transittent les données métier n'est
pas utilisé pour communiquer avec les appliances mais seulement dans le cas où
il est nécessaire de surveiller des éléments extérieurs, des services métiers
ou récupérer des artéfacts. Quant à lui, le réseau de *back-office* est utilisé
afin de publier les services d'observabilité qui n'ont pas besoin d'être publiés
au monde extérieur.

![Architecture applicative dédiée à un projet](./placement.png)

### Déploiement mutualisé

Les flux sont les mêmes que supra. L'endroit de l'installation diffère. Dans
cette configuration un espace projet mutualisé comprend tous les outils
d'exploitation qui servent à plusieurs projets sous la responsabilités d'une
même équipe.

![Architecture applicative mutualisée](./placement_mutu.png)

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

Listes des logiciels utilisés avec leurs fonctions et la raison de leurs choix:

- Graylog v3.x: application de gestion des journaux d'évènements ;
- Elasticsearch v6.x: indexeur de messages. Il est interne à Graylog et n'est
  pas visible par les utilisateurs ;
- MongodDB v3.x: base de documents NoSQL pour stocker la configuration de
  Graylog. Elle est interne à Graylog et n'est pas visible par les
  utilisateurs ;
- Influxdb v2 : base de données de métriques, moteur de visualisation et
  d'alertes de supervision ;
- Traefik v2 : service de publication des services Grafana et InfluxDB sur les
  ports HTTP / HTTPS usuel ;
- Grafana v6.x : moteur de visualisation de métriques ;
- Telegraf v1.4: collecteur de métriques à installer sur les machines. Il permet
  l'envoi des métriques systèmes et des applications n'ayant pas la fonction
  d'envoi natif vers InfluxDB ;
- Podman v1.x: moteur de conteneurs soutenu par Redhat. Il est plus sécurisé que
  le moteur Docker.

La brique exécute des conteneurs. Ils sont hébergés sur le dépôt Nexus
infonuagique. Les mécanismes de sécurité sont intégrés à la solution Nexus.

Une application avec un support natif représente les piles technologiques
capables d'intéragir directement avec les outils d'observabilité : envoi
autonome de messages et de métriques. Il s'agit des composants construits
autour des cadriciels Spring (Java) et Drupal (PHP).

## Dimensionnement

En fonction de la quantité de données à traiter (nombre de messages, nombre de
métriques, fréquence d'envoi) ainsi que de la durée de rétention, les gabarits
et la taille du stockage sont à sélectionner.

## Projection à 5 ans

En fonction de la vie du projet utilisateur.

## Performances

* TODO: faire des tirs de performances.
* Expériences précédentes : 6000 messages / seconde estimé à 3 To (à calculer)
La fréquence de purge est à discrétion du chef de produit.

