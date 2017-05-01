FROM ubuntu:latest

EXPOSE 22 80 8083 3306 443 25 993 110 53 54

RUN apt-get update -y --fix-missing
RUN apt-get install -y wget lsb-release

ENV VESTA /usr/local/vesta

ADD bin /vesta/bin
ADD func /vesta/func
ADD install /vesta/install
ADD test /vesta/test
ADD upd /vesta/upd
ADD web /vesta/web
ADD docker /vesta/docker

RUN chmod +x /vesta/install/vst-install*
RUN /vesta/install/vst-install-ubuntu-docker.sh --nginx yes --apache yes \
  --phpfpm no --named yes --remi yes --vsftpd no --proftpd no --iptables no \
  --fail2ban no --quota no --exim yes --dovecot yes --spamassassin no --clamav no \
  --mysql yes --postgresql no --hostname example.com --email test@example.com \
  --password admin -y no --force

RUN chmod +x /vesta/docker/startup-ubuntu.sh
RUN /bin/bash -c "source /etc/profile.d/vesta.sh"
RUN /vesta/docker/startup-ubuntu.sh