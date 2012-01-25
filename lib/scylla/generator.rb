require 'sanitize'
require 'cgi'
require 'wikipedia'

module Scylla
  class Generator
    attr_accessor :dirtext, :dirlm, :minsize

    # dirtext: The location of the source training text files
    # minsize: The minimum size of the ngrams that you would like to store
    def initialize(dirtext = DEFAULT_SOURCE_DIR, dirlm = DEFAULT_TARGET_DIR, minsize = 0, silent = false)
      @dirtext = dirtext
      @dirlm   = dirlm
      @minsize = minsize
    end

    # Loads all the .txt files in the specified source training text folder  
    # and creates language maps using ngram frequencies. The maps are stored in
    # lib/scylla/lms as .lm files
    def train
      languages = Dir.glob(@dirlm + "/*.lm")
      languages.each {|l| File.delete(l) }
      locales = Scylla::Resources.locales
      locales.each do |key, value|
        text = get_wiki(value[0],value[1])
        write_lm(text, key)
      end
    end
    
    def generate_sources
      locales.each do |key, value|
        text = get_wiki(value[0],value[1])
        textname = File.join(@dirtext, "#{key}.txt")
        File.delete(textname) if File.exists?(textname)
        File.open(textname, 'w') { |f| f.write(text) }
      end
    end

    def get_wiki(locale,article)
      Wikipedia.Configure {
        domain "#{locale}.wikipedia.org"
        path   'w/api.php'
      }
      p article
      page = Wikipedia.find( article )
      textname = File.join(@dirtext, "#{locale}-original.txt")
      File.open(textname, 'w') { |f| f.write(page.content) }
      value = Sanitize.clean(page.content)
      value = value.gsub(/(\[\[|\{\{|\{)(.+?)(\]\]|\}\}|\})/,"")
      clean(value)
    end

    # Reads a single text file specified by a path and writes a .lm file in 
    # lib/scylla/lms
    def write_lm(text, language)
      p "Creating language map for #{language}"
      lm = create_lm(text, true)
      lmname = File.join(@dirlm, "#{language}.lm")
      File.delete(lmname) if File.exists?(lmname)
      File.open(lmname, 'w') do |f|
        i = 0
        lm.each do |freq|
          break if i == 400
          f.write(freq[0] + "\t" + freq[1].to_s + "\n")
          i += 1
        end
      end
    end

    def clean(string)
      string = Sanitize.clean(string)
      string = CGI.unescapeHTML(string)
      string.gsub!(/(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/, "")
      string.gsub!(/[\*\^><!\"#\$%&\'\(\)\*\+:;,._\/=\?@\{\}\[\]|\-\n\r0-9]/," ")
      string.strip.split(" ").join(" ").downcase
    end

    # Creates a language map for a given input string. 
    # The frequencies boolean specifies whether or not the method should
    # return the freqencies of the ngrams, or simply an array in sorted order
    def create_lm(input, frequencies = false)
      input = clean(input)
      ngram = Hash.new
      input.split(/[\d\s\[\]]/).each do |word|
        word = "_" + word + "_";
        len = word.size
        for i in 0..word.size
          for j in (1..3)
          next unless word[i,j]
          ngram[word[i,j]] ||= 0
          ngram[word[i,j]] += 1 if (len > (j - 1))
          end
          len = len - 1
        end
      end
      ngram.each_key do |key|
        ngram.delete(key) if key.size <= @minsize
      end
      ngram = ngram.sort {|a,b| b[1] <=> a[1]}
      return ngram if frequencies
      sorted = []
      ngram.each {|key| sorted << key[0]}
      return sorted
    end
  end
end 