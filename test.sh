#!/bin/bash

set -e

version=$1
factorio=$2
modname=$(grep '"name":' templates/info.json | awk -F '"' '{print $4}')

[ -z "$version" ] && (echo "expected version" 1>&2; exit 1)
[ -z "$factorio" ] && (echo "expected factorio path" 1>&2; exit 1)

sed -r "s/VERSION/${version}/" templates/info.json > info.json

rm -f migrations/*.lua
cp templates/update-techs-recipes.lua migrations/${version}-techs-recipes.lua

mod="${modname}_${version}"

rm -rf $factorio/mods/$modname*
cp -r $(pwd) $factorio/mods/$mod
