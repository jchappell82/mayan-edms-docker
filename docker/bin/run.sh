#!/bin/bash

if [ $MAYAN_ROLE == "WORKER" ]; then
    if [[ -z $MAYAN_WORKER_QUEUE ]]; then
        mayan-edms.py celery worker --settings=mayan.settings.production -Ofair -l ERROR
    else
        mayan-edms.py celery worker --settings=mayan.settings.production -Ofair -l ERROR -Q $MAYAN_WORKER_QUEUE
    fi
elif [ $MAYAN_ROLE == "BEAT" ]; then
    mayan-edms.py celery beat --settings=mayan.settings.production -l ERROR
else
    # Launch uWSGI in foreground
    /usr/local/bin/uwsgi --ini /docker/conf/uwsgi/uwsgi.ini
fi
