FROM nitrousio/autoparts-builder

RUN apt-get update; apt-get install -y \
  emacs \
  openssh-server \
  pwgen \
  screen

# Securities
# RUN sed -i "s/^#Protocol 2,1/Protocol 2/g" /etc/ssh/sshd_config
# RUN sed -i "s/^#SyslogFacility AUTH/SyslogFacility AUTHPRIV/g" /etc/ssh/sshd_config
# RUN sed -i "s/^#PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
# RUN sed -i "s/^#PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
# RUN sed -i "s/^#PermitEmptyPasswords no/PermitEmptyPasswords no/g" /etc/ssh/sshd_config

# Ruby
RUN parts install nodejs
RUN parts install ruby2.1
RUN parts install chruby
# RUN parts install postgresql
RUN parts install heroku_toolbelt
RUN parts install tree
RUN parts install vim
RUN parts install zsh

# Emacs Files
RUN mkdir -p /home/action/.emacs.d
RUN git clone https://github.com/purcell/emacs.d.git /home/action
RUN chown -R action:action /home/action

# Sshd
RUN mkdir -p /var/run/sshd
EXPOSE 23132
CMD    /usr/sbin/sshd -D

