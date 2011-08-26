require 'test/helper'

class GeneratorTest < Test::Unit::TestCase
  context "create_lm ngrams" do
    setup do
      @text = "hello"
      @ngram = ["_", "l", "lo_", "ello", "lo", "o", "llo", "hel", "o_", "ell", "e", "ello_",
       "_he", "el", "hello", "hell", "he", "_hel", "h", "_hell", "llo_", "_h", "ll"]
      @ngram_frequencies =  [["_", 2], ["l", 2], ["lo_", 1], ["ello", 1], ["lo", 1], ["o", 1],
       ["llo", 1], ["hel", 1], ["o_", 1], ["ell", 1], ["e", 1], ["ello_", 1], ["_he", 1], 
       ["el", 1], ["hello", 1], ["hell", 1], ["he", 1], ["_hel", 1], ["h", 1], ["_hell", 1],
       ["llo_", 1], ["_h", 1], ["ll", 1]] 
    end

    should "create an array of ngrams for a given text input" do
      sg = Scylla::Generator.new
      ngram_result = sg.create_lm(@text)
      ngram_result.each do |res|
        assert @ngram.include?(res)
      end
    end

    should "create an array of ngrams with their associated frequencies for a given text input" do
      sg = Scylla::Generator.new
      ngram_result = sg.create_lm(@text, true)
      ngram_result.each do |res|
        assert @ngram_frequencies.include?(res)
      end
    end
  end

  context "create .lm files out of text files" do
    setup do
      @engtext = 'test/fixtures/source_texts/english.txt'
      @englm = 'test/fixtures/lms/english.lm'
      @sg = Scylla::Generator.new('test/fixtures/source_texts', 'test/fixtures/lms')
      languages = Dir.glob("**/*.lm")
      text = ""
      File.readlines(@engtext).each {|line| text += line }
      @map = @sg.create_lm(text, true)
    end

    should "create lm file out of text file" do
      path = 'test/fixtures/source_texts/english.txt'
      @sg.write_lm(path)
      i = 0
      File.readlines(@englm).each do |line|
        break if i > 400
        set = line.split("\t")
        key = set.first
        value = set.last.strip.to_i
        assert_equal value, @map[i][1]
        i += 1
      end
    end

    should "create .lm files in bulk" do
      @sg.train
      languages = Dir.glob("**/*.lm")
      assert_equal 8, languages.size
      i = 0
      File.readlines(@englm).each do |line|
        break if i > 400
        set = line.split("\t")
        key = set.first
        value = set.last.strip.to_i
        assert_equal value, @map[i][1]
        i += 1
      end
    end
  end
end
