module Scylla
  class Resources
    @locales = {
    "english" => "en",
    "spanish" => "es",
    "german" => "de",
    "chinese" => "zh",
    "dutch" => "nl",
    "polish" => "pl",
    "russian" => "ru",
    "italian" => "it",
    "icelandic" => "is",
    "vietnamese" => "vi",
    "turkish" => "tr",
    "french" => "fr",
    "norwegian" => "no",
    "tagalog" => "fil",
    "japanese" => "ja",
    "arabic" => "ar",
    "slovenian" => "sl",
    "swedish" => "sv",
    "croatian" => "hr",
    "indonesian" => "id",
    "czech" => "cs",
    "portugese" => "pt",
    "finnish" => "fi",
    "korean" => "ko",
    "greek" => "el",
    "bulgarian" => "bg",
    "romanian" => "ro",
    "estonian" => "et",
    "danish" => "da",
    "hebrew" => "he",
    "slovak" => "sk",
    "bosnian" => "bs",
    "magyar" => "hu",
    "farsi" => "fa",
    "welsh" => "cy",
    "lithuanian" => "lt",
    "catalan" => "ca",
    "thai" => "th",
    "afrikaans" => "nl",
    "latvian" => "lv"}

    def self.locales
      return @locales
    end

    def self.get_locale(name)
      return @locales[name]
    end
  end
end