
class IMatch
  class Lexicon

    def initialize(file_or_set)
      if file_or_set.kind_of?(Set)
        @file = "N/A"
        @data = file_or_set.clone.freeze
      elsif file_or_set.kind_of?(File)
        @file = File.expand_path(file_or_set.path)
        @data = IO.read(@file).split(/\r?\n/).to_set.freeze
      elsif file_or_set.kind_of?(String)
        raise(InvalidLexiconError, "Invalid/missing lexicon file: #{file_or_set}") unless File.exist?(file_or_set)
        @file = File.expand_path(file_or_set)
        @data = IO.read(@file).split(/\r?\n/).to_set.freeze
      else
        raise(InvalidLexiconError, "Invalid/missing lexicon argument: #{file_or_set}")
      end

      raise(InvalidLexiconError, "Empty lexicon file: #{file_or_set}") if @data.empty?
    end

    def include?(key)
      @data.include?(key)
    end

    def size
      @data.size
    end

    def to_s
      %Q{<IMatch::Lexicon size="#{size}" file="#{@file}" />}
    end

    # percentage should be between 0.0 and 1.0
    def subset(percentage)
      subset = Set.new
      @data.each do |term|
        if rand > percentage
          subset << term
        end
      end

      self.class.new(subset)
    end

  end
end