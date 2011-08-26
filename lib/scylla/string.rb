class String
  def guess
    sc = Scylla::Classifier.new
    sc.classify_string(self)
  end

  def language
    sc = Scylla::Classifier.new
    sc.classify_string(self).first
  end
end