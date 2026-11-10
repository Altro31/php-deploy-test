# Imagen oficial de WordPress con PHP 8.2 y Apache
FROM wordpress:php8.2-apache

# Evitar preguntas interactivas durante la instalación de paquetes
ENV DEBIAN_FRONTEND=noninteractive

# Instalar utilidades y extensiones de PHP útiles para WordPress
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip \
    && rm -rf /var/lib/apt/lists/*

# Habilitar mod_rewrite de Apache (requerido por los permalinks de WordPress)
RUN a2enmod rewrite

# Ajustar permisos para que www-data pueda escribir en wp-content
RUN chown -R www-data:www-data /var/www/html/wp-content \
    && chmod -R 755 /var/www/html/wp-content

# Puerto que expone Apache dentro del contenedor
EXPOSE 80

# Healthcheck para que Render (u otro orquestador) sepa si el contenedor está sano
HEALTHCHECK --interval=30s --timeout=3s --start-period=15s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Comando por defecto de la imagen oficial de WordPress
CMD ["apache2-foreground"]
