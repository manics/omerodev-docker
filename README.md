omerodev-docker
===============

WARNING: Work in progress

A self-contained image for developing and testing OMERO.

Example:

    docker run -it --rm --name omerodev-docker \
        -p 10080:80 -p 10443:443 -p 18080:8080 \
        -p 4061:4061 -p 4063:4063  -p 4064:4064 \
        -v omerodev-src:/home/build/src \
        -v omerodev-pg:/var/lib/pgsql/9.4/data \
        -v omerodev-omero:/OMERO \
        manics/omerodev-docker

This will start PostgreSQL, Nginx, and will drop you into a `bash` shell with user `build`.
This user has full `sudo` rights.

This example uses three named volumes:
- `omerodev-src`: An empty directory which should be used to store persistent data during development, for example `git clone --recursive https://github.com/openmicroscopy/openmicroscopy.git`
- `omerodev-pg`: The PostgreSQL data directory
- `omerodev-omero`: The OMERO.server data directory

This image was built using https://github.com/openmicroscopy/infrastructure which assumes `systemd` is present.
To remove this requirement `systemctl` has been mocked for some services, see `systemctl-mock.py`.