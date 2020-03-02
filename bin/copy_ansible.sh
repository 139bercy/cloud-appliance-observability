#! /usr/bin/env bash
set -x
export ROLES=/tmp/ansible-galaxy
export SWIFT_ANSIBLE=ansible

ansible-galaxy install --roles-path=$ROLES -r etc/appliance.ansible_requirements.yml

if [ $? -ne 0 ] ; then
	exit 1
fi

cd $ROLES
tar cvf - * | swift upload $SWIFT_ANSIBLE --object-name bastion.roles.tar.gz -
cd $OLDPWD

tar cvf - * | swift upload $SWIFT_ANSIBLE --object-name bastion.autoconf.tar.gz -
