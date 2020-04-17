#! /usr/bin/env bash

export SWIFT_CONTAINERS=containers

process_container() {
	export directory=$(echo $1 | awk -F: '{print $1}')

	mkdir -p $i
	skopeo copy docker://$i oci:$i
	swift upload $SWIFT_CONTAINERS $directory
	rm -rf $(echo $i | awk -F/ '{print $1}')

}

# Get docker images from etc/containers.csv
for i in $(grep -v ^# etc/containers.txt) ; do
	process_container $i
done
