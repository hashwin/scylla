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
    "indonesian" => "id",
    "portuguese" => "pt",
    "finnish" => "fi",
    "korean" => "ko",
    "greek" => "el",
    "bulgarian" => "bg",
    "romanian" => "ro",
    "danish" => "da",
    "hebrew" => "he",
    "slovak" => "sk",
    "welsh" => "cy",
    "catalan" => "ca",
    "thai" => "th",
    "afrikaans" => "nl"}

    def self.locales
      return @locales
    end

    def self.get_locale(name)
      return @locales[name]
    end
  end
end