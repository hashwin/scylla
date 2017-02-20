require 'helper'

class GeneratorTest < Minitest::Test
  context "create_lm ngrams" do
    setup do
      Scylla::Loader.set_dir(File.join("test","fixtures","lms"))
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

  context "#clean" do
    setup do
      @bad_text = "***Hello*** Go to http://www.youtube.com to watch some shitty videos."
      @bad_text += ">>> Woooooo <<< <a href='blah.com/no'>friend</a> WIN TODAY!!!!"
      @bad_text += "???? @#!!(**%#)} [[}}||]]"
      @sg = Scylla::Generator.new
    end

    should "Remove characters that throw off language detection" do
      assert_equal "hello go to to watch some shitty videos woooooo friend win today", @sg.clean(@bad_text)
    end
  end
end
