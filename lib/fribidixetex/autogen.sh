#!/bin/sh

echo -n "checking for pkg-config... "
which pkg-config || {
	echo "*** No pkg-config found, please install it ***"
	exit 1
}

echo -n "checking for autoreconf... "
which autoreconf || {
	echo "*** No autoreconf found, please install it ***"
	exit 1
}

echo "running autoreconf --force --install --verbose"
autoreconf --force --install --verbose || exit $?
