# Présentation de l'appliance 

L'appliance est un outillage de sauvegarde et de restauration de Graylog vers un service de stockage objet Swift en environnement Openstack.  
Il permettra également de fournir un état de la sauvegarde.

Le document va présenter le fonctionnement de l'appliance à travers plusieurs schémas:  
- L'architecture technique de l'appliance;  
- L'appliance dans le projet;  
- L'envoi de la donnée vers l'outils;  
- L'envoi de la donnée vers l'appliance;  



## Architecture technique de l'appliance

Le schéma ci-dessous explique le fonctionnement général de l’appliance:  

![alt tag](./Schema-blocs-fonctionnels.svg)  

La stack HEAT contient des machines de projet qui envoie des logs vers l’appliance.  

L’appliance contient Graylog et des services internes: Elasticsearch et MongoDB.  
Graylog est un service publié aux utilisateurs contrairement aux services internes qui ne sont pas atteignable par les utilisateurs  
  

## L'appliance dans le projet

Le schéma précise le fonctionnement de l'appliance:  

![alt tag](./Appliance-zoom.svg)  

Des données sont envoyés par l'API, l'interface Homme/Machine et différents types de messages vers l'appliance et plus précisement vers graylog pour traitement.  
Les conteneurs Graylog, MongoDB et Elasticsearch permettent le travail des logs afin d'envoyer l'information vers les volumes de Cinder:  
- Kafka stocke les tampons des messages  
- MongoDB stocke la configuration de graylog  
- ELS stocke les messages  

## L'envoi de la donnée vers l'outils

Le schéma ci-dessous représente la sauvegarde et la restauration des données vers l'application:  

![alt tag](./sauvegarde-restauration.svg)  

Les échanges entre graylog et graylog-recovery ainsi qu'entres graylog-recovery et swift se font en webservices.  
Cron est un outils qui permet de faire des taches planifiés. Ici, il s’occupe de lancer graylog-recovery régulièrement  


## L'envoi de la données vers l'appliance

Le schéma montre comment les informations sont envoyés de l’instance Applicative vers l’appliance graylog:  
![alt tag](./instance-applicative.svg)

Soit l’application possède un support natif de l’envoi des logs (ex : RSYSLOG, Application JAVA/SPRINGBOOT, application PHP/DRUPAL),  
L'envoi se fait directement vers l’appliance.  

Soit l’application ne possède pas de support natif:  
L’application est alors installé dans un conteneur. Une sortie console vers des moteurs de conteneurs permet l’envoi vers l’appliance Graylog.  








