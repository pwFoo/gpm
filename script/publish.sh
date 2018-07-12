#!/bin/bash

echo ̀`pwd`
ls -lha

if ! [ -x "$(command -v git)" ]; then
    echo "error: git is not installed" >&2
    exit 1
fi

if ! [ -x "$(command -v zip)" ]; then
    echo "error: zip is not installed" >&2
    exit 1
fi

if ! git lfs env &> /dev/null; then
    echo "error: git-lfs is not installed/configured" >&2
    exit 1
fi

# if [ -z "${TRAVIS_TAG}" ]; then
#     echo "error: TRAVIS_TAG is not set: publish.sh is meant to run on Travis CI and only on tags" >&2
#     exit 1
# fi

if [ -z "${GITHUB_USERNAME}" ] || [ -z "${GITHUB_TOKEN}" ]; then
    echo "error: GITHUB_USERNAME and GITHUB_TOKEN must be set" >&2
    exit 1
fi

if [ ! -f "gpm" ]; then
    echo "error: gpm must be built before publishing"
    exit 1
fi

VERSION=`grep -Po '(?<=version = ")[0-9\.]+' Cargo.toml`

git clone https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@github.com/aerys/gpm-packages.git
mkdir -p gpm-packages/gpm-linux64
cd gpm-packages/gpm-linux64
rm -rf gpm.zip
zip gpm.zip gpm
git add gpm.zip
git commit gpm.zip -m "Publish gpm-linux64 version ${VERSION}."
git tag gpm-linux64/${VERSION}
git push
git push --tags