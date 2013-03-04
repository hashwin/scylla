module Scylla
  class Loader
    @@dir = DEFAULT_TARGET_DIR
    # Loads all the language maps once into memory using the .lm files located
    # in lib/scylla/lm
    def self.load_language_maps
      languages = Hash.new
      Dir.glob(File.join(@@dir, "*.lm")).each do |filepath|
        language = File.basename(filepath, ".lm")
        languages[language] = language_map(filepath)
      end
      return languages
    end

    def self.dir
      return @@dir
    end
    # Returns a single language map from a specified .lm file
    def self.language_map(path)
      rank, ngram = 1, Hash.new
      File.readlines(path).each do |line|
        line = line.strip.split("\t").first
        if(line =~ /^[^0-9\s]+/o)
          ngram[line] = rank
          rank += 1
        end
      end
      return ngram
    end

    def self.set_dir(dir)
      @@dir = dir
    end
    # Loads all maps from the .lm files, or loads them from memory if the 
    # files have already been read and loaded. 
    def self.languages
      @languages ||= load_language_maps
    end

    def self.clear
      @languages = nil
    end
  end
end
