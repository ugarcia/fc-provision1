#!/bin/bash

CURRENT_DIR=$(pwd)
BASEDIR=$(dirname $0)
PUPPET_SRC_HOME="$BASEDIR/puppet"
PUPPET_SRC_MODULES_PATH="$PUPPET_SRC_HOME/modules"
PUPPET_SRC_CUSTOM_MODULES_PATH="$PUPPET_SRC_HOME/fc_modules"
PUPPET_MODULES_PATH="$PUPPET_SRC_MODULES_PATH:$PUPPET_SRC_CUSTOM_MODULES_PATH"
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
        echo "Installing $p"
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
    cp $BASEDIR/Puppetfile $PUPPET_SRC_HOME/
    cd $PUPPET_SRC_HOME
    librarian-puppet install --verbose 
    cd $CURRENT_DIR
}

function apply_puppet()
{
    sudo puppet apply --confdir="$PUPPET_SRC_HOME" --modulepath="$PUPPET_MODULES_PATH"  --hiera_config="$PUPPET_SRC_HOME/hiera.yaml" --verbose --debug "$PUPPET_SRC_MAIN_MANIFEST"
    # sudo puppet apply --config="$PUPPET_SRC_HOME/puppet.conf" --verbose --debug "$PUPPET_SRC_MAIN_MANIFEST"    
}

# install_packages
# install_gems
# install_modules
apply_puppet


