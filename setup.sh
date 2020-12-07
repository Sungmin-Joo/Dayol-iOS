#Commend line Color
title_color="\033[1;33m"
success_color="\033[1;32m"
fail_color="\033[1;31m"
defualts_color="\033[0m"
version_color="\033[37m"

# Install brew
if ! which brew > /dev/null; then
	echo "${title_color}Install brew...${defaults_color}"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Install swiftLint
echo "..."
echo "..."
echo "${title_color}Install swiftlint${defaults_color}"
brew install swiftlint

# Install swiftFormat
echo "..."
echo "..."
echo "${title_color}Install swiftformat${defaults_color}"
brew install swiftformat

# Install fastlane
echo "..."
echo "..."
echo "${title_color}Install fastlane${defaults_color}"
brew install fastlane

# Install CocoaPod
if ! command -v pod ;then
	echo "${title_color}* Cocoapods install...${defualts_color}"
	sudo gem install cocoapods
else
	echo "${title_color}* Cocoapods update...${defualts_color}"
	sudo gem update cocoapods
fi

cocoaPods_version=$(pod --version)
echo "${success_color}Cocoapods Version: ${cocoaPods_version}${defualts_color}"

echo ""
echo "${title_color}* pod clean...${defualts_color}"
pod deintegrate
pod cache clean --all
rm -rf Podfile.lock

echo ""
echo "${title_color}* pod install...${defualts_color}"
pod install

echo "${success_color}"
echo "================================"
echo "Success Setup DAYOL-iOS Project"
echo "================================"
echo "${defualts_color}"
