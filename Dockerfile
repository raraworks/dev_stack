FROM nginx:stable
#General bringing up  to date and prerequisites
RUN apt-get update && apt-get upgrade -y && apt-get install -y wget lsb-release && rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Riga /etc/localtime \
#add up to date php PPA, and retrieve latest stable php with required extensions that are not bundled with it
&& wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
&& echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list \
&& apt-get update && apt-get install -y \
php-fpm \
php-mbstring \
php-imagick \
php-zip \
php-xml \
php-curl \
php-intl \
php-pgsql \
php-mysql \
php-xdebug \
#add www-data group to nginx user so that nginx has access to php-fpm pool
&& usermod -aG www-data nginx \
# Installing composer and its prerequisites globally
&& php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php &&  php -r "unlink('composer-setup.php');" && mv composer.phar /usr/local/bin/composer \
&& composer global require hirak/prestissimo \
# Installing node and npm and its prerequisites
&& apt-get install -y build-essential \
&& curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs

COPY startup_script.sh ./
RUN chmod a+x startup_script.sh

CMD ./startup_script.sh
