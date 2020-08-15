#!/bin/sh
 
RED='\033[1;31m'
GREEN='\033[1;32m'
DARK='\033[1;93m'
RESET='\033[0m'

mysql_config() {
	printf "\n\n${GREEN}START MYSQL CONFIG ${DARK}\n"
    mysql_install_db --defaults-file=/etc/my.cnf.d/mariadb-server.cnf
#    chown -R mysql:mysql --defaults-file=/etc/my.cnf.d/mariadb-server.cnf /var/lib/mysql
    /usr/bin/mysqld_safe --defaults-file=/etc/my.cnf.d/mariadb-server.cnf & 
    sleep 10
}
 
start_mysql() {
	printf "\n\n${GREEN}START SQL SCRIPTS${DARK}\n"
	printf "\n${GREEN}DB before config${DARK}\n"
    mysql --defaults-file=/etc/my.cnf.d/mariadb-server.cnf -e "SHOW DATABASES;"
    mysql --defaults-file=/etc/my.cnf.d/mariadb-server.cnf < /tmp/phpmyadmin.sql
    mysql --defaults-file=/etc/my.cnf.d/mariadb-server.cnf < /tmp/wp.sql
	printf "\n${GREEN}DB after config${DARK}\n"
    mysql --defaults-file=/etc/my.cnf.d/mariadb-server.cnf -e "SHOW DATABASES;"
    mysql --defaults-file=/etc/my.cnf.d/mariadb-server.cnf -e "CREATE USER 'admin'@'%' IDENTIFIED BY '42';"
    mysql --defaults-file=/etc/my.cnf.d/mariadb-server.cnf -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%';"
	printf "\n${GREEN}After user creation${DARK}\n"
    mysql --defaults-file=/etc/my.cnf.d/mariadb-server.cnf -e "SHOW GRANTS FOR 'admin'@'%';"
    mysql --defaults-file=/etc/my.cnf.d/mariadb-server.cnf -e "FLUSH PRIVILEGES;"

    killall mysqld
    sleep 10
}
 
mysql_config
start_mysql
supervisord
