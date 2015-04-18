
mkdir -p $HOME/work
cd work

go get github.com/tools/godep

if [ ! -d $HOME/work/dotfiles ]; then
  git clone https://github.com/omo/dotfiles.git
else
  cd dotfiles && git pull origin master
fi

PROVISION_MAY_SKIP_ELPA_REFRESH=1 emacs --script $HOME/work/dotfiles/install-packages.el
ln -f -s $HOME/work/dotfiles/.emacs ~/.emacs
ln -f -s $HOME/work/dotfiles/.emacs.prologue.template $HOME/work/dotfiles/.emacs.prologue

if [ ! -d $HOME/.nvm ]; then
  # See https://github.com/creationix/nvm
  curl https://raw.githubusercontent.com/creationix/nvm/v0.14.0/install.sh | bash
  . $HOME/.nvm/nvm.sh
  nvm install 0.12
fi

nvm use 0.12
if [ -z `which grunt` ]; then npm install -g grunt-cli; fi
if [ -z `which gulp` ]; then npm install -g gulp; fi
if [ -z `which bower` ]; then npm install -g bower; fi

git config --global user.name   "Hajime Morrita"
git config --global user.email  omo@dodgson.org
git config --global core.editor vi
git config --global push.default simple
