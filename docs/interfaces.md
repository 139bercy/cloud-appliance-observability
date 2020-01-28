# Interfaces 

## Envoi des métriques

### Consultation

### Points d'accès

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
Go      | [SDK officiel par Influxdata](https://github.com/influxdata/influxdb-client-go)

Le collecteur à privilégier est `Telegraf` pour les machines.

Source        | Lien
--------------|---------------------------------------
Documentation | https://github.com/influxdata/telegraf
Hub docker    | https://hub.docker.com/_/telegraf
Paquets       | https://repos.influxdata.com/

TODO: Mettre à jour le [rôle Ansible de déploiement ansible-telegraf](https://github.com/mgrzybek/ansible-telegraf).

## Envoi des messages

### Consultation

### Points d'accès

### Protocoles et formats

Protocole | Format
----------|-------------------------------------------------------------------------------------------------
HTTP      | [GELF](http://docs.graylog.org/en/3.2/pages/gelf.html#sending-gelf-messages-via-http-using-curl)

### Exemples de configuration des clients

Des bibliothèques sont disponibles pour beaucoup de langages.

Langage | bibliothèque
--------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Java    | [Log4j HTTP Appender](https://logging.apache.org/log4j/2.x/manual/appenders.html#HttpAppender) avec [Log4j GELF Layout](https://logging.apache.org/log4j/2.x/manual/layouts.html#GELFLayout)
PHP     | [gelf-php](https://github.com/bzikarsky/gelf-php) et [HttpTransport](https://github.com/bzikarsky/gelf-php/blob/master/src/Gelf/Transport/HttpTransport.php) disponibles pour [Drupal](https://www.drupal.org/project/gelf)
Go      | [Bibliothèque GELF over HTTP](https://github.com/robertkowalski/graylog-golang)

Les gestionaires de messages des systèmes d'exploitation sont également 
capables d'envoyer leurs données. Le service `syslog-ng` est recommandé.

Service | Documentation
-------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------
rsyslog                  | [Module omhttp](https://www.rsyslog.com/doc/v8-stable/configuration/modules/omhttp.htm) et [Modèle JSON](https://www.rsyslog.com/doc/v8-stable/configuration/templates.html#generating-json)
syslog-ng                | [Utilisation du modèle format-gelf](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.16/administration-guide/58) et [Utilisation d'une sortie HTTP](https://www.syslog-ng.com/technical-documents/doc/syslog-ng-open-source-edition/3.16/administration-guide/35#TOPIC-956514)
