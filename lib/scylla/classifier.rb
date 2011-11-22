module Scylla
  class Classifier
    attr_accessor :limit, :ngrams, :threshold, :input

    # limit    : Up to how many matching language results should be displayed
    # ngrams   : The total number of ngrams that are stored for each language
    # threshold: The threshold score for matches
    def initialize(limit = 10, ngrams = 400, threshold = 1.01)
      @limit = limit
      @ngrams = ngrams
      @threshold = threshold
    end

    # Classifies a string to a list of languages in order of best match
    def classify_string(text)
      @input = text
      classify
    end

    # Classifies a file to a list of languages in order of best match
    def classify_file(path)
      @input = ""
      File.readlines(path).each { |line| @input += " " + line.strip }
      classify
    end

    # Classifies @input to a list of languages in order of best match
    def classify
      results = Hash.new
      languages = Scylla::Loader.languages
      if languages.empty?
        p "No languages (.lm files) found in + " + Scylla::Loader.dir + ". Please run rake scylla:train after placing your training texts in the source_texts directory."
        return
      end
      sg = Scylla::Generator.new
      unknown = sg.create_lm(@input)
      languages.each_key do |key|
        ngram = languages[key]
        results[key] = get_score(unknown, ngram)
      end
      results = results.sort {|a,b| a[1]<=>b[1]}
      a = results[0][1]
      answers = [results.shift[0]]
      while (!results.empty? and results[0][1] < (@threshold * a))
        answers << results.shift[0]
      end
      return answers
    end

    # Gets the score of the text in question compared to a particular language
    def get_score(unknown, ngram)
      i, p = 0,0
      while i < unknown.size
        if (ngram[unknown[i]])
          p += (ngram[unknown[i]]-i).abs
        else
          p += @ngrams
        end
        i += 1
      end
      return p
    end
  end
end