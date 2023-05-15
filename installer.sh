 sudo apt-get update
 sudo apt-get -y install lsb-release
 sudo apt-get -y install apt-utils
 sudo apt-get -y install python
 sudo apt-get install -y libmysqlclient-dev
 sudo apt-get -y install rsync
 sudo apt-get -y install curl
 sudo apt-get -y install libnss3-dev
 sudo apt-get -y install openssh-client
 sudo apt-get -y install mc
 sudo apt install -y software-properties-common
 sudo apt-get -y install gcc make autoconf libc-dev pkg-config
 sudo apt-get -y install libmcrypt-dev
 sudo mkdir -p /tmp/pear/cache
 sudo mkdir -p /etc/bash_completion.d/cargo
 sudo apt install -y php-dev
 sudo apt install -y php-pear
 sudo apt-get -y install dialog

#Install php-fpm7.4
 sudo apt-get update \
    && sudo apt-get install -y curl zip unzip git software-properties-common supervisor sqlite3 \
    && sudo add-apt-repository -y ppa:ondrej/php \
    && sudo apt-get update \
    && sudo apt-get install -y php7.4-dev php7.4-fpm php7.4-common php7.4-cli php7.4-imagick php7.4-gd php7.4-mysql php7.4-pgsql php7.4-imap php-memcached php7.4-mbstring php7.4-xml php7.4-xmlrpc php7.4-soap php7.4-zip php7.4-curl php7.4-bcmath php7.4-sqlite3 php7.4-apcu php7.4-apcu-bc php7.4-intl php-dev php7.4-dev php7.4-xdebug php-redis \
    && sudo php -r "readfile('http://getcomposer.org/installer');" | sudo php -- --install-dir=/usr/bin/ --version=1.10.16 --filename=composer \
    && sudo mkdir //php \
    && sudo chown nemke82:nemke82 //php \
    && sudo chown -R nemke82:nemke82 /etc/php \
    && sudo apt-get remove -y --purge software-properties-common \
    && sudo apt-get -y autoremove \
    && sudo apt-get clean \
    && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && sudo update-alternatives --remove php /usr/bin/php8.0 \
    && sudo update-alternatives --remove php /usr/bin/php7.3 \
    && sudo update-alternatives --set php /usr/bin/php7.4 \
    && sudo echo "daemon off;" >> /etc/nginx/nginx.conf

#Adjust few options for xDebug and disable it by default
 echo "xdebug.remote_enable=on" >> /etc/php/7.4/mods-available/xdebug.ini
    #&& echo "xdebug.remote_autostart=on" >> /etc/php/7.4/mods-available/xdebug.ini
    #&& echo "xdebug.profiler_enable=On" >> /etc/php/7.4/mods-available/xdebug.ini \
    #&& echo "xdebug.profiler_output_dir = /workspace/magento2pitpod" >> /etc/php/7.4/mods-available/xdebug.ini \
    #&& echo "xdebug.profiler_output_name = nemanja.log >> /etc/php/7.4/mods-available/xdebug.ini \
    #&& echo "xdebug.show_error_trace=On" >> /etc/php/7.4/mods-available/xdebug.ini \
    #&& echo "xdebug.show_exception_trace=On" >> /etc/php/7.4/mods-available/xdebug.ini
 mv /etc/php/7.4/cli/conf.d/20-xdebug.ini /etc/php/7.4/cli/conf.d/20-xdebug.ini-bak
 mv /etc/php/7.4/fpm/conf.d/20-xdebug.ini /etc/php/7.4/fpm/conf.d/20-xdebug.ini-bak

# Install MySQL
ENV PERCONA_MAJOR 5.7
 sudo apt-get update \
 && sudo apt-get -y install gnupg2 \
 && sudo apt-get clean && sudo rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/* \
 && sudo mkdir /var//mysqld \
 && sudo wget -c https://repo.percona.com/apt/percona-release_latest.stretch_all.deb \
 && sudo dpkg -i percona-release_latest.stretch_all.deb \
 && sudo apt-get update

 set -ex; \
	{ \
		for key in \
			percona-server-server/root_password \
			percona-server-server/root_password_again \
			"percona-server-server-$PERCONA_MAJOR/root-pass" \
			"percona-server-server-$PERCONA_MAJOR/re-root-pass" \
		; do \
			sudo echo "percona-server-server-$PERCONA_MAJOR" "$key" password 'nem4540'; \
		done; \
	} | sudo debconf-set-selections; \
	sudo apt-get update; \
	sudo apt-get install -y \
		percona-server-server-5.7 percona-server-client-5.7 percona-server-common-5.7 \
	;
	
 sudo chown -R nemke82:nemke82 /etc/mysql /var//mysqld /var/log/mysql /var/lib/mysql /var/lib/mysql-files /var/lib/mysql-keyring

# Install our own MySQL config
cp mysql.cnf /etc/mysql/conf.d/mysqld.cnf
cp mysql.conf /etc/supervisor/conf.d/mysql.conf
sudo chown nemke82:nemke82 /home/nemke82/.my.cnf

# Install default-login for MySQL clients
cp client.cnf /etc/mysql/conf.d/client.cnf

#Copy nginx default and php-fpm.conf file
#COPY default /etc/nginx/sites-available/default
cp php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf
cp sp-php-fpm.conf /etc/supervisor/conf.d/sp-php-fpm.conf
sudo chown -R nemke82:nemke82 /etc/php

cp nginx.conf /etc/nginx

#Selenium required for MFTF
 sudo wget -c https://selenium-release.storage.googleapis.com/3.141/selenium-server-standalone-3.141.59.jar
 sudo wget -c https://chromedriver.storage.googleapis.com/80.0.3987.16/chromedriver_linux64.zip
 sudo unzip chromedriver_linux64.zip

 curl -sS https://packagecloud.io/gpg.key | sudo apt-key add \
    && curl -sS https://packages.blackfire.io/gpg.key | sudo apt-key add \
    && sudo echo "deb http://packages.blackfire.io/debian any main" | sudo tee /etc/apt/sources.list.d/blackfire.list \
    && sudo apt-get update \
    && sudo apt-get install -y blackfire-agent \
    && sudo apt-get install -y blackfire-php

 \
    version=$(php -r "echo PHP_MAJOR_VERSION, PHP_MINOR_VERSION;") \
    && sudo curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/${version} \
    && sudo tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && sudo mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so

cp blackfire-agent.ini /etc/blackfire/agent
cp blackfire-php.ini /etc/php/7.4/fpm/conf.d/92-blackfire-config.ini
cp blackfire-php.ini /etc/php/7.4/cli/conf.d/92-blackfire-config.ini

#Install Tideways
 sudo apt-get update
 sudo echo 'deb http://s3-eu-west-1.amazonaws.com/tideways/packages debian main' | sudo tee /etc/apt/sources.list.d/tideways.list && \
    sudo curl -sS 'https://s3-eu-west-1.amazonaws.com/tideways/packages/EEB5E8F4.gpg' | sudo apt-key add -
 DEBIAN_FRONTEND=noninteractive sudo apt-get update && sudo apt-get install -yq tideways-daemon && \
    sudo apt-get autoremove --assume-yes && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

 sudo echo 'deb http://s3-eu-west-1.amazonaws.com/tideways/packages debian main' | sudo tee /etc/apt/sources.list.d/tideways.list && \
    sudo curl -sS 'https://s3-eu-west-1.amazonaws.com/tideways/packages/EEB5E8F4.gpg' | sudo apt-key add - && \
    sudo apt-get update && \
    DEBIAN_FRONTEND=noninteractive sudo apt-get -yq install tideways-php && \
    sudo apt-get autoremove --assume-yes && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

 echo 'extension=tideways.so\ntideways.connection=tcp://0.0.0.0:9135\ntideways.api_key=${TIDEWAYS_APIKEY}\n' > /etc/php/7.4/cli/conf.d/40-tideways.ini
 echo 'extension=tideways.so\ntideways.connection=tcp://0.0.0.0:9135\ntideways.api_key=${TIDEWAYS_APIKEY}\n' > /etc/php/7.4/fpm/conf.d/40-tideways.ini
 sudo rm -f /etc/php/7.4/cli/20-tideways.ini

# Install Redis.
 sudo apt-get update \
 && sudo apt-get install -y \
  redis-server \
 && sudo rm -rf /var/lib/apt/lists/*
 
 #n98-mage2 tool.
  wget https://files.magerun.net/n98-magerun2.phar \
     && chmod a+rwx ./n98-magerun2.phar \
     && sudo mv ./n98-magerun2.phar /usr/local/bin/n98-magerun2
     
#Install APCU
 echo "apc.enable_cli=1" > /etc/php/7.4/cli/conf.d/20-apcu.ini
 echo "priority=25" > /etc/php/7.4/cli/conf.d/25-apcu_bc.ini
 echo "extension=apcu.so" >> /etc/php/7.4/cli/conf.d/25-apcu_bc.ini
 echo "extension=apc.so" >> /etc/php/7.4/cli/conf.d/25-apcu_bc.ini

 sudo chown -R nemke82:nemke82 /var/log/blackfire
 sudo chown -R nemke82:nemke82 /etc/init.d/blackfire-agent
 sudo mkdir -p /var//blackfire
 sudo chown -R nemke82:nemke82 /var//blackfire
 sudo chown -R nemke82:nemke82 /etc/blackfire
 sudo chown -R nemke82:nemke82 /etc/php
 sudo chown -R nemke82:nemke82 /etc/nginx
 sudo chown -R nemke82:nemke82 /etc/init.d/
 sudo chown -R nemke82:nemke82 /run/mysqld/
 sudo chown nemke82:nemke82 /home/nemke82/.bashrc
 sudo rm -f /etc/mysql/percona-server.conf.d/*.cnf
 sudo echo "net.core.somaxconn=65536" | sudo tee /etc/sysctl.conf

#New Relic
 \
  wget -O - https://download.newrelic.com/548C16BF.gpg | apt-key add - \
  && echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list \
  && apt-get update && apt-get install -y newrelic-php5; 
  sudo NR_INSTALL_USE_CP_NOT_LN=1 NR_INSTALL_SILENT=1 /tmp/newrelic-php5-*/newrelic-install install && \
  sudo rm -rf /tmp/newrelic-php5-* /tmp/nrinstall* && \
  sudo touch /etc/php/7.4/fpm/conf.d/newrelic.ini && \
  sudo touch /etc/php/7.4/cli/conf.d/newrelic.ini && \
  sudo sed -i \
      -e 's/"REPLACE_WITH_REAL_KEY"/"ba052d5cdafbbce81ed22048d8a004dd285aNRAL"/' \
      -e 's/newrelic.appname = "PHP Application"/newrelic.appname = "magento2nemke82"/' \
      -e 's/;newrelic.daemon.app_connect_timeout =.*/newrelic.daemon.app_connect_timeout=15s/' \
      -e 's/;newrelic.daemon.start_timeout =.*/newrelic.daemon.start_timeout=5s/' \
      /etc/php/7.4/cli/conf.d/newrelic.ini && \
  sudo sed -i \
      -e 's/"REPLACE_WITH_REAL_KEY"/"ba052d5cdafbbce81ed22048d8a004dd285aNRAL"/' \
      -e 's/newrelic.appname = "PHP Application"/newrelic.appname = "magento2nemke82"/' \
      -e 's/;newrelic.daemon.app_connect_timeout =.*/newrelic.daemon.app_connect_timeout=15s/' \
      -e 's/;newrelic.daemon.start_timeout =.*/newrelic.daemon.start_timeout=5s/' \
      /etc/php/7.4/fpm/conf.d/newrelic.ini && \
  sudo sed -i 's|/var/log/newrelic/|/tmp/|g' /etc/php/7.4/fpm/conf.d/newrelic.ini && \
  sudo sed -i 's|/var/log/newrelic/|/tmp/|g' /etc/php/7.4/cli/conf.d/newrelic.ini
     
 sudo chown -R nemke82:nemke82 /etc/php
 sudo chown -R nemke82:nemke82 /etc/newrelic
cp newrelic.cfg /etc/newrelic
 sudo rm -f /usr/bin/php
 sudo ln -s /usr/bin/php7.4 /usr/bin/php

# nvm environment variables
 sudo mkdir -p /usr/local/nvm
 sudo chown nemke82:nemke82 /usr/local/nvm
export NVM_DIR=/usr/local/nvm
export NODE_VERSION=14.17.3

# Replace shell with bash so we can source files
 sudo rm /bin/sh && sudo ln -s /bin/bash /bin/sh

# install nvm
# https://github.com/creationix/nvm#install-script
 curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# install node and npm, set default alias
 source $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default

# add node and npm to path so the commands are available
export NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules
export PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
    
 curl https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.16.tar.gz --output elasticsearch-5.6.16.tar.gz \
    && tar -xzf elasticsearch-5.6.16.tar.gz
export ES_HOME56="$HOME/elasticsearch-5.6.16"

 curl https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.8.9.tar.gz --output elasticsearch-6.8.9.tar.gz \
    && tar -xzf elasticsearch-6.8.9.tar.gz
export ES_HOME68="$HOME/elasticsearch-6.8.9"

 curl https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.9.3-linux-x86_64.tar.gz --output elasticsearch-7.9.3-linux-x86_64.tar.gz \
    && tar -xzf elasticsearch-7.9.3-linux-x86_64.tar.gz
export ES_HOME79="$HOME/elasticsearch-7.9.3"
sudo chown -R nemke82:nemke82 /home/nemke82/elasticsearch-*

cp sp-elasticsearch.conf /etc/supervisor/conf.d/elasticsearch.conf

sudo apt-get update && sudo apt-get upgrade -y \
    && sudo apt-key adv --keyserver "hkps://keys.openpgp.org" --recv-keys "0x0A9AF2115F4687BD29803A206B73A36E6026DFCA" \
    && sudo apt-key adv --keyserver "keyserver.ubuntu.com" --recv-keys "F77F1EDA57EBB1CC" \
    && curl -1sLf 'https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey' | apt-key add - \
    && echo 'deb https://packagecloud.io/rabbitmq/rabbitmq-server/debian/ buster main' | tee /etc/apt/sources.list.d/rabbitmq.list \
    && echo 'deb-src https://packagecloud.io/rabbitmq/rabbitmq-server/debian/ buster main' | tee /etc/apt/sources.list.d/rabbitmq.list \
    && sudo apt-get update -y \
    && sudo apt-get install -y erlang-base \
       erlang-asn1 erlang-crypto erlang-eldap erlang-ftp erlang-inets \
       erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key \
       erlang-snmp erlang-ssl \
       erlang-syntax-tools erlang-tftp erlang-tools erlang-xmerl

## Install rabbitmq-server and its dependencies
sudo apt-get install rabbitmq-server -y --fix-missing

cp lighthouse.conf /etc
cp rabbitmq.conf /etc/rabbitmq/rabbitmq.conf
