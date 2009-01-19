$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module SparkleTools
  VERSION = '0.0.1'
end

require "fileutils"
require "builder"
require "sparkle_tools/appcast"

require "rubygems"
require "active_support"