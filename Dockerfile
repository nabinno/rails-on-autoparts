FROM ubuntu:12.04

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu precise-updates main universe" >> /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu precise-security main universe" >> /etc/apt/sources.list

RUN apt-get update; apt-get install -y \
  automake \
  autotools-dev \
  base-files \
  base-passwd \
  binutils \
  build-essential \
  bzip2 \
  cmake \
  cron \
  curl \
  dnsutils \
  gdb \
  git \
  git-core \
  gnupg \
  imagemagick \
  libarchive-dev \
  libarchive12 \
  libbz2-1.0 \
  libbz2-dev \
  libc6 \
  libcurl3 \
  libcurl3-gnutls \
  libcurl4-openssl-dev \
  libdb5.1 \
  libdb5.1-dev \
  libevent-1.4-2 \
  libevent-core-1.4-2 \
  libevent-dev \
  libevent-extra-1.4-2 \
  libffi-dev \
  libgdbm-dev \
  libglib2.0-dev \
  libglib2.0-dev \
  libicu-dev \
  libldap-2.4-2 \
  libldap2-dev \
  libltdl-dev \
  libltdl7 \
  liblzma-dev \
  liblzma-doc \
  liblzma5 \
  libmagickcore-dev \
  libmagickwand-dev \
  libmysqlclient-dev \
  libncap-dev \
  libncap44 \
  libncurses5-dev \
  libncurses5-dev \
  libncursesw5 \
  libncursesw5-dev \
  libncursesw5-dev \
  libpam0g-dev \
  libpng12-0 \
  libpng12-dev \
  libpq-dev \
  libqt4-dev \
  libreadline6-dev \
  libsndfile1-dev \
  libsqlite3-dev \
  libssl0.9.8 \
  libxml2 \
  libxml2-dev \
  libxslt1-dev \
  libxt-dev \
  libxt6 \
  libyaml-dev \
  mysql-server \
  openssh-server \
  openssl \
  postgresql \
  postgresql-contrib \
  psmisc \
  ruby1.9.3 \
  s3cmd \
  screen \
  sqlite3 \
  sudo \
  telnet \
  tsconf \
  unzip \
  util-linux \
  vim \
  wget \
  whiptail \
  xz-utils \
  zip \
  zlib1g \
  zlib1g-dev \
  zsh

RUN adduser --disabled-password action
RUN mkdir -p /home/action/.parts
RUN git clone https://github.com/nitrous-io/autoparts.git /home/action/.parts/autoparts
RUN chown -R action:action /home/action

ENV PATH /home/action/.parts/autoparts/bin:${PATH}
ENV AUTOPARTS_DEV true
ENV HOME /home/action
WORKDIR /home/action

RUN sed -i "s/^#Protocol 2,1/Protocol 2/g" /etc/ssh/sshd_config
RUN sed -i "s/^#SyslogFacility AUTH/SyslogFacility AUTH/g" /etc/ssh/sshd_config
RUN sed -i "s/^\(PermitRootLogin yes\)/#\1\nPermitRootLogin without-password/g" /etc/ssh/sshd_config
RUN sed -i "s/^\(ChallengeResponseAuthentication no\)/#\1\nChallengeResponseAuthentication yes/g" /etc/ssh/sshd_config
# RUN sed -i "s/^\(#PasswordAuthentication yes\)/\1\nPasswordAuthentication yes/g" /etc/ssh/sshd_config
RUN sed -i "s/^\(PATH=\"\/usr\/local\/sbin:\/usr\/local\/bin:\/usr\/sbin:\/usr\/bin:\/sbin:\/bin:\/usr\/games\"\)$/\1\nLC_ALL=en_US.UTF-8/g" /etc/environment
RUN chmod 640 /etc/sudoers
RUN sed -i "s/^\(# User privilege specification\)$/\1\naction  ALL=(ALL)       ALL/g" /etc/sudoers
RUN chmod 440 /etc/sudoers
RUN locale-gen en_US.UTF-8
RUN echo 'root:screencast' | chpasswd
RUN echo 'action:nitrousio' | chpasswd
RUN chsh -s /usr/bin/zsh root
RUN chsh -s /usr/bin/zsh action
RUN chmod 775 /var/run/screen
RUN chmod 777 -R /var/spool/cron
RUN chown -R action:action /home/action

RUN mkdir -p /var/run/sshd
EXPOSE 22
CMD    /usr/sbin/sshd -D
