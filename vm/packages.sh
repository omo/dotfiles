aptitude install -y lxc-docker
# http://stackoverflow.com/questions/23169385/installing-docker-io-on-ubuntu-14-04lts
usermod -a -G docker vagrant

aptitude install -y build-essential git-core emacs24-nox mercurial byobu unzip silversearcher-ag
aptitude install -y python python-pip

pip install fabric
