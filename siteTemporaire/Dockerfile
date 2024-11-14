FROM php:8.2-apache

# PHP et Apache configuration
RUN a2enmod rewrite
RUN service apache2 restart

# Installer les extensions PHP nécessaires pour MySQL
RUN docker-php-ext-install pdo pdo_mysql

# Installation du serveur SSH
RUN apt-get update && apt-get install -y openssh-server sudo

# Créer un répertoire pour le serveur SSH
RUN mkdir /var/run/sshd

# Ajouter un utilisateur pour SSH et lui attribuer des permissions
RUN useradd -m -d /home/devuser -s /bin/bash devuser && \
    echo 'devuser:test' | chpasswd && \
    adduser devuser sudo

# Configurer SSH pour permettre l'accès root (optionnel : à désactiver en production)
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# Exposer les ports pour HTTP et SSH
EXPOSE 80 22

# Lancer Apache et SSH au démarrage du conteneur
CMD service apache2 start && /usr/sbin/sshd -D
