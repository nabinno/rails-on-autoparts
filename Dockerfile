FROM nitrousio/autoparts-builder

RUN apt-get update; apt-get install -y \
    cron \
    openssh-server \
    screen \
    tree \
    zsh \
    software-properties-common \
    python-software-properties
RUN add-apt-repository -y \
    ppa:cassou/emacs
RUN apt-get update; apt-get install -y \
    emacs24 \
    emacs24-el \
    emacs24-common-non-dfsg

# autoparts
RUN parts install \
    nodejs \
    ruby2.1 \
    chruby \
    heroku_toolbelt \
    # postgresql

# npm
RUN npm install -g \
    coffee-script \
    bower \
    grunt-cli \
    requirejs \
    less

# ruby
RUN gem install \
    rails \
    half-pipe

# dot files
RUN git clone https://github.com/nabinno/dot-files.git
RUN find ~/dotfiles -maxdepth 1 -mindepth 1 | xargs -i mv -f {} ~/
RUN rm -fr dotfiles .git README.md

# environmental variables
RUN sed -i "s/^#Protocol 2,1/Protocol 2/g" /etc/ssh/sshd_config
RUN sed -i "s/^#SyslogFacility AUTH/SyslogFacility AUTH/g" /etc/ssh/sshd_config
RUN sed -i "s/^\(PermitRootLogin yes\)/#\1\nPermitRootLogin without-password/g" /etc/ssh/sshd_config
RUN sed -i "s/^\(ChallengeResponseAuthentication no\)/#\1\nChallengeResponseAuthentication yes/g" /etc/ssh/sshd_config
# RUN sed -i "s/^\(#PasswordAuthentication yes\)/\1\nPasswordAuthentication yes/g" /etc/ssh/sshd_config
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

