require 'test/helper'

class ScyllaTest < Test::Unit::TestCase
  context "String methods" do
    setup do
      text = "Hello, is there anybody in there? Just nod if you can hear me. Is there anyone at home? Come on, now. I hear you're feeling
              down. I can ease the pain, put you on your feet again. Relax, I need some information first. Just the basic facts, can you
              show me where it hurts?"
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
