#!/bin/sh

echo -n systemd > /proc/1/comm && \
    ansible-playbook -i /opt/inventory.hosts \
        "/opt/infrastructure/ansible/omerodev-docker-post.yml"
systemctl start postgresql-9.4
systemctl start nginx
exec /opt/bin/gosu build bash "$@"
