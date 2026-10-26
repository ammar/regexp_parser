# frozen_string_literal: true

module Regexp::Expression::Shared
  # #to_s reproduces the original source, as an unparser would.
  #
  # It takes an optional format argument.
  #
  # Example:
  #
  # lit = Regexp::Parser.parse(/a +/x)[0]
  #
  # lit.to_s            # => 'a+'  # default; with quantifier
  # lit.to_s(:full)     # => 'a+'  # default; with quantifier
  # lit.to_s(:base)     # => 'a'   # without quantifier
  # lit.to_s(:original) # => 'a +' # with quantifier AND intermittent decorations
  #
  def to_s(format = :full)
    result = ''.dup
    stack = trailing_decorations(format).reverse
    stack << self
    quantifiers = []

    until stack.empty?
      part = stack.pop
      if part.instance_of?(String)
        append_quantifiers(result, quantifiers)
        result << part
      elsif part.is_a?(::Regexp::Expression::Quantifier)
        quantifiers << part
      elsif part.decorative?
        append_quantifiers(result, quantifiers, part.ts)
        result << part.text
      else
        unless part.equal?(self) && format == :base
          stack << part.quantifier if part.quantified?
        end
        stack.concat(part.parts.reverse)
      end
    end

    append_quantifiers(result, quantifiers)
    result
  end
  alias :to_str :to_s

  protected

  # Quantifiers follow their target in traversal order, but decorations can
  # precede them in source order. Defer each quantifier until that point.
  def append_quantifiers(result, quantifiers, position = nil)
    while (quantifier = quantifiers.first)
      break if position && quantifier.ts && position < quantifier.ts

      result << quantifiers.shift.text
    end
  end

  # Direct calls need decorations stored beside the expression (or its implicit
  # wrapper). :full and :base include only those belonging to inner quantifiers.
  def trailing_decorations(format)
    target = self
    if format != :original
      return [] unless implicit_passive_group?(self) && last

      target = last
    end
    return [] unless target.quantified? && target.quantifier.ts

    sibling = self
    while implicit_passive_group?(sibling.parent)
      sibling = sibling.parent
    end
    return [] unless sibling.parent

    siblings = sibling.parent.expressions
    index = siblings.index { |exp| exp.equal?(sibling) }
    return [] unless index

    decorations = []
    while (following = siblings[index += 1]) && following.decorative? &&
          following.ts && following.ts < target.quantifier.ts
      decorations << following
    end
    decorations
  end

  def implicit_passive_group?(exp)
    exp.is_a?(::Regexp::Expression::Group::Passive) && exp.implicit?
  end
end
