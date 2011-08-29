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

    # This loads all the .txt files in the specified source training text folder  
    # and creates language maps using ngram frequencies. The maps are stored in
    # lib/scylla/lms as .lm files
    def train
      languages = Dir.glob(@dirlm + "/*.lm")
      textpaths = Dir.glob(@dirtext + "/*.txt")
      languages.each {|l| File.delete(l) }
      textpaths.each do |path|
        write_lm(path)
      end
    end

    # Reads a single text file specified by a path and writes a .lm file in 
    # lib/scylla/lms
    def write_lm(path)
      text = ""
      File.open(path).each { |line| text += line.strip }
      p "Creating language map for " + path
      lm = create_lm(text, true)
      lmname = File.join(@dirlm, File.basename(path, ".txt") + ".lm")
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

    # This creates a language map for a given input string. 
    # The frequencies boolean specifies whether or not the method should
    # return the freqencies of the ngrams, or simply an array in sorted order
    def create_lm(input, frequencies = false)
      text = ""
      input.each_line {|line| text += line.strip }
      input = text
      ngram = Hash.new
      input.split(/[0-9\s]/).each do |word|
        word = "_" + word + "_";
        len = word.size
        for i in 0..word.size
          (1..5).each do |j|
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