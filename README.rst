Description
-----------

Docker file to create an image for Mayan EDMS

Instructions
------------

Building the image
------------------

Clone the repository with::

    git clone https://gitlab.com/mayan-edms/mayan-edms-docker.git

Change to the directory of the cloned repository::

    cd mayan-edms-docker

Execute Docker's build command::

    docker build -t mayanedms/mayanedms .


Deploying
---------

Initialize the Mayan EDMS container using::

    docker run --rm -v mayan_media:/usr/local/lib/python2.7/dist-packages/mayan/media -v mayan_settings:/usr/local/lib/python2.7/dist-packages/mayan/settings mayanedms/mayanedms mayan:init

Launch the container using::

    docker run -d --name mayan-edms --restart=always -p 80:80 -v mayan_media:/usr/local/lib/python2.7/dist-packages/mayan/media -v mayan_settings:/usr/local/lib/python2.7/dist-packages/mayan/settings mayanedms/mayanedms

The frontend will be available by browsing to http://127.0.0.1

All files will be stored in the following two volumes::

 - mayan_media
 - mayan_settings

Configuring
-----------

To edit the settings file, check the physical location of the `mayan_settings` volume using::

    docker volume inspect mayan_settings

Which should produce an output similar to this one::

    [
        {
            "Name": "mayan_settings",
            "Driver": "local",
            "Mountpoint": "/var/lib/docker/volumes/mayan_settings/_data",
            "Labels": null,
            "Scope": "local"
        }
    ]

In this case the physical location of the `mayan_settings` volume is
`/var/lib/docker/volumes/mayan_settings/_data`. Edit the settings with your
favorite editor::

    sudo vi /var/lib/docker/volumes/mayan_settings/_data/local.py


Backups
-------

To backup the existing data, check the physical location of the `mayan_media` volume using::

    docker volume inspect mayan_media

Which should produce an output similar to this one::

    [
        {
            "Name": "mayan_settings",
            "Driver": "local",
            "Mountpoint": "/var/lib/docker/volumes/mayan_media/_data",
            "Labels": null,
            "Scope": "local"
        }
    ]

Only the `db.sqlite3` file and the `document_storage` folders need to be backedup::

    sudo tar -zcvf backup.tar.gz /var/lib/docker/volumes/mayan_media/_data/document_storage /var/lib/docker/volumes/mayan_media/_data/db.sqlite3
    sudo chown `whoami` backup.tar.gz


Restore
-------
Uncompress the archive in the original docker volume using::

    sudo tar -xvzf backup.tar.gz -C /
