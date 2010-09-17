require "test/unit"
require "imatch"

class InvalidLexiconError < Exception; end;

class TestIMatch < Test::Unit::TestCase

  def test_defines_imatch_class
    assert IMatch
    assert IMatch.kind_of?(Class)
  end

  def test_initalize_with_no_args_loads_the_default_lexicon
    imatch = IMatch.new
    assert imatch
    assert imatch.lexicon, "expected a lexicon"
    assert imatch.lexicon.size > 0, "Didn't expect a blank lexicon"
  end

  def test_nil_input_creates_nil_output
    assert_nil IMatch.new.signature(nil)
  end

  def test_known_imatch_score
    signature = IMatch.new.signature('foo bar')
    assert signature.kind_of?(String)
    assert_equal '60518c1c11dc0452be71a7118a43ab68e3451b82', signature
  end

  def test_imatch_consistent
    assert_equal IMatch.new.signature('foo bar'), IMatch.new.signature('foo bar')
  end

  def test_imatch_unordered
    assert_equal IMatch.new.signature('foo bar'), IMatch.new.signature('bar foo')
  end

  def test_imatch_simple_plurals_if_stemming_enabled
    imatch_stemming = IMatch.new(IMatch::DEFAULT_LEXICON_FILE, :stemming => true)
    imatch_non_stemming = IMatch.new
    assert_equal imatch_stemming.signature('follower'), imatch_stemming.signature('followers'), "Failed to stem when enabled"
    assert_not_equal imatch_non_stemming.signature('follower'), imatch_non_stemming.signature('followers')
  end

  def test_stop_words_skipped
    imatch = IMatch.new(IMatch::DEFAULT_LEXICON_FILE, :stop_words => ['a'])
    assert_nil imatch.signature("a")
    assert_equal imatch.signature("foo"), imatch.signature("a foo")
  end

  def test_skipping_unknown_terms
    imatch = IMatch.new
    assert !imatch.lexicon.include?('{{example}}')
    assert_nil imatch.signature('{{example}}')
    assert_equal imatch.signature("string"), imatch.signature("{{example}} string")
  end

  def test_alternate_splitting
    assert_equal IMatch.new.signature('F 16'), IMatch.new.signature('F-16', /\W+/)
  end

  def test_to_s
    imatch = IMatch.new
    str = imatch.to_s
    assert str.include?("stemming=\"false\"")
    assert str.include?("stop_word_count=\"0\"")
    assert str.include?(imatch.lexicon.to_s)
  end

  def test_multiple_lexicon_signatures
    string = "this is a test"
    imatch = IMatch.new(IMatch::DEFAULT_LEXICON_FILE, :lexicons => 5)

    default = imatch.signature(string)
    signatures = imatch.multiple_signatures(string)

    assert signatures.kind_of?(Set)
    assert !signatures.empty?
    assert signatures.include?(default)
  end
end
