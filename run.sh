#!/bin/bash

echo 'loading config files'

export TERM=cygwin

if [ -f /share/#/docker/.bashrc ];
then
    rm /root/.bashrc
    ln -sf /share/#/docker/.bashrc /root/.bashrc
    echo '/share/#/docker/.bashrc linked to ~/.bashrc'
else
    echo '/share/#/docker/.bashrc not found'
    cp /root/.bashrc /share/#/docker/.bashrc
    rm /root/.bashrc
    ln -sf /share/#/docker/.bashrc /root/.bashrc
    echo '/share/#/docker/.bashrc copied and linked to ~/.bashrc'
fi

if [ -f /share/#/docker/.vimrc ];
then
    rm /root/.vimrc
    ln -sf /share/#/docker/.vimrc /root/.vimrc
    echo '/share/#/docker/.vimrc linked to ~/.vimrc'
else
    echo '/share/#/docker/.vimrc not found'
    if [ -f /root/.vimrc ];
    then
        cp /root/.vimrc /share/#/docker/.vimrc
        rm /root/.vimrc
        ln -sf /share/#/docker/.vimrc /root/.vimrc
        echo '/share/#/docker/.vimrc copied and linked to ~/.vimrc'
    else
        echo 'set number' > /share/#/docker/.vimrc
        ln -sf /share/#/docker/.vimrc /root/.vimrc
        echo 'created /share/#/docker/.vimrc and linked to ~/.vimrc'
    fi
fi

if [ -f /share/#/docker/vhosts.conf ];
then
    rm /etc/apache2/sites-enabled/000-default.conf
    ln -sf /share/#/docker/vhosts.conf /etc/apache2/sites-enabled/vhosts.conf
    echo '/share/#/docker/vhosts.conf linked to /etc/apache2/sites-enabled/vhosts.conf'
else
    echo '/share/#/docker/vhosts.conf not found'
    cp /etc/apache2/sites-enabled/000-default.conf /share/#/docker/vhosts.conf
    rm /etc/apache2/sites-enabled/000-default.conf
    ln -sf /share/#/docker/vhosts.conf /etc/apache2/sites-enabled/vhosts.conf
    echo '/share/#/docker/vhosts.conf copied and linked to /etc/apache2/sites-enabled/vhosts.conf'
fi

if [ -f /share/#/docker/php.ini ];
then
    rm /etc/php5/apache2/php.ini
    # rm /etc/php5/cli/php.ini
    ln -sf /share/#/docker/php.ini /etc/php5/apache2/php.ini
    # cp /share/#/docker/php.ini /etc/php5/cli/php.ini
    echo '/share/#/docker/php.ini linked to etc/php5/apache2/php.ini'
else
    echo '/share/#/docker/php.ini not found'
    cp /etc/php5/apache2/php.ini /share/#/docker/php.ini
    rm /etc/php5/apache2/php.ini
    ln -sf /share/#/docker/php.ini /etc/php5/apache2/php.ini
    echo '/share/#/docker/php.ini copied and linked to /etc/php5/apache2/php.ini'
fi

if [ -f /share/#/docker/apache2.conf ];
then
    rm /etc/apache2/apache2.conf
    ln -sf /share/#/docker/apache2.conf /etc/apache2/apache2.conf
    echo '/share/#/docker/apache2.conf linked to /etc/apache2/apache2.conf'
else
    echo '/share/#/docker/apache2.conf not found'
    cp /etc/apache2/apache2.conf /share/#/docker/apache2.conf
    rm /etc/apache2/apache2.conf
    ln -sf /share/#/docker/apache2.conf /etc/apache2/apache2.conf
    echo '/share/#/docker/apache2.conf copied and linked to /etc/apache2/apache2.conf'
fi

source /etc/apache2/envvars

sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

a2enmod php5
a2enmod rewrite
a2enmod ssl
a2enmod headers

if [ ! -z "$LN" ]; then
    echo "Creating a link: /share/ /var/www/$LN"
    ln -sf  /share/ /var/www/$LN
fi

if [ -f /share/#/docker/run.sh ];
then
    echo 'RUNNING CUSTOM SCRIPT'
    . /share/#/docker/run.sh
fi

service apache2 restart

# tail -F /var/log/apache2/* &
# exec apache2 -D FOREGROUND

tail -F /var/log/apache2/error.log
