Description
-----------

Docker file to create an image for **Mayan EDMS**

Instructions
------------

Building the image
------------------

Clone the repository with::

    git clone https://gitlab.com/mayan-edms/mayan-edms-docker.git

Change to the directory of the cloned repository::

    cd mayan-edms-docker

Execute Docker's build command::

    docker build -t mayanedms/monolithic


Deploying
---------
Clone the repository with::

    git clone https://gitlab.com/mayan-edms/mayan-edms-docker.git

Change to the directory of the cloned repository::

    cd mayan-edms-docker

Launch the entire stack (Postgres, Redis, NGINX, and Mayan EDMS) using::

    docker-compose up -d

Initialize the Mayan EDMS container using

    docker exec -t -i mayanedmsdocker_frontend_1 mayan-edms.py initialsetup

The frontend will be available by browsing to http://127.0.0.1
