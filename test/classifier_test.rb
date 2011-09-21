require 'test/helper'

class ClassifierTest < Test::Unit::TestCase

  context "#classify" do
    setup do
      Scylla::Loader.set_dir(File.join("test","fixtures","lms"))
      @entext = "Please allow me to introduce myself, I'm a man of wealth and taste."
      @frtext = "Veux-tu m'épouser? C'est juste une blague."
      @detext = "Alle warten auf das Licht, fürchtet euch nicht"
      @estext = "Que hora son mi corazon. Te lo dije bien clarito."
      @datext = "Gennem anstrengelser når man stjernerne."
      @jptext = " ラ゜珥 ドゥ背騥ヴェ祟 ウァ諤椺と䤎 覥ヒュぱカキャ ゝド"
      @hitext = "ಚಿತ್ರಲಿಪಿಯಿಂದ ಹಿಡಿದು ಇಂದಿನ ಮುದ್ರಣ— ಕಂಪ್ಯೂಟರ್"
      @lstext = "wtf j00 t41k1n b0ut"
      @sc = sc = Scylla::Classifier.new
    end

    should "correctly identify the languages based on the given text" do
      assert_equal Array, @sc.classify_string(@entext).class
      assert_equal "english", @sc.classify_string(@entext).first
      assert_equal "french", @sc.classify_string(@frtext).first
      assert_equal "german", @sc.classify_string(@detext).first
      assert_equal "spanish", @sc.classify_string(@estext).first
      assert_equal "danish", @sc.classify_string(@datext).first
      assert_equal "japanese", @sc.classify_string(@jptext).first
      assert_equal "hindi", @sc.classify_string(@hitext).first
      assert_equal "13375p33k", @sc.classify_string(@lstext).first
    end

    should "correctly identify the language based on a given file" do
      path = 'test/fixtures/source_texts/english.txt'
      assert_equal "english", @sc.classify_file(path).first
    end
  end
end
