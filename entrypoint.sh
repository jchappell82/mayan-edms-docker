#!/bin/bash
set -e

initialize() {
    mayan-edms.py initialsetup
    cat /local.py >> /usr/local/lib/python2.7/dist-packages/mayan/settings/local.py
    chown -R www-data:www-data /usr/local/lib/python2.7/dist-packages/mayan/
}

upgrade() {
    mayan-edms.py performupgrade
}

start() {
    rm -rf /var/run/supervisor.sock
    exec /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
}

restart() {
    supervisorctl restart all
}

case ${1} in
  mayan:start)
    start
    ;;
  mayan:init)
    initialize
    ;;
  mayan:upgrade)
    upgrade
    ;;
  mayan:restart)
    restart
    ;;
  mayan:help)
    echo "Available options:"
    echo " app:start        - Starts the server (default)"
    echo " app:init         - Initialize the installation (e.g. create databases, migrate database)."
    echo " app:upgrade      - Migrate an existing database to a current version."
    echo " app:help         - Displays the help"
    echo " [command]        - Execute the specified command, eg. bash."
    ;;
  *)
    exec "$@"
    ;;
esac
