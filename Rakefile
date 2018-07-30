XCODE_WORKSPACE="TiketReactions.xcworkspace"
XCODE_SCHEME="TiketReactions"
XCODE_CONFIGURATION="Debug"

require 'fileutils'
require 'tmpdir'
require 'rake/clean'
PROJECT_DIR = File.expand_path(File.dirname(__FILE__))

task default: %w[test]

desc "Install required dependencies"
task :dependencies => %w[dependencies:check]
