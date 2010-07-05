require "bundler"
Bundler.setup
Bundler.require :spec

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'choctop'
