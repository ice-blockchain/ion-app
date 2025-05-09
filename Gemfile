source "https://rubygems.org"

ruby '3.4.3'

gem "fastlane"
# fastlane dependencies - https://github.com/fastlane/fastlane/issues/29183
gem "abbrev"
gem "mutex_m"
gem "ostruct"
# /fastlane dependencies

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)