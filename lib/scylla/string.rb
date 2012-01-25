class String

  def language
    sc = Scylla::Classifier.new
    sc.classify_string(self).first
  end

  def locale
    sc = Scylla::Classifier.new
    Scylla::Resources.locales[sc.classify_string(self).first][0]
  end

  def guess_locale
    sc = Scylla::Classifier.new
    languages = sc.classify_string(self)
    locales = []
    languages.each {|lan| locales << Scylla::Resources.locales[lan][0]}
    return locales
  end

  def guess_language
    sc = Scylla::Classifier.new
    sc.classify_string(self)
  end
end