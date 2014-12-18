#! /bin/bash

cd _site
rsync -acv . ssh-w005d352@w005d352.kasserver.com:/blog/
cd ..
