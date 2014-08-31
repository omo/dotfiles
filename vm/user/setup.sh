
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

git config --global user.name   "Hajime Morrita"
git config --global user.email  omo@dodgson.org
git config --global core.editor vi
