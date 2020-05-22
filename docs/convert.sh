export _OUTPUT=buffer.md
for input in $@ ; do
	if [ -f $input ] ; then
		export split_line=$(head $input | grep -n "^$" | head -n1 | awk -F: '{print $1}')
		sed 1,${split_line}d $input >> $_OUTPUT
		echo >> $_OUTPUT
	fi
done
