module Scylla
  class Resources
    @locales = {
    "english" => ["en", "England"],
    "spanish" => ["es", "España"],
    "german" => ["de", "Deutschland"],
    "chinese" => ["zh", "中國"],
    "persian" => ["fa", "ایران"],
    "dutch" => ["nl", "Nederland"],
    "polish" => ["pl", "Polska"],
    "russian" => ["ru", "Россия"],
    "italian" => ["it", "Italia"],
    "icelandic" => ["is","Ísland"],
    "vietnamese" => ["vi", "Việt Nam"],
    "turkish" => ["tr", "Türkiye"],
    "french" => ["fr","France"],
    "norwegian" => ["no","Norge"],
    "tagalog" => ["tl","Pilipinas"],
    "japanese" => ["ja", "日本"],
    "arabic" => ["ar","السعودية"],
    "slovenian" => ["sl","Slovenija"],
    "swedish" => ["sv","Sverige"],
    "indonesian" => ["id","Indonesia"],
    "portuguese" => ["pt","Brasil"],
    "finnish" => ["fi","Suomi"],
    "korean" => ["ko","한국"],
    "greek" => ["el","Ελλάδα"],
    "bulgarian" => ["bg","България"],
    "romanian" => ["ro","România"],
    "danish" => ["da","Danmark"],
    "hebrew" => ["he","ישראל"],
    "slovak" => ["sk","Slovensko"],
    "welsh" => ["cy","cymru"],
    "catalan" => ["ca","Catalunya"],
    "thai" => ["th","ประเทศไทย"],
    "afrikaans" => ["af","Afrikaanse"],
    "czech" => ["cs", "Československo"],
    "hindi" => ["hi", "भारत"],
    "kannada" => ["kn","ಕರ್ನಾಟಕ"],
    "marathi" => ["mr","महाराष्ट्र"]
  }

    def self.locales
      return @locales
    end

    def self.get_locale(name)
      return @locales[name][0]
    end

    def self.get_article(name)
      return @locales[name][1]
    end
  end
end