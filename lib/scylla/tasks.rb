require 'rake'
require 'rake/tasklib'

module Scylla
  class Tasks < ::Rake::TaskLib
    def initialize
      define_training_task
    end

    def define_training_task
      namespace :scylla do
        desc "Trains Scylla in new languages"
        task :train, :dir do |t, args|
          args.with_defaults(:dir => DEFAULT_SOURCE_DIR)
          sg = Scylla::Generator.new(args[:dir])
          sg.train
        end
      end
    end
  end
end