require 'rubygems'
require 'bundler'
require "minitest/autorun"
# require 'test/unit'
require 'shoulda'
require 'scylla'
require 'sanitize'
require 'mocha'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

class Minitest::Test
end
