require 'test/helper'

class LoaderTest < Test::Unit::TestCase
  context "#languages" do
    setup do
      Scylla::Loader.clear
      Scylla::Loader.set_dir(File.join("test","fixtures","lms"))
      @englm = 'test/fixtures/lms/english.lm'
    end

    context "when being read" do
      should "only load from disk once" do
       Scylla::Loader.expects(:load_language_maps).once.returns([])
        Scylla::Loader.languages
        Scylla::Loader.languages
        Scylla::Loader.unstub(:load_language_maps)
      end
    end
    
    should "load the correct map for a language" do
      map = Scylla::Loader.language_map(@englm)
      rank = 1
      File.readlines(@englm).each do |line|
        set = line.split("\t")
        key = set.first
        value = set.last.strip.to_i
        assert_equal rank, map[key]
        rank += 1
      end
    end
  end
end