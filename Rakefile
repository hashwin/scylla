# encoding: utf-8
$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), "lib")))

require 'rubygems'
require 'bundler'
require 'rake/testtask'
require 'bundler/gem_tasks'
require 'scylla'
require 'scylla/tasks'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test
Scylla::Tasks.new