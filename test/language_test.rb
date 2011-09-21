require 'test/helper'

class LanguageTest < Test::Unit::TestCase
  context "language detection" do
    setup do
      @sentences = Hash.new
      Dir.glob(File.join("test","fixtures","test_languages","*")).each do |language_path|
        language = language_path.split("/").last
        @sentences[language] = ""
        file = File.new(language_path, "r")
        while (line = file.gets)
         @sentences[language] += line
        end
        @sentences[language] = @sentences[language].split("\n")
      end
    end

    should "choose the correct language for strings" do
      @sentences.each_key do |key|
        @sentences[key].each do |sentence|
          next if sentence.size < 50
          p sentence if key != sentence.language
          assert_equal key, sentence.language
        end
      end
    end
  end
end
