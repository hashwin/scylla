require 'test/helper'

class ClassifierTest < Test::Unit::TestCase

  context "#classify" do
    setup do
      @entext = "Please allow me to introduce myself, I'm a man of wealth and taste. I've been around for a long, long year, stole many a man's soul and faith"
      @frtext = "Je viens de là ou le soleil brille ou les gens se parlent sans se connaître, Et vaincra même l'écho de la ville, Et les oiseaux chantent à la fenêtre"
      @detext = "Alle warten auf das Licht, fürchtet euch fürchtet euch nicht, Die Sonne scheint mir aus den Augen, sie wird heut Nacht nicht untergehen und die Welt zählt laut bis zehn"
      @estext = "Que hora son mi corazon. Te lo dije bien clarito. Permanece a la escucha. Permanece a la escucha 12 de la noche en La Habana, Cuba"
      @sc = sc = Scylla::Classifier.new
    end

    should "correctly identify the languages based on the given text" do
      assert_equal Array, @sc.classify_string(@entext).class
      assert_equal "english", @sc.classify_string(@entext).first
      assert_equal "french", @sc.classify_string(@frtext).first
      assert_equal "german", @sc.classify_string(@detext).first
      assert_equal "spanish", @sc.classify_string(@estext).first
    end

    should "correctly identify the language based on a given file" do
      path = 'test/fixtures/source_texts/english.txt'
      assert_equal "english", @sc.classify_file(path).first
    end
  end
end
