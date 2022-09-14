#!/usr/bin/env bash

# GPL-2.0-or-later

# inspired by https://github.com/gentoo-audio/audio-overlay

# DISCLAIMER:
# this script is recommended to be executed inside a docker container
# don't execute it on your local machine because I don't know what I am doing.

set -e

EBUILDS=`find . | grep -e "\.ebuild$" | egrep -v '.+9999(-r[0-9]+)?.ebuild' | cut -c 3- | sed 's/\/.*\//\//' | sed 's/.......$//'`

echo "Emerging the following ebuilds: ${EBUILDS[@]}"

# copy the repo in a very well known location
mkdir -p /usr/local/portage
mkdir -p /etc/portage/repos.conf
cp -r . /usr/local/portage
cp .github/localrepo.conf /etc/portage/repos.conf/localrepo.conf

# Accepting every license for every package at any version (not a good idea)
echo "*/* *" > /etc/portage/package.license

# pretend to emerge the ebuilds in a clean stage3
for i in $EBUILDS
do
  echo $i
  echo "=$i ~amd64" > /etc/portage/package.accept_keywords/zz-autounmask
  emerge "=$i" --autounmask --autounmask-write --autounmask-backtrack=y || true
  echo yes | etc-update --automode -3
  emerge "=$i" --pretend || exit 1
done
