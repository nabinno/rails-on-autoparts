# Rails on Autoparts --- Dockerfile and Docker image configuration
## Usage
```
docker run -t -d -p 30000:3000 -P quay.io/nabinno/rails-on-autoparts /usr/sbin/sshd -D
```

---

## Example of Setting up Rails on Autoparts
### 1. Dependencies
#### servers
- centos        = CentOS 6 x86_64
- railsonubuntu = Ubuntu 12.04 for Rail4 on CentOS 6 x86_64
- client        = Client PC

#### scripts
- [docker/docker](https://github.com/docker/docker)
- [nitrous-io/autoparts](https://github.com/nitrous-io/autoparts)
- [nabinno/rails-on-autoparts](https://github.com/nabinno/rails-on-autoparts)
- etc.

### 2. Setup Docker/CentOS 6 x86_64
```
root@centos# adduser foo
root@centos# echo foo | passwd bar --stdin
```
Setup environment for sudo
```
root@centos# sed -i "s/^\(root.*\)$/\1\n000\tALL=(ALL)\tALL/g" /etc/sudoers
```
Setup environment for authentication
```
root@centos# sed -i "s/^\(#PermitRootLogin yes\)/\1\nPermitRootLogin no/g" /etc/ssh/sshd_config
root@centos# sed -i "s/^\(#PasswordAuthentication yes\)/\1\nPasswordAuthentication no/g" /etc/ssh/sshd_config
root@centos# sed -i "s/^\(#ChallengeResponseAuthentication yes\)/\1\nChallengeResponseAuthentication no/g" /etc/ssh/sshd_config
root@centos# sed -i "s/^\(#RhostsRSAAuthentication no\)/\1\nRhostsRSAAuthentication no/g" /etc/ssh/sshd_config
root@centos# sed -i "s/^\(#PermitEmptyPasswords no\)/\1\nPermitEmptyPasswords no/g" /etc/ssh/sshd_config
```
Setup environment for other
```
root@centos# sed -i "s/^\(#Protocol 2,1\)/\1\nProtocol 2/g" /etc/ssh/sshd_config
root@centos# sed -i "s/^\(#SyslogFacility AUTH\)/\1\nSyslogFacility AUTHPRIV/g" /etc/ssh/sshd_config
```
Install docker
```
root@centos# yum install docker-io -y
root@centos# service docker start
root@centos# chkconfig docker on
foo@centos% alias docker='sudo docker'
```
Setup environment for authentication of password
```
client# ssh-keygen -t rsa
client# ssh-copy-id -i ~/.ssh/id_rsa.pub foo@centos.host
client# mv ~/.ssh/id_rsa ~/.ssh/id_rsa_foo@centos
client# ssh foo@centos.host
foo@centos% sudo sed -i "s/^\(#PasswordAuthentication yes\)/\1\nPasswordAuthentication no/g" /etc/ssh/sshd_config
foo@centos% sudo /etc/init.d/sshd restart
```

### 3. Setup Rails4 on Autoparts/Ubuntu 12.04
Pull and run sshd server
```
foo@centos% docker run -t -d -p 30000:3000 -P quay.io/nabinno/rails-on-autoparts /usr/sbin/sshd -D
```
Get port-railsonubuntu
```
foo@centos% docker inspect --format {{.NetworkSettings.IPAddress}} $(docker ps -l -q)
foo@centos% docker inspect --format {{.NetworkSettings.Ports}} $(docker ps -l -q)
```
Change password of ubuntu user
```
client# ssh-keygen -t rsa
client# ssh-copy-id -i ~/.ssh/id_rsa.pub action@railsonubuntu -p port-railsonubuntu
client# mv ~/.ssh/id_rsa ~/.ssh/id_rsa_action@railsonubuntu
client# ssh -t action@railsonubuntu(centos.host) zsh -p port-railsonubuntu
action@railsonubuntu# sudo sed -i "s/^\(#PasswordAuthentication yes\)/\1\nPasswordAuthentication no/g" /etc/ssh/sshd_config
action@railsonubuntu# echo 'action:baz' | sudo chpasswd
foo@centos% docker commit $(docker ps -l -q) container_id
```

---

## EPILOGUE
>     A whale!
>     Down it goes, and more, and more
>     Up goes its tail!
>
>     -Buson Yosa
