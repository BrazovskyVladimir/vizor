#!/bin/bash

# Функция для установки пакетов
install_packages() {
  apt-get update
  apt-get -y install apache2 mysql-server php nginx curl
}

# Функция для настройки MySQL
configure_mysql() {
  echo -e "n\ny\ny\ny\ny" | mysql_secure_installation
}

# Функция для настройки Apache
configure_apache() {
    systemctl enable apache2
    systemctl start apache2
    curl -O -L https://raw.githubusercontent.com/BrazovskyVladimir/vizor/main/wordpress.conf
    cp ./wordpress.conf /etc/apache2/sites-available/wordpress.conf
    a2ensite wordpress
    a2enmod rewrite
    a2dissite 000-default
}

# Функция для установки и настройки WordPress
install_wordpress() {
  # Скачиваем и распаковываем WordPress
  wget https://wordpress.org/latest.tar.gz
  tar -xzvf latest.tar.gz -C /var/www/html/
  mv /var/www/html/wordpress /var/www/html/testforvizor

  # Создаем базу данных для WordPress
  mysql -e "CREATE DATABASE wordpress;"
  mysql -e "CREATE USER 'wp_user'@'localhost' IDENTIFIED BY 'Floacd123!@';"
  mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost';"
  mysql -e "FLUSH PRIVILEGES;"

  # Настройка файла wp-config.php
  cp /var/www/html/testforvizor/wp-config-sample.php /var/www/html/testforvizor/wp-config.php
  sed -i 's/database_name_here/wordpress/' /var/www/html/testforvizor/wp-config.php
  sed -i 's/username_here/wp_user/' /var/www/html/testforvizor/wp-config.php
  sed -i 's/password_here/Floacd123!@/' /var/www/html/testforvizor/wp-config.php
}

# Функция для настройки Nginx в качестве прокси
configure_nginx() {
    systemctl enable nginx
    systemctl start nginx
  # Создание конфигурационного файла для Nginx
    curl -O -L https://raw.githubusercontent.com/BrazovskyVladimir/vizor/main/wordpress
    cp ./wordpress /etc/nginx/sites-available/wordpress

  # Создание символической ссылки
    ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/

  # Перезапуск Nginx
    systemctl restart nginx
}

# Вызываем функции по очереди для установки и настройки компонентов с проверками на существующее
install_packages
configure_mysql
if systemctl is-active --quiet apache2; then
    echo "Сервис apache2 запущен."
else
    configure_apache
fi

wordpress_directory="/var/www/html/testforvizor"

if [ -d "$wordpress_directory" ]; then
    echo "WordPress установлен в $wordpress_directory"
else
    install_wordpress
fi

wordpress_nginx_file="/etc/nginx/sites-available/wordpress"

if [ -f "$wordpress_nginx_file" ]; then
    echo "Сервис nginx запущен."
else
    configure_nginx
    BOT_TOKEN="****"
    CHAT_ID="****"
    MESSAGE="Something installed and maybe is working"

    # Отправка сообщения через Telegram Bot API
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$CHAT_ID" -d "text=$MESSAGE"
fi
