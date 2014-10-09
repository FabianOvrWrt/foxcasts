#!/bin/bash

TOOLS=$(cd `dirname $0` && pwd)

echo "Working"

# application root
SRC="$TOOLS/.."

# enyo location
ENYO="$SRC/enyo"

# deploy script location
DEPLOY="$ENYO/tools/deploy.js"

# check for node, but quietly
if command -v node >/dev/null 2>&1; then
	# use node to invoke deploy with imported parameters
	echo "node $DEPLOY -T -s $SRC -o $SRC/deploy $@"
	node "$DEPLOY" -T -s "$SRC" -o "$SRC/deploy" $@
else
	echo "No node found in path"
	exit 1
fi

# copy files and package if deploying to cordova webos
while [ "$1" != "" ]; do
	case $1 in
		-w | --cordova-webos )
			# copy appinfo.json and cordova*.js files
			DEST="$TOOLS/../deploy/"${PWD##*/}
			
			cp "$SRC"/appinfo.json "$DEST" -v
			cp "$SRC"/cordova*.js "$DEST" -v
			
			# package it up
			mkdir -p "$DEST/bin"
			palm-package "$DEST/bin"
			;;
	esac
	case $1 in --fxos )
		#copy FirefoxOS files
		DEST="$TOOLS/../deploy/"

		cp -a fxos/. "$DEST"
		echo "Files copied"
	esac
	shift
done