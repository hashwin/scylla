require 'test/helper'

class ClassifierTest < Test::Unit::TestCase

  context "#classify" do
    setup do
      @entext = "Please allow me to introduce myself, I'm a man of wealth and taste."
      @frtext = "Veux-tu m'épouser? C'est juste une blague."
      @detext = "Alle warten auf das Licht, fürchtet euch fürchtet euch nicht"
      @estext = "Que hora son mi corazon. Te lo dije bien clarito."
      @datext = "Gennem anstrengelser når man stjernerne."
      @sc = sc = Scylla::Classifier.new
    end

    should "correctly identify the languages based on the given text" do
      assert_equal Array, @sc.classify_string(@entext).class
      assert_equal "english", @sc.classify_string(@entext).first
      assert_equal "french", @sc.classify_string(@frtext).first
      assert_equal "german", @sc.classify_string(@detext).first
      assert_equal "spanish", @sc.classify_string(@estext).first
      assert_equal "danish", @sc.classify_string(@datext).first
    end

    should "correctly identify the language based on a given file" do
      path = 'test/fixtures/source_texts/english.txt'
      assert_equal "english", @sc.classify_file(path).first
    end
  end
end
