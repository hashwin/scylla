# encoding: utf-8
require 'sanitize'
require 'cgi'
require 'unicode'

module Scylla
  class Generator
    attr_accessor :dirtext, :dirlm, :minsize, :delimiter
    NONLATIN = ["bg","ar","ru","zh","ja","he","kn","ko","mr","hi","th","fa","el","uk"]
    # dirtext: The location of the source training text files
    # minsize: The minimum size of the ngrams that you would like to store
    def initialize(dirtext = DEFAULT_SOURCE_DIR, dirlm = DEFAULT_TARGET_DIR, minsize = 0, silent = false, delimiter = "[[classifier_delimiter]]")
      @dirtext = dirtext
      @dirlm   = dirlm
      @minsize = minsize
      @delimiter = delimiter
    end

    # Loads all the .txt files in the specified source training text folder  
    # and creates language maps using ngram frequencies. The maps are stored in
    # lib/scylla/lms as .lm files
    def train
      languages = Dir.glob(@dirlm + "/*.lm")
      languages.each {|l| File.delete(l) }
      locales = Scylla::Resources.locales
      get_wikis
      locales.each do |key, value|
        path = File.join(@dirtext, "#{key}.txt")
        text = ""
        File.open(path).each { |line| text += " " + line }
        write_lm(text, key)
        File.delete(path)
      end
    end
    
    def get_wikis
      require 'wikipedia'
      locales = Scylla::Resources.locales
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
      value = page.raw_data['query']['pages'].values.first['revisions'].first.fetch('*')
      value = value.force_encoding("UTF-8").chars.select {|c| c.valid_encoding?}.join
      value = value.gsub(/\{\{(.*?)\}\}/,"")
      value = value.gsub(/\[\[(.+?)\]\]/m,"")
      value = value.gsub(/\{\{(.+?)\}\}/m,"")
      value = value.gsub(/\{(.+?)\}/m,"")
      value = value.gsub(/\[(.+?)\]/m,"")
      value = Sanitize.clean(value)
      value = value.gsub(/[a-zA-Z]/,"") if NONLATIN.include?(locale)
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
      delimit = string.index(@delimiter)
      string = string[0, delimit] if delimit
      string = Sanitize.clean(string)
      string = CGI.unescapeHTML(string)
      string.gsub!(/(?:http|https):\/\/[a-z0-9]+(?:[\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(?:(?::[0-9]{1,5})?\/[^\s]*)?/, "")
      string.gsub!(/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/, "")
      string.gsub!(/[\*\^><!\"#\$%&\'\(\)\*\+:;,._\/=\?@\{\}\[\]|\-\n\r0-9]/," ")
      latin, nonlatin = string.scan(/[a-zA-Z]/), string.scan(/[\p{L}&&[^a-zA-Z]]/)
      string.gsub!(/[a-zA-Z]/, "") if !latin.empty? && !nonlatin.empty? && nonlatin.size/(latin.size*1.0) > 0.5
      Unicode::upcase(string.strip.split(" ").join(" "))
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
