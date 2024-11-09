#!/bin/bash

which -s brew
if [[ $? != 0 ]] ; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew info gnupg
if [[ $? != 0 ]] ; then
  brew install gnupg
fi

brew info asdf
if [[ $? != 0 ]] ; then
  brew install asdf
fi

asdf plugin-add nodejs
asdf install

which -s docker
if [[ $? != 0 ]] ; then
  brew cask install docker
fi

docker --version

which -s docker-compose
if [[ $? != 0 ]] ; then
  curl -L https://github.com/docker/compose/releases/download/1.29.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
fi

docker-compose -v

mix deps.get
docker stop $(docker ps -a -q)
docker-compose up -d
mix ecto.setup

npm install
