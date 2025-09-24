# Projet CloudDevOps

Le but de ce projet est d'utiliser Docker, Github Actions, Terraform et AWS

## Étape 1 : récupération d'un projet Git et dockerisation

La première étape de ce projet est le choix de l'application et la mise en place du répertoire Git.
J'ai axé ma recherche sur un projet de site ecommerce (avec front et base de données), codé en python (language que je maitrise suffisement).

Mon choix s'est arrété sur le projet de ### qui respecte tous les critères. De plus, l'application est Dockeurisée et se lance avec une simple Docker-compose up, ce qui m'évite de devoir reprendre entièrement le projet pour le mettre en format d'image docker.

Une fois le projet fork et le répertoire git en place, j'ai organisé la hiérarchie afin de prendre au plus tôt en compte la structure finale.

## Étape 2 : Mise en place du pipeline de test GitHub Actions

La structure du pipeline se découpe en 4 parties afin de faciliter la lisibilité du projet : CI, security, release et deploy

CI : mets en place le projet, télécharge les dépendances et effetue les tests de linting et de formatage du code à l'aide de Black et flake8

security : effectue les tests de sécurité sur l'application à l'aide de SonarCube (SAST), safety (SCA), Trivy fs et Trivy image.

release : build l'image et la push sur DockerHub avec les tags associés

deploy : modifie le manifest Kubernetes afin de déclencher le hook d'ArgoCD pour la rotation automatique des nodes du cluster

## Étape 3 : Automatisation de l'infrastructure avec Terraform

Avant de passer à l'écriture des manifests kubernetes, j'ai choisit d'automatiser l'infrastructure afin de pouvoir rapiement mettre en place un cluster EKS pour effectuer les tests mais également pour pouvoir détruire le cluster entre chaque session de travail afin d'économiser les coûts AWS.

Mon projet Terraform est séparé en 4 modules : eks, network, server et GithubActions
Il permet de rapidement et de manière automatiser, créer un cluster EKS avec les rôles associés afin de déployer notre application.

## Étape 4 : Création des manifests kubernetes

La première tâche est de définir précisément l'architecture du cluster.

le projet se découpe simplement en 2 pods. Un pod applicative et un pod postgres.
2 services : un clusterIp pour la base de données et un LoadBalancer pour le pod applicatif
1 Volume persistant pour la base de données postgress
1 fichier secret pour stocker les mots de passes (solution non sécurisé mais adoptée pour sa simplicité)

Une fois cette architecture définie, sont mis en place les manifests Kubernetes, découpés en 6 fichiers : namespace, configmap, secrets, service, postgress_volume et deployment

## Étape 5: Test des manifests sur le cluster EKS

## Étape 6: Automatisation de la mise à jour du cluster à l'aide d'ArgoCD

## Étape 7: Ajout de la partie monitoring à l'aide de Prometheus et Grafana