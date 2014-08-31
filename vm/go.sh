cd work
if [ ! -f go1.3.1.linux-amd64.tar.gz ]; then
  wget -nv https://storage.googleapis.com/golang/go1.3.1.linux-amd64.tar.gz
  tar -C /usr/local -xzf go1.3.1.linux-amd64.tar.gz
fi

