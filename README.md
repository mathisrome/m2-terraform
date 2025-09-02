# 🚀 Infrastructure Terraform - Cluster Kubernetes avec WordPress

Ce projet Terraform déploie une infrastructure complète sur Scaleway comprenant un cluster Kubernetes avec WordPress, un load balancer, et une configuration DNS automatisée.

## 📋 Table des matières

- [Vue d'ensemble](#vue-densemble)
- [Architecture](#architecture)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Configuration](#configuration)
- [Déploiement](#déploiement)
- [Structure du projet](#structure-du-projet)
- [Variables et personnalisation](#variables-et-personnalisation)
- [Maintenance](#maintenance)
- [Dépannage](#dépannage)
- [Contributions](#contributions)

## 🎯 Vue d'ensemble

Ce projet automatise le déploiement d'une infrastructure cloud complète sur Scaleway :

- **VPC** avec réseau privé et passerelle publique
- **Cluster Kubernetes** version 1.32.3 avec CNI Cilium
- **Load Balancer** avec Nginx Ingress Controller
- **Certificats SSL** automatiques via Let's Encrypt
- **WordPress** déployé via Helm avec base de données MariaDB
- **Configuration DNS** automatique

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        SCALEWAY                             │
├─────────────────────────────────────────────────────────────┤
│  VPC (grp-4-kubernetes-vpc)                                 │
│  ├── Réseau privé (grp-4-private-network)                   │
│  ├── Passerelle publique (grp-4-gateway)                    │
│  └── Load Balancer IP                                       │
├─────────────────────────────────────────────────────────────┤
│  Cluster Kubernetes (grp-4)                                 │
│  ├── Pool de nœuds (DEV1-M, autoscaling)                    │
│  ├── Nginx Ingress Controller                               │
│  ├── Cert-Manager (Let's Encrypt)                           │
│  └── WordPress + MariaDB                                    │
├─────────────────────────────────────────────────────────────┤
│  DNS: grp-4.esgi.slashops.fr                                │
└─────────────────────────────────────────────────────────────┘
```

## ✅ Prérequis

### Outils requis
- **Terraform** version 1.13.1 ou supérieure
- **kubectl** pour interagir avec le cluster
- **helm** version 3.0.2 ou supérieure

### Compte Scaleway
- Compte Scaleway actif
- Project ID configuré
- Accès aux services Kubernetes et Load Balancer
- Zone DNS configurée

### Variables d'environnement
```bash
export SCW_ACCESS_KEY="votre_access_key"
export SCW_SECRET_KEY="votre_secret_key"
export SCW_DEFAULT_PROJECT_ID="af37e4fc-e172-4e7b-807d-932ea1afe8dd"
```

## 🚀 Installation

### 1. Cloner le projet
```bash
git clone <repository-url>
cd m2-terraform
```

### 2. Initialiser Terraform
```bash
terraform init
```

### 3. Vérifier la planification
```bash
terraform plan
```

### 4. Déployer l'infrastructure
```bash
terraform apply
```

## ⚙️ Configuration

### Configuration des providers

Le projet utilise trois providers principaux :

- **Scaleway** : Infrastructure cloud (VPC, Kubernetes, Load Balancer)
- **Helm** : Déploiement des applications Kubernetes
- **Kubernetes** : Gestion des ressources Kubernetes

### Configuration du cluster

- **Version Kubernetes** : 1.32.3
- **CNI** : Cilium
- **Type de nœud** : DEV1-M
- **Autoscaling** : Activé
- **Autohealing** : Activé

### Configuration WordPress

- **Username** : admin
- **Password** : SecurePassword123!
- **Email** : admin@grp-4.esgi.slashops.fr
- **Base de données** : MariaDB avec persistance
- **Stockage** : 10Gi pour WordPress, 8Gi pour MariaDB

## 🚀 Déploiement

### Déploiement complet
```bash
# Déployer toute l'infrastructure
terraform apply -auto-approve
```

### Déploiement par composant
```bash
# Déployer uniquement la VPC
terraform apply -target=scaleway_vpc.main

# Déployer le cluster Kubernetes
terraform apply -target=scaleway_k8s_cluster.cluster

# Déployer WordPress
terraform apply -target=helm_release.wordpress
```

### Vérification du déploiement
```bash
# Vérifier l'état des ressources
terraform show

# Vérifier le cluster Kubernetes
kubectl get nodes
kubectl get pods -n kube-system

# Vérifier les services
kubectl get services -n kube-system
```

## 📁 Structure du projet

```
m2-terraform/
├── README.md                
├── provider.tf              # Configuration des providers
├── vpc.tf                   # Configuration VPC et réseau
├── cluster.tf               # Cluster Kubernetes
├── lb.tf                    # Load Balancer et Ingress
├── dns.tf                   # Configuration DNS
├── wp.tf                    # Déploiement WordPress
├── terraform.tfstate        # État Terraform (généré)
└── terraform.tfstate.backup # Sauvegarde de l'état (généré)
```

## 🔧 Variables et personnalisation

### Personnalisation du cluster
Modifiez `cluster.tf` pour changer :
- Nom du cluster
- Version Kubernetes
- Type et nombre de nœuds
- Configuration du pool

### Personnalisation de WordPress
Modifiez `wp.tf` pour changer :
- Identifiants d'administration
- Ressources allouées
- Configuration de la base de données
- Paramètres de persistance

### Personnalisation DNS
Modifiez `dns.tf` pour changer :
- Domaine principal
- Sous-domaine
- Configuration des enregistrements

## 🛠️ Maintenance

### Mise à jour des composants
```bash
# Mettre à jour Terraform
terraform init -upgrade

# Vérifier les mises à jour disponibles
terraform plan
```

### Sauvegarde de l'état
```bash
# Créer une sauvegarde
terraform state pull > backup-$(date +%Y%m%d-%H%M%S).tfstate
```

### Nettoyage des ressources
```bash
# Détruire l'infrastructure
terraform destroy -auto-approve
```

## 🔍 Dépannage

### Problèmes courants

#### Cluster ne démarre pas
```bash
# Vérifier l'état du cluster
terraform show -json | jq '.values.root_module.resources[] | select(.type == "scaleway_k8s_cluster")'

# Vérifier les logs
kubectl logs -n kube-system
```

#### WordPress inaccessible
```bash
# Vérifier les pods WordPress
kubectl get pods -n kube-system -l app.kubernetes.io/name=wordpress

# Vérifier les services
kubectl get services -n kube-system

# Vérifier les ingress
kubectl get ingress -n kube-system
```

#### Problèmes de certificats
```bash
# Vérifier cert-manager
kubectl get pods -n kube-system -l app=cert-manager

# Vérifier les certificats
kubectl get certificates -n kube-system
```

### Logs et monitoring
```bash
# Logs du cluster
kubectl logs -n kube-system

# Métriques des nœuds
kubectl top nodes

# Métriques des pods
kubectl top pods -n kube-system
```

