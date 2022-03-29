FROM nginx:stable
#General bringing up  to date and prerequisites
RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y wget lsb-release vim unzip git cron build-essential \
  && rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Europe/Riga /etc/localtime \
#add up to date php PPA, and retrieve latest stable php with required extensions that are not bundled with it
  && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
  && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list \
  && apt-get update \
  && apt-get install -y \
    php8.0-fpm \
    php8.0-mbstring \
    php8.0-imagick \
    php8.0-gd \
    php8.0-zip \
    php8.0-xml \
    php8.0-curl \
    php8.0-intl \
    php8.0-pgsql \
    php8.0-mysql \
    php8.0-xdebug \
#add www-data group to nginx user so that nginx has access to php-fpm pool
  && usermod -aG www-data nginx \
# Installing composer and its prerequisites globally
  && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php composer-setup.php --2 \
  && php -r "unlink('composer-setup.php');" \
  && mv composer.phar /usr/local/bin/composer \
# Installing node and npm and its prerequisites
  && curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
  && apt-get install -y nodejs \
  && npm i -g npm@latest \
# Installing yarn
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install yarn
COPY php.ini /etc/php/8.0/fpm/php.ini
COPY startup_script.sh ./
RUN chmod a+x startup_script.sh
CMD ./startup_script.sh
