#! /usr/bin/env bash

export SWIFT_BINARIES=binaries

for b in $(egrep -v "^#" etc/binaries.txt) ; do
	_name=$(basename $b)
	wget --output-document=/tmp/$_name $b
	swift upload --object-name $_name $SWIFT_BINARIES /tmp/$_name
	rm -f /tmp/$_name
done

