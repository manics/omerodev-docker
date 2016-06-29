FROM centos:centos7
MAINTAINER ome-devel@lists.openmicroscopy.org.uk

RUN yum -y install epel-release git sudo && \
    yum -y install ansible && \
    yum clean all

RUN git clone https://github.com/openmicroscopy/infrastructure.git \
    /opt/infrastructure

ADD systemctl-mock.py /opt/bin/systemctl
ADD entrypoint.sh /opt/bin/
# Update systemd so that it doesn't overwrite our override
RUN yum -y update systemd && \
    yum clean all && \
    mv /bin/systemctl /bin/systemctl.orig && \
    ln -s /opt/bin/systemctl /bin/systemctl

ARG ANSIBLE_GROUP=ci-omero
ARG ANSIBLE_PLAYBOOK=ci-deployment.yml

RUN echo "[$ANSIBLE_GROUP]" > /opt/inventory.hosts && \
    echo 'localhost ansible_connection=local' >> /opt/inventory.hosts

# Dodgy hack to get Ansible to recognise systemd
# https://github.com/ansible/ansible-modules-core/issues/593#issuecomment-144725409
RUN echo -n systemd > /proc/1/comm && \
    ansible-playbook -i /opt/inventory.hosts \
        "/opt/infrastructure/ansible/$ANSIBLE_PLAYBOOK" && \
    yum clean all

RUN useradd build && \
    echo 'build ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/build
WORKDIR /home/build

ENV PATH="/opt/bin:$PATH"

EXPOSE 80 443 8080 4061 4063 4064

VOLUME ["/OMERO", "/var/lib/pgsql/9.4/data"]

# Set the default command to run when starting the container
ENTRYPOINT ["/opt/bin/entrypoint.sh"]
