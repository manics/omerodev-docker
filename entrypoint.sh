#!/bin/sh

set -eux
#echo -n systemd > /proc/1/comm
systemctl start postgresql-9.6
#systemctl start nginx
#ansible-playbook -i /opt/install/inventory.yml /opt/install/omerodev-docker-post.yml
exec /opt/bin/gosu build bash "$@"
