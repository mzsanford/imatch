require "test/unit"
require "imatch"

class TestIMatchLexicon < Test::Unit::TestCase

  def test_defines_lexicon_class
    assert IMatch::Lexicon
    assert IMatch::Lexicon.kind_of?(Class)
  end

  def test_nil_file_raises_error
    assert_raise InvalidLexiconError do
      IMatch::Lexicon.new(nil)
    end
  end

  def test_missing_file_raises_error
    assert_raise InvalidLexiconError do
      IMatch::Lexicon.new(File.join(File.dirname(__FILE__), 'lexicons', 'not_such_file'))
    end
  end

  def test_empty_file_raises_error
    assert_raise InvalidLexiconError do
      IMatch::Lexicon.new(File.join(File.dirname(__FILE__), 'lexicons', 'empty.dat'))
    end
  end

  def test_lexicon_size
    lexicon = IMatch::Lexicon.new(File.join(File.dirname(__FILE__), 'lexicons', 'ten.dat'))
    assert_equal 10, lexicon.size
  end

  def test_lexicon_duplicates_ignored
    lexicon = IMatch::Lexicon.new(File.join(File.dirname(__FILE__), 'lexicons', 'duplicates.dat'))
    assert_equal 7, lexicon.size
  end

  def test_lexicon_include
    lexicon = IMatch::Lexicon.new(File.join(File.dirname(__FILE__), 'lexicons', 'ten.dat'))
    %w(this file has ten terms in the lexicon for testing).each do |term|
      assert lexicon.include?(term), "Lexicon did not include test term: #{term}"
    end
  end

  def test_to_s
    filename = File.expand_path(File.join(File.dirname(__FILE__), 'lexicons', 'ten.dat'))
    lexicon = IMatch::Lexicon.new(File.join(File.dirname(__FILE__), 'lexicons', 'ten.dat'))
    assert_match(/#{filename}/, lexicon.to_s)
    assert_match(/#{lexicon.size}/, lexicon.to_s)
  end

  def test_new_with_file_argument
    file = File.new(File.join(File.dirname(__FILE__), 'lexicons', 'ten.dat'))
    lexicon = IMatch::Lexicon.new(file)
    assert_equal 10, lexicon.size
  end

  def test_new_with_set_argument
    lexicon = IMatch::Lexicon.new(%w(a b c d).to_set)
    assert_equal 4, lexicon.size
    assert_match(/N\/A/, lexicon.to_s)
  end

  def test_random_subset
    lexicon = IMatch::Lexicon.new(IMatch::DEFAULT_LEXICON_FILE)
    assert lexicon.size > 10000, "Default lexicon is too small for this test"

    subset = lexicon.subset(0.5)
    portion = (subset.size.to_f / lexicon.size.to_f).to_f

    assert portion > 0.4, "A 50% subset should be >40% of the size or else random is not working (#{portion})"
    assert portion < 0.6, "A 50% subset should be <60% of the size or else random is not working (#{portion})"
  end

end
