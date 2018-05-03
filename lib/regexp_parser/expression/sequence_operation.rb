module Regexp::Expression
  # abstract class
  class SequenceOperation < Regexp::Expression::Subexpression
    alias :sequences :expressions
    alias :operands :expressions
    alias :operator :text

    def starts_at
      expressions.first.starts_at
    end
    alias :ts :starts_at

    def <<(exp)
      expressions.last << exp
    end

    def add_sequence
      exp = self.class::OPERAND.new(level, set_level, conditional_level)
      expressions << exp
      exp
    end

    def quantify(token, text, min = nil, max = nil, mode = :greedy)
      sequences.last.last.quantify(token, text, min, max, mode)
      sequences.last.last.quantify(token, text, min, max, mode)
    end

    def to_s(format = :full)
      sequences.map { |e| e.to_s(format) }.join(text)
      sequences.map { |e| e.to_s(format) }.join(text)
    end
  end
end
