FROM composer:2 as builder

WORKDIR /app

RUN composer create-project --prefer-dist yiisoft/yii2-app-basic .

FROM php:8.2-apache

RUN apt-get update && apt-get install -y libzip-dev unzip zip git curl libpng-dev \
    && docker-php-ext-install pdo pdo_mysql zip gd

COPY --from=builder /app /var/www/html

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/web|' /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

EXPOSE 80

CMD ["apache2-foreground"]
