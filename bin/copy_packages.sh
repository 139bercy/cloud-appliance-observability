#! /usr/bin/env bash

export SWIFT_PACKAGES=packages
export TMP_PACKAGES=/tmp/packages

if ! [ -f /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list ] ; then
	sudo sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_18.04/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"
	wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/xUbuntu_18.04/Release.key -O Release.key
	sudo apt-key add - < Release.key
	sudo apt-get update
fi

mkdir $TMP_PACKAGES

for b in $(egrep -v "^#" etc/packages.txt) ; do
	_name=$(basename $b)
	cd $TMP_PACKAGES
	apt download $b
	swift upload $SWIFT_PACKAGES $_name*
	rm -f $_name*
	cd -
done
