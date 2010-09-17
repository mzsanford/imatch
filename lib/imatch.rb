
require 'set'
require 'digest/sha1'

# gem install stemmer (Porter stemmer implementation)
require 'stemmer'

require 'lexicon'

class IMatch
  VERSION = '0.1.0'
  DEFAULT_LEXICON_FILE = File.join(File.dirname(__FILE__), 'data', 'en.dat')
  DEFAULT_NUMBER_OF_LEXICONS = 0
  DEFAULT_LEXICON_FRACTION = 0.66

  def initialize(file = DEFAULT_LEXICON_FILE, options = {})
    @lexicon = IMatch::Lexicon.new(file).freeze
    @stop_words = (options[:stop_words] || []).to_set

    @should_stem = !!options[:stemming]

    @number_of_lexicons = (options[:lexicons] || DEFAULT_NUMBER_OF_LEXICONS).to_i
    @lexicon_fraction = (options[:lexicon_fraction] || DEFAULT_LEXICON_FRACTION).to_f
    @subsets = []
    if @number_of_lexicons > 0
      @number_of_lexicons.times { @subsets << @lexicon.subset(@lexicon_fraction) }
    end
  end

  def multiple_signatures(string, tokenize = /\s+/)
    signatures = Set.new

    if sig = signature(string, tokenize)
      signatures << sig
    end

    @subsets.each do |lex|
      if sig = signature(string, tokenize, lex)
        signatures << sig
      end
    end

    signatures
  end

  def signature(string, tokenize = /\s+/, lexicon = nil)
    return nil unless string

    tokens = string.split(tokenize)
    return nil if tokens.empty?

    current_lexicon = lexicon || @lexicon

    usable_tokens = Set.new
    tokens.each do |t|
      token = t.downcase
      token = token.stem if @should_stem && token.respond_to?(:stem)

      next if @stop_words.include?(token)
      next unless current_lexicon.include?(token)

      usable_tokens << token
    end

    return nil if usable_tokens.empty?

    finger_print(usable_tokens.to_a.sort) unless tokens.empty?
  end

  def lexicon
    @lexicon
  end

  def to_s
    %Q{<IMatch stemming="#{@should_stem}" stop_word_count="#{@stop_words.size}">#{@lexicon.to_s}</IMatch>}
  end

  private

  def finger_print(tokens)
    digest = Digest::SHA1.new
    tokens.each{|t| digest.update(t) }
    digest.to_s
  end
end
