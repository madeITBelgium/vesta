FROM ubuntu:latest

EXPOSE 22 80 8083 3306 443 25 993 110 53 54

ENV LANG C.UTF-8

RUN apt-get update -y --fix-missing
RUN apt-get update -y
RUN apt-get install -y wget lsb-release curl


RUN \curl -L https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.4"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
RUN /bin/bash -l -c "source /etc/profile.d/rvm.sh"
RUN /bin/bash -l -c "bundle config --global frozen 1"
RUN /bin/bash -l -c "bundle config --global silence_root_warning 1"
RUN /bin/bash -l -c "export LANG=en_US.UTF-8; export LANGUAGE=en_US.UTF-8; export LC_ALL=en_US.UTF-8"

ENV PATH="/usr/local/rvm/rubies/default/bin:${PATH}"
ENV GEM_HOME="/usr/local/rvm/gems/ruby-2.4.0"
ENV GEM_PATH="/usr/local/rvm/gems/ruby-2.4.0:/usr/local/rvm/gems/ruby-2.4.0@global"
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
  
#RUN /bin/bash -l -c "cd /usr/local/vesta/test/bin/bashcov; bundle install"

RUN chmod +x /vesta/docker/startup-ubuntu.sh
RUN /bin/bash -c "source /etc/profile.d/vesta.sh"
RUN /vesta/docker/startup-ubuntu.sh