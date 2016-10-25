FROM ubuntu:16.10

MAINTAINER Roberto Rosario "roberto.rosario@mayan-edms.com"

# Install base Ubuntu libraries
RUN apt-get update && apt-get install -y netcat-openbsd python-dev python-pip gnupg1 libpq-dev libjpeg-dev libmagic1 libpng-dev libreoffice libtiff-dev gcc ghostscript tesseract-ocr poppler-utils librabbitmq-dev
# && apt-get clean && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/archives/*.deb

ENV MAYAN_INSTALL_DIR=/usr/local/lib/python2.7/dist-packages/mayan

# Install Mayan EDMS, latest production release
RUN pip install mayan-edms==2.1.3

# Install Python clients for PostgreSQL, REDIS, librabbitmq and uWSGI
RUN pip install psycopg2 redis librabbitmq uwsgi

# Create Mayan EDMS basic settings/local.py file
RUN mayan-edms.py createsettings

# Collect static files
RUN mayan-edms.py collectstatic --noinput

ADD docker /docker

# Setup Mayan EDMS settings file overrides
RUN cat /docker/conf/mayan/settings.py >> $MAYAN_INSTALL_DIR/settings/local.py

# Create the directory for the logs
RUN mkdir /var/log/mayan

# Persistent Mayan EDMS files
VOLUME $MAYAN_INSTALL_DIR/media/document_cache
VOLUME $MAYAN_INSTALL_DIR/media/document_storage
VOLUME $MAYAN_INSTALL_DIR/media/static
VOLUME $MAYAN_INSTALL_DIR/settings

ENTRYPOINT ["/docker/entrypoint.sh"]

CMD ["/docker/bin/run.sh"]
