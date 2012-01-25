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
      locales.each_key do |key|
        Wikipedia.Configure {
          domain "#{locales[key][0]}.wikipedia.org"
          path   'w/api.php'
        }
        p key
        page = Wikipedia.find( locales[key][1] )
        
        value = page.content.gsub(/(\[\[|\{\{)(.+?)(\]\]|\}\})/,"")
        write_lm(value, key)
      end
    end

    # Reads a single text file specified by a path and writes a .lm file in 
    # lib/scylla/lms
    def write_lm(text, language)
      p "Creating language map for #{language}"
      textname = File.join(@dirtext, "#{language}.txt")
      File.delete(textname) if File.exists?(textname)
      File.open(textname, 'w') { |f| f.write(text) }
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
            next unless word[i,2]
            ngram[word[i,2]] ||= 0
            ngram[word[i,2]] += 1 if (len > (2 - 1))
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