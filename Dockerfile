FROM nitrousio/autoparts-builder

RUN apt-get update; apt-get install -y \
    cron \
    openssh-server \
    screen \
    tree \
    sudo \
    vim \
    zsh

# autoparts
RUN parts install \
    nodejs \
    ruby2.1 \
    chruby \
    heroku_toolbelt
    # postgresql

# npm
RUN /home/action/.parts/bin/npm install -g \
    bower \
    grunt-cli \
    requirejs \
    less

# emacs
ENV EMACS_VERSION 24.3
RUN wget http://core.ring.gr.jp/pub/GNU/emacs/emacs-$EMACS_VERSION.tar.gz
RUN tar zxf emacs-$EMACS_VERSION.tar.gz
RUN cd emacs-$EMACS_VERSION; ./configure --with-xpm=no --with-gif=no; make; make install; cd ~
RUN rm -fr emacs-$EMACS_VERSION*

# ruby
RUN gem install \
    rails

# dot files
RUN git clone https://github.com/nabinno/dotfiles.git
RUN find ~/dotfiles -maxdepth 1 -mindepth 1 | xargs -i mv -f {} ~/
RUN rm -fr dotfiles .git README.md

# environmental variables
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
RUN chmod 777 /var/run/screen
RUN chmod 777 -R /var/spool/cron
RUN chown -R action:action /home/action

# sshd
RUN mkdir -p /var/run/sshd
EXPOSE 22
CMD    /usr/sbin/sshd -D

