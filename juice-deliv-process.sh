#! /bin/bash

git remote add haribo git@haribo.tls.fr.astrium.corp:juice/`basename $PWD`.git
git push haribo --all
git push haribo --tags
