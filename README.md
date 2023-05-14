# magento2 coder
Magento 2 optimized setup for creating Template in https://coder.com/ based on Docker  -- Nginx, MySQL (switch to Percona MySQL 8.x available in the menu), PHP 7.4 (older and newer versions available in the menu), PHP-FPM, and a lot more...

Requirements:
- https://coder.com/service installed -- check: https://coder.com/docs/v2/latest/install/install.sh
- Docker CE installed on the same node

*How-to instructions:*
1) Register on https://gitpod.io 
2) Fork https://github.com/nemke82/magento2coder to your repo
3) Create fresh Docker image based on Dockerfile from repo or start fresh Docker container, push installer.sh file and create locally based docker image of that commit

Services/Tools installed:
- **Nginx**
- **PHP 7.4** based on ppa:ondrej/php repo (https://launchpad.net/~ondrej/+archive/ubuntu/php). To add additional PHP extensions, please update Dockerfile block. (older and newer versions available in the menu)
- **Python** (base version)
- **rsync**
- **mc** (Midnight commander)
- **MySQL** (Percona) 5.7 version default. (switch to Percona MySQL 8.x available in the menu)
- **xDebug** (latest Magento 2 supported version 3). From menu area select "Start X-Debug" and wait for confirmation. Enables CLI and PHP together.
- **Blackfire**. Note: Please run **./blackfire-run.sh** to enter your Server/Client ID and Token's. Sometimes it requires extra PHP-FPM restart, so please run service php7.2-fpm restart if required.
- **Tideways**. Note: Please run **/usr/bin/tideways-daemon --address 0.0.0.0:9135 &** to initiate daemon. Please update .env-file located in repo with TIDEWAYS_APIKEY
- **Newrelic**. Note: Please run **newrelic-daemon -c /etc/newrelic/newrelic.cfg** to initiate daemon. Please update .Dockerfile with license key. Requires Fresh M2 installation (run m2install.sh) or your store to finish process of validation. <BR>
- **Redis**. Note: Please run 'redis-server &' to start it or run it without & in the separate tab.
- **NodeJS/NPM NVM Manager**. Note: run nvm ls-remote to list available versions, then nvm install to install specific version or latest. 
- **ElasticSearch 5.6.16**. Note: Please run following command to start it: <BR>
  '$ES_HOME56/bin/elasticsearch -d -p $ES_HOME56/pid -Ediscovery.type=single-node' <BR>
- **ElasticSearch 6.8.9**. Note: Please run following command to start it: <BR>
  '$ES_HOME68/bin/elasticsearch -d -p $ES_HOME68/pid -Ediscovery.type=single-node' <BR>
- **ElasticSearch 7.9.3**. Note: Please run following command to start it: <BR>
  '$ES_HOME79/bin/elasticsearch -d -p $ES_HOME79/pid -Ediscovery.type=single-node' <BR>
  
  Some extensions like ElasticSuite (https://github.com/Smile-SA/elasticsuite/wiki/ServerConfig-5.x) requires two ElasticSearch plugins to be installed. You can install them with the following commands:<BR>
  
  $ES_HOME/bin/elasticsearch-plugin install analysis-phonetic <BR>
  $ES_HOME/bin/elasticsearch-plugin install analysis-icu <BR>


- **MFTF (Magento 2 Multi Functional Testing Framework)** 
Follow https://github.com/magento/magento2-functional-testing-framework/blob/develop/docs/getting-started.md guidelines.
Installer is here: **chmod a+rwx m2-install-solo.sh && bash m2-install-solo.sh**

Note: Please run following command to start Selenium and Chromedriver (as required):

java -Dwebdriver.chrome.driver=chromedriver -jar $HOME/selenium-server-standalone-3.141.59.jar & <BR>
$HOME/chromedriver & <BR>

Every listed service installation code is added within .gitpod.Dockerfile
You can split them into separate workspaces and share it among themself if you know what you are doing.

- **RabbitMQ support**
default username/password: guest/guest <BR>
For browser open 15762 browser (already exposed) <BR>
Rest commands can be used as per RabbitMQ guidelines https://www.rabbitmq.com/cli.html
  
- **PWA Studio Support**
To start installation select field from menu.sh <BR>
or run manually with following command: bash /home/nemke82/pwa-studio-installer.sh <BR>
Start service: <BR>
bash /home/nemke82/pwa/start.sh &

TO INSTALL Magento 2.4.6 (latest): <BR>
**./m2-install.sh**

For Magento 2.4-dev branch replicated from https://github.com/magento/magento2 please run: <BR>
**m2-install-solo.sh**

MySQL (default settings):
username: root <BR>
password: nem4540 <BR>

In case you need to create additional database: <BR>
mysql -e 'create database nemanja;' <BR>
(where "nemanja" is database name used) <BR>

**Discovered bugs:**
Sometimes it may happen that the exposed port 8002 used for Nginx does not work when tab is loaded in browser. To fix that, either stop/start workspace or destroy it and start process again. <BR>

If you are moving your own installation don't foget to adjust following cookie paths: <BR>
**web/cookie/path to "/"** <BR>
**web/cookie/domain to ".coder.app"** <BR>
**web/secure/offloader_header to "X-Forwarded-Proto"** <BR>


**Changelog 2023-05-14:**
- Initial version with brief explanations on how-to