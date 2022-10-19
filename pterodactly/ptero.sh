#!/bin/bash
## Maintenance Mode 
echo "Maintenance Mode"
cd /var/www/pterodactyl
php artisan down
### Download Update
echo "Download Update"
curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv
chmod -R 755 storage/* bootstrap/cache
### Update Dependencies
echo "Update Dependencies"
composer install --no-dev --optimize-autoloader
### Clear Cache 
echo "Clear Cache"
php artisan view:clear
php artisan view:clear
### Database Updates 
echo "Database Updates"
php artisan migrate --seed --force
### Permissions 
echo "Permissions"
chown -R www-data:www-data /var/www/pterodactyl/*
### Restarting Queue Workers
echo "Restarting Queue Workers"
php artisan queue:restart 
### End Maintenance Mode
echo "Download Update"
php artisan up 



### Updating Wings 
echo "Updating wings"
systemctl stop wings
curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_$([[ "$(uname -m)" == "x86_64" ]] && echo "amd64" || echo "arm64")"
chmod u+x /usr/local/bin/wings