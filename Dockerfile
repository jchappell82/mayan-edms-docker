FROM ubuntu:16.04

MAINTAINER Roberto Rosario "roberto.rosario@mayan-edms.com"

ENV DEBIAN_FRONTEND noninteractive

# Package caching
RUN echo 'Acquire::http { Proxy "http://172.18.0.1:3142"; };' > /etc/apt/apt.conf.d/01proxy

# Install base Ubuntu libraries
RUN apt-get update && \

apt-get install -y --no-install-recommends \
        gcc \
        ghostscript \
        gpgv \
        libjpeg-dev \
        libmagic1 \
        libpng-dev \
        libreoffice \
        libtiff-dev \
        nginx \
        netcat-openbsd \
        poppler-utils \
        python-dev \
        python-pip \
        python-setuptools \
        python-wheel \
        redis-server \
        supervisor \
        tesseract-ocr \

&& \

apt-get clean autoclean && \

apt-get autoremove -y && \

rm -rf /var/lib/apt/lists/* && \

rm -f /var/cache/apt/archives/*.deb

ENV MAYAN_INSTALL_DIR=/usr/local/lib/python2.7/dist-packages/mayan

# Install Mayan EDMS, latest production release
RUN pip install mayan-edms==2.1.5

# Install Python clients for PostgreSQL, REDIS, librabbitmq and uWSGI
RUN pip install redis uwsgi

# Collect static files
RUN mayan-edms.py collectstatic --noinput

# Setup uWSGI
COPY etc/uwsgi/uwsgi.ini $MAYAN_INSTALL_DIR

# Setup NGINX
COPY /etc/nginx/mayan-edms /etc/nginx/sites-available/mayan-edms
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/mayan-edms /etc/nginx/sites-enabled/mayan-edms

# Setup supervisor
COPY /etc/supervisor/beat.conf /etc/supervisor/conf.d
COPY /etc/supervisor/nginx.conf /etc/supervisor/conf.d
COPY /etc/supervisor/uwsgi.conf /etc/supervisor/conf.d
COPY /etc/supervisor/redis.conf /etc/supervisor/conf.d
COPY /etc/supervisor/workers.conf /etc/supervisor/conf.d

# Setup Mayan EDMS settings file overrides
COPY etc/mayan/settings.py /local.py

# Create the directory for the logs
RUN mkdir /var/log/mayan

RUN mkdir -p $MAYAN_INSTALL_DIR/media/document_storage/

# Fix ownership
RUN chown -R www-data:www-data $MAYAN_INSTALL_DIR

# Persistent Mayan EDMS files
VOLUME $MAYAN_INSTALL_DIR/media
VOLUME $MAYAN_INSTALL_DIR/settings

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mayan:start"]
