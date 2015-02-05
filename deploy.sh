#! /bin/bash

cd _site
rsync -r ./ ssh-w005d352@w005d352.kasserver.com:/blog/
cd ..
