#!/bin/bash

CURRENT_DIR=$(pwd)
BASEDIR=$(dirname $0)
PUPPET_SRC_HOME="$BASEDIR/puppet"
PUPPET_SRC_MAIN_MANIFEST="$PUPPET_SRC_HOME/manifests/init.pp"

PACKAGES=(
    "git-core" 
    "puppet"
    "ruby-dev"
)

GEMS=(
    "librarian-puppet"
)

function err()
{
    echo "ERROR: $1" 1>&2
    exit 1
}

function install_packages()
{
    for p in "${PACKAGES[@]}"; do
        echo "Installing PACKAGE $p"
        res=$(sudo apt-get install --yes $p)
        if [ ! $? -eq 0 ]; then
            err "Installing $p"
        fi
    done    
}

function install_gems()
{
    for p in "${GEMS[@]}"; do
        echo "Installing GEM $p"
        res=$(sudo gem install $p)
        if [ ! $? -eq 0 ]; then
            err "Installing GEM $p"
        fi
    done    
}

function install_modules()
{
    cd $PUPPET_SRC_HOME
    echo "Installing PUPPET LIBRARY MODULES"
    librarian-puppet install --verbose 
    cd $CURRENT_DIR
}

function apply_puppet()
{
    sudo puppet apply --confdir="$PUPPET_SRC_HOME" --verbose --debug --trace "$PUPPET_SRC_MAIN_MANIFEST"    
}

# install_packages
# install_gems
# install_modules
apply_puppet


