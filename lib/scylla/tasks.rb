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
        task :train do
          sg = Scylla::Generator.new
          sg.train
        end
      end
    end
  end
end