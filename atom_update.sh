#!/bin/bash
# Update atom from downloaded deb file
rm -rf /tmp/atom.deb
curl -L https://atom.io/download/deb > /tmp/atom.deb
sudo dpkg --install /tmp/atom.deb 

echo "***** apm upgrade - to ensure we update all apm packages *****"
apm upgrade
