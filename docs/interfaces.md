# Interfaces 

## Gestion des métriques

### Consultation

La solution propose deux façons d'accéder aux éléments stockés, par IHM ou 
webservices :

* de manière optimale : le moteur de gestion des métriques `InfluxDB` : 
requêtes, tableaux de bords (pré-configuration, création...), gestion des 
alertes (seuils, envois) ;

* ensuite : le moteur de tableaux de bord `Grafana` : requêtes, tableaux de 
bords, interrogation de plusieurs applicances d'observabilité.

### Points d'accès

Les webservices sont publiés sur l'interface de *back-office* de l'appliance.
En conséquence, son insertion dans l'architecture du `tenant` doit être 
adaptées en fonction de son usage :

* consultation des données : il est néccesaire de publier les services avec un 
serveur mandataire sur le réseau de *back-office* `FIP_ADMINISTRATION` (cf.
restriction d'une adresse par projet sur ce réseau) ;

* envoi des données : les ressources du `tenant` envoient directement les 
métriques (utilisation intra-projet), les ressources externes passent par un 
serveur mandataire (cf. supra avec le point sur les consultations).

### Protocoles et formats

Protocole | Format
----------|-----------------------------------------------------------------------------------
HTTP      | [InfluxDB Write API](https://v2.docs.influxdata.com/v2.0/api/#operation/PostWrite)

### Exemples de configuration des clients

Des bibliothèques sont disponibles pour beaucoup de langages.

Langage | Documentation
--------|-------------------------------------------------------------------------------
Java    | [Support d'InfluxDB dans Spring](https://docs.spring.io/spring-boot/docs/2.0.0.RC1/api/org/springframework/boot/autoconfigure/influx/InfluxDbAutoConfiguration.html) et [SDK officiel par Influxdata](https://github.com/influxdata/influxdb-client-java)
PHP     | [SDK officiel par Influxdata](https://github.com/influxdata/influxdb-php)

Le collecteur à utiliser est `Telegraf` pour les machines :

* pour les métriques systèmes ; 
* pour les informations non envoyables directement par les applications.

Source        | Lien
--------------|---------------------------------------
Documentation | https://github.com/influxdata/telegraf
Hub docker    | https://hub.docker.com/_/telegraf
Paquets       | https://repos.influxdata.com/
Déploiement   | https://forge.dgfip.finances.gouv.fr/dgfip/cloud/ansible-roles/ansible-telegraf

## Gestion des messages

### Consultation

La solution propose une façon unifiée d'accéder aux éléments stockés, par IHM 
ou webservices :

* `Graylog` est la seule application publiée par l'appliance et permet de gérer 
tous les aspects de la gestion des messages (consultations, tableaux de bord, 
réécritures, gestion des alertes...).

### Points d'accès

Les webservices sont publiés sur l'interface de *back-office* de l'appliance.
En conséquence, son insertion dans l'architecture du `tenant` doit être 
adaptées en fonction de son usage :

* consultation des données : il est néccesaire de publier les services avec un 
serveur mandataire sur le réseau de *back-office* `FIP_ADMINISTRATION` (cf.
restriction d'une adresse par projet sur ce réseau) ;

* envoi des données : les ressources du `tenant` envoient directement les 
métriques (utilisation intra-projet), les ressources externes passent par un 
serveur mandataire (cf. supra avec le point sur les consultations).

### Protocoles et formats

Protocole | Format
----------|-------------------------------------------------------------------------------------------------
HTTP      | [GELF](http://docs.graylog.org/en/3.2/pages/gelf.html#sending-gelf-messages-via-http-using-curl)

Le format GELF a l'avantage d'être du JSON avec des champs obligatoires.

### Exemples de configuration des clients

Des bibliothèques sont disponibles pour les langages autorisés à la DGFiP.

Langage | bibliothèque
--------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Java    | [Log4j HTTP Appender](https://logging.apache.org/log4j/2.x/manual/appenders.html#HttpAppender) avec [Log4j GELF Layout](https://logging.apache.org/log4j/2.x/manual/layouts.html#GELFLayout)
PHP     | [gelf-php](https://github.com/bzikarsky/gelf-php) et [HttpTransport](https://github.com/bzikarsky/gelf-php/blob/master/src/Gelf/Transport/HttpTransport.php) disponibles pour [Drupal](https://www.drupal.org/project/gelf)

Les gestionaires de messages des systèmes d'exploitation sont également 
capables d'envoyer leurs données. Le service `syslog-ng` est nécessaire à la 
place de `rsyslog` (support HTTP absent des paquets CentOS 8+).

Service | Documentation
-------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------
rsyslog                  | [Module omhttp](https://www.rsyslog.com/doc/v8-stable/configuration/modules/omhttp.htm) et [Modèle JSON](https://www.rsyslog.com/doc/v8-stable/configuration/templates.html#generating-json)
syslog-ng                | [Utilisation du modèle format-gelf](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.16/administration-guide/58) et [Utilisation d'une sortie HTTP](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.16/administration-guide/35#TOPIC-956514)
