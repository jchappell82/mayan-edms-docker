[![Docker pulls](https://img.shields.io/docker/pulls/mayanedms/mayanedms.svg?maxAge=3600)](https://hub.docker.com/r/mayanedms/mayanedms/) [![Docker Stars](https://img.shields.io/docker/stars/mayanedms/mayanedms.svg?maxAge=3600)](https://hub.docker.com/r/jamiemagee/mayan-edms/) [![Docker layers](https://images.microbadger.com/badges/image/mayanedms/mayanedms.svg)](https://microbadger.com/images/mayanedms/mayanedms) [![Docker version](https://images.microbadger.com/badges/version/mayanedms/mayanedms.svg)](https://microbadger.com/images/mayanedms/mayanedms) ![Docker build](https://img.shields.io/docker/automated/mayanedms/mayanedms.svg) ![License](https://img.shields.io/badge/License-MIT-green.svg?maxAge=3600)

Description
-----------

Official Docker container for [Mayan EDMS](https://gitlab.com/mayan-edms/mayan-edms)


Deploying
---------

Initialize the container:

    docker run --rm -v mayan_media:/var/lib/mayan -v mayan_settings:/etc/mayan mayanedms/mayanedms mayan:init

Launch the container:

    docker run -d --name mayan-edms --restart=always -p 80:80 -v mayan_media:/var/lib/mayan -v mayan_settings:/etc/mayan mayanedms/mayanedms

The container will be available by browsing to [http://127.0.0.1](http://127.0.0.1)

All files will be stored in the following two volumes:

 - mayan_media
 - mayan_settings

If another web server is running on port 80 use a different port in the
``-p`` option, ie: ``-p 81:80``.

Stopping and starting
---------------------
To stop the container use:

    docker stop mayan-edms

To start the container again:

    docker start mayan-edms


Configuring
-----------

To edit the settings file, check the physical location of the ``mayan_settings`` volume using:

    docker volume inspect mayan_settings

Which should produce an output similar to this one:

    [
        {
            "Name": "mayan_settings",
            "Driver": "local",
            "Mountpoint": "/var/lib/docker/volumes/mayan_settings/_data",
            "Labels": null,
            "Scope": "local"
        }
    ]

In this case the physical location of the ``mayan_settings`` volume is
``/var/lib/docker/volumes/mayan_settings/_data``. Edit the settings with your
favorite editor:

    sudo vi /var/lib/docker/volumes/mayan_settings/_data/local.py


Backups
-------

To backup the existing data, check the physical location of the ``mayan_media`` volume using:

    docker volume inspect mayan_media

Which should produce an output similar to this one:

    [
        {
            "Name": "mayan_settings",
            "Driver": "local",
            "Mountpoint": "/var/lib/docker/volumes/mayan_media/_data",
            "Labels": null,
            "Scope": "local"
        }
    ]

Only the ``db.sqlite3`` file and the ``document_storage`` folders need to be backed up:

    sudo tar -zcvf backup.tar.gz /var/lib/docker/volumes/mayan_media/_data/document_storage /var/lib/docker/volumes/mayan_media/_data/db.sqlite3
    sudo chown `whoami` backup.tar.gz


Restore
-------
Uncompress the archive in the original docker volume using:

    sudo tar -xvzf backup.tar.gz -C /


Building the image
------------------

Clone the repository with:

    git clone https://gitlab.com/mayan-edms/mayan-edms-docker.git

Change to the directory of the cloned repository:

    cd mayan-edms-docker

Execute Docker's build command:

    docker build -t mayanedms/mayanedms .

Build the image using an apt cacher:

    docker build -t mayanedms/mayanedms --build-arg APT_PROXY=172.18.0.1 .
