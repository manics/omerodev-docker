#!/usr/bin/env python

from subprocess import call
import sys


commands = {
    "show -p Environment postgresql-9.4.service":
        "grep ^Environment /usr/lib/systemd/system/postgresql-9.4.service",
    "start postgresql-9.4":
        "pgrep postgres > /dev/null || su - postgres -c '/usr/pgsql-9.4/bin/pg_ctl start -D /var/lib/pgsql/9.4/data/ -s -w -t 300'",
    "stop postgresql-9.4":
        "su - postgres -c '/usr/pgsql-9.4/bin/pg_ctl stop -D /var/lib/pgsql/9.4/data/ -s -m fast'",
    "reload postgresql-9.4":
        "su - postgres -c '/usr/pgsql-9.4/bin/pg_ctl reload -D /var/lib/pgsql/9.4/data/ -s'",
    "enable postgresql-9.4":
        "[ -f /usr/pgsql-9.4/bin/pg_ctl ]",
    "show postgresql-9.4":
        "pgrep postgres > /dev/null && echo ActiveState=active || echo ActiveState=inactive",

    "start nginx":
        "pgrep nginx > /dev/null || /usr/sbin/nginx -c /etc/nginx/nginx.conf",
    "stop nginx":
        "/usr/sbin/nginx -c /etc/nginx/nginx.conf -s quit",
    "reload nginx":
        "/usr/sbin/nginx -c /etc/nginx/nginx.conf -s reload",
    "enable nginx":
        "[ -f /usr/sbin/nginx ]",
    "show nginx":
        "pgrep nginx > /dev/null && echo ActiveState=active || echo ActiveState=inactive",
}

args = sys.argv[1:]
runcmd = None
for [k, v] in commands.iteritems():
    if not isinstance(k, list):
        k = k.split()
    if k == args:
        runcmd = v
        break

if not runcmd:
    raise Exception('Unexpected command: %s' % args)

if isinstance(runcmd, list):
    sys.exit(call(runcmd))
else:
    sys.exit(call(runcmd, shell=True))
