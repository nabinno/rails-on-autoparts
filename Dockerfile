FROM nitrousio/autoparts-builder

RUN apt-get update; apt-get install -y \
  emacs \
  openssh-server \
  pwgen \
  screen \
  sudo

# autoparts
RUN parts install nodejs
RUN parts install ruby2.1
RUN parts install chruby
# RUN parts install postgresql
RUN parts install heroku_toolbelt
RUN parts install tree
RUN parts install vim  
RUN parts install zsh

# dot files
RUN mkdir -p /home/action/dotfiles
RUN git clone https://github.com/nabinno/dotfiles.git /home/action
RUN mv /home/action/dotfiles/* /home/action/
RUN mv /home/action/dotfiles/.* /home/action/
RUN rm -fr /home/action/dotfiles

# environmental variables
# RUN sed -i "s/^\(root.*\)$/\1\naction\tALL=(ALL)\tALL/g" /etc/sudoers
RUN sed -i "s/^#Protocol 2,1/Protocol 2/g" /etc/ssh/sshd_config
# RUN sed -i "s/^#SyslogFacility AUTH/SyslogFacility AUTHPRIV/g" /etc/ssh/sshd_config
RUN sed -i "s/^\(PermitRootLogin yes\)/#\1\nPermitRootLogin without-password/g" /etc/ssh/sshd_config
RUN sed -i "s/^\(#ChallengeResponseAuthentication no\)/#\1\nChallengeResponseAuthentication yes/g" /etc/ssh/sshd_config
RUN sed -i "s/^\(#PasswordAuthentication yes\)/\1\nPasswordAuthentication yes/g" /etc/ssh/sshd_config
RUN echo 'root:screencast' | chpasswd
RUN echo 'action:nitrousio' | chpasswd
RUN chsh -s /usr/bin/zsh root
RUN chsh -s /usr/bin/zsh action
RUN chown -R action:action /home/action

# sshd
RUN mkdir -p /var/run/sshd
EXPOSE 22
CMD    /usr/sbin/sshd -D

