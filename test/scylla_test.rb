require 'test/helper'

class ScyllaTest < Test::Unit::TestCase
  context "String methods" do
    setup do
      text = "Hello? Is there anybody in there?"
      @language = text.language
      @languages = text.guess
    end

    should "load language results for strings" do
      assert_not_nil @language
      assert_not_nil @languages
      assert String, @language.class
      assert Array, @languages.class
      assert_equal "english", @language
      assert_equal "english", @languages.first
    end
  end
end
