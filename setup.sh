#!/bin/sh

#Commend line Color
title_color="\033[1;33m"
success_color="\033[1;32m"
fail_color="\033[1;31m"
defualts_color="\033[0m"
version_color="\033[37m"

#Constant
SL_VERSION=`swiftlint version 2> /dev/null`
SL_INSTALL_VERSION="0.39.2"
SL_DOWNLOAD_URL="https://homebrew.bintray.com/bottles/swiftlint-${SL_INSTALL_VERSION}.catalina.bottle.tar.gz"

SF_VERSION=`swiftformat --version 2> /dev/null`
SF_INSTALL_VERSION="0.44.15"
SF_DOWNLOAD_URL="https://homebrew.bintray.com/bottles/swiftformat-${SF_INSTALL_VERSION}.catalina.bottle.tar.gz"

# Install brew
if ! which brew > /dev/null; then
	echo "${title_color}Install brew...${defaults_color}"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Install swiftLint
echo "..."
echo "..."
echo "${title_color}Install swiftlint${defaults_color}"

if ! which swiftlint > /dev/null; then
	brew install ${SL_DOWNLOAD_URL}
	swiftlint_local_version=`swiftlint version 2> /dev/null`
	echo "${title_color}swiftlint is installed${defaults_color}"
elif [ "${SL_VERSION}" == "${SL_INSTALL_VERSION}" ]; then
	echo "${title_color}swiftlint is already installed${defaults_color}"
fi

if [ "${SL_VERSION}" != "${SL_INSTALL_VERSION}" ] ; then
	if [ "${SL_VERSION}"="" ] ; then
		SL_VERSION="none"
    fi
    echo "${title_color}swiftLint version (${SL_VERSION}) mismatch.${defaults_color}"
    brew uninstall swiftlint
	brew install ${SL_DOWNLOAD_URL}
	SL_VERSION=`swiftlint version 2> /dev/null`
	echo "${title_color}swiftlint is installed${defaults_color}"
fi

 # Install swiftFormat
echo "..."
echo "..."
echo "${title_color}Install swiftformat${defaults_color}"

if ! which swiftformat > /dev/null; then
	brew install ${SF_DOWNLOAD_URL}
	SF_VERSION=`swiftformat --version 2> /dev/null`
	echo "${title_color}swiftformat is installed${defaults_color}"
elif [ "${SF_VERSION}" == "${SF_INSTALL_VERSION}" ]; then
	echo "${title_color}swiftformat is already installed${defaults_color}"
fi

if [ "${SF_VERSION}" != "${SF_INSTALL_VERSION}" ]; then
	if [ "${SF_VERSION}" = "" ]; then
		SF_VERSION = "none"
    fi
    echo "${title_color}swiftformat version (${SF_VERSION}) mismatch.${defaults_color}"
    brew uninstall swiftformat
	brew install ${SF_DOWNLOAD_URL}
	swiftformat_local_version=`swiftformat --version 2> /dev/null`
	echo "${title_color}swiftformat is installed${defaults_color}"
fi

# Install fastlane
echo "..."
echo "..."
echo "${title_color}Install fastlane${defaults_color}"
brew install fastlane

echo "${success_color}"
echo "================================"
echo "Success Setup DAYOL-iOS Project"
echo "================================"
echo "${defualts_color}"
