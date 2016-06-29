#!/bin/sh
systemctl start postgresql-9.4
systemctl start nginx
exec /opt/bin/gosu build bash "$@"
