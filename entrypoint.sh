#!/bin/bash

if [ -d ~/hosthome/.ssh ]; then
    rm -r ~/.ssh
    cp -r ~/hosthome/.ssh ~
    chmod -R go-rwx ~/.ssh
fi

if [ -f ~/hosthome/.gitconfig ]; then
    rm -r ~/.gitconfig
    ln -s ~/hosthome/.gitconfig ~/.gitconfig
fi

if [ -d ~/hosthome/.docker ]; then
    rm -r ~/.docker
    ln -s ~/hosthome/.docker ~/.docker
fi

stty erase ^H

exec "$@"
