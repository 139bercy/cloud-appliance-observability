# Description

## Origine du projet

Afin d'accompagner la démarche "dev-ops" des projets, la division méthodes et outils de développement (DMOD) du bureau SI-1A fournit des socles d'outils pré-configurés. L'un de ces socles 
permet l'observabilité les ressources du projet selon trois axes :

* centralisation des journaux d'évènements ;
* centralisation des métriques ;
* gestion des alertes.

## Impact sur le système d'informations

La brique d'observabilité est déployée au plus près des applications, dans les 
espaces projets (`tenants`) infonuagiques.

## Principales fonctionnalités

La solution permet de :

* centraliser les journaux d'évènements :
  * les services `syslog` des instances envoient les messages et ne stocke plus 
  en local ;
  * les applications prennent en charge directement l'envoi de leurs messages ;
  
* centraliser les métriques :
  * les métriques systèmes sont collectés en local et envoyés ;
  * les applications prennent en charge directement l'envoi de leurs métriques 
  qu'ils soient métier ou technique ;
  
* gérer des alertes :
  * les données centralisées sont analysées en fonction de critères définis 
  par les projets ;
  * ces critères aident à définir des seuils d'alerte.

## Plan d'occupation des sols

N.A.
