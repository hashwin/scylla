# encoding: utf-8
module Scylla
  DEFAULT_SOURCE_DIR = File.join(File.dirname(__FILE__), "..", "source_texts")
  DEFAULT_TARGET_DIR = File.join(File.dirname(__FILE__), "scylla", "lms")

  def self.version
    "0.5.0"
  end
end

require 'scylla/classifier'
require 'scylla/generator'
require 'scylla/loader'
require 'scylla/string'
require 'scylla/resources'