# frozen_string_literal: true

class Regexp::MatchLength
  include Enumerable

  def self.of(obj)
    exp = obj.is_a?(Regexp::Expression::Base) ? obj : Regexp::Parser.parse(obj)
    exp.match_length
  end

  def initialize(exp)
    @exp_class = exp.class
    @rules = []
    @repetitions = {}
    @expressions = {}.compare_by_identity
    @pending = []
    @empty = rule([[]])
    @root = expression(exp)
    until @pending.empty?
      current = @pending.pop
      quantified, base = @expressions.fetch(current)
      @rules[base] = productions(current)
      @rules[quantified] = [repeat(base, current.repetitions)]
      @repetitions[quantified] = [base, current.repetitions.min, current.repetitions.max]
    end
    @minima = minimums(@rules)
    # Unproductive alternatives cannot contribute to a successful match,
    # even if they contain a growing cycle.
    @rules.each do |alternatives|
      alternatives.reject! { |seq| seq.any? { |s| s >= 0 && @minima[s].nil? } }
    end
  end

  def each(opts = {})
    return enum_for(__method__, opts) unless block_given?
    return self if min.nil?

    limit = opts[:limit] || 1000
    yielded = 0
    (min.to_i..max).each do |num|
      next unless include?(num)
      yield(num)
      break if (yielded += 1) >= limit
    end
  end

  def endless_each
    return enum_for(__method__) unless block_given?
    return self if min.nil?

    (min.to_i..max).each { |num| yield(num) if include?(num) }
  end

  def include?(length)
    return false if min.nil? || length < min || length > max

    if !@limit || length > @limit
      @limit = [length, (@limit || 16) * 2].max
      @limit = [@limit, max].min
      @lengths = lengths_up_to(@limit)
    end
    @lengths[@root][length] == 1
  end

  def fixed?
    !min.nil? && min == max
  end

  def min
    @minima[@root]
  end

  def max
    return if min.nil?

    @maximums ||= maximums
    @maximums[@root]
  end

  def minmax
    # An expression with no terminating derivation has no possible lengths.
    # Like Enumerable#minmax on an empty collection, this returns [nil, nil].
    [min, max]
  end

  def inspect
    type = @exp_class.name.sub('Regexp::Expression::', '')
    "#<#{self.class}<#{type}> min=#{min.inspect} max=#{max.inspect}>"
  end

  def to_re
    return /(?!)/ if min.nil?
    return // if max == 0

    @regexp_serial = (@regexp_serial || 0) + 1
    prefix = "ml#{object_id}_#{@regexp_serial}_"

    # Inline acyclic rules and retain quantifiers. Only actual reference
    # cycles need named groups, keeping ordinary patterns small and fast.
    begin
      return Regexp.new(compact_source(prefix))
    rescue RegexpError => error
      raise unless error.message.include?('recursion')
      # Parsed strings can contain left recursion which Ruby cannot compile.
      # Normalize the grammar to consuming recursion before trying again.
    end

    rules = regexp_rules
    definitions = rules.map do |id, alternatives|
      body = alternatives.map do |seq|
        seq.map { |s| s < 0 ? ".{#{-s}}" : "\\g<#{prefix}#{s}>" }.join
      end.join('|')
      "(?<#{prefix}#{id}>#{body}){0}"
    end.join
    start = "\\g<#{prefix}#{@root}>"
    start = "(?:#{start})?" if min == 0
    Regexp.new(definitions + start)
  end

  private

  def rule(alternatives = [])
    @rules << alternatives
    @rules.length - 1
  end

  def expression(exp, unquantified = false)
    ids = @expressions[exp] ||= begin
      @pending << exp
      [rule, rule]
    end
    ids[unquantified ? 1 : 0]
  end

  def sequence(symbols)
    # Binary productions keep nullable expansion and length convolution small.
    symbols = symbols.dup
    while symbols.length > 2
      tail = symbols.pop(2)
      symbols << rule([tail])
    end
    symbols
  end

  def productions(exp)
    case exp
    when Regexp::Expression::Anchor::Base,
         Regexp::Expression::Assertion::Base,
         Regexp::Expression::Conditional::Condition,
         Regexp::Expression::FreeSpace,
         Regexp::Expression::Keep::Mark
      [[]]
    when Regexp::Expression::Group::Absence
      # Preserve the existing approximation: any nonnegative length.
      [repeat(rule([[-1]]), 0..Float::INFINITY)]
    when Regexp::Expression::Literal
      exp.text.empty? ? [[]] : [[-exp.text.length]]
    when Regexp::Expression::EscapeSequence::CodepointList
      exp.codepoints.empty? ? [[]] : [[-exp.codepoints.count]]
    when Regexp::Expression::CharacterSet,
         Regexp::Expression::CharacterSet::Intersection,
         Regexp::Expression::CharacterSet::IntersectedSequence,
         Regexp::Expression::CharacterSet::Range,
         Regexp::Expression::CharacterType::Base,
         Regexp::Expression::EscapeSequence::Base,
         Regexp::Expression::PosixClass,
         Regexp::Expression::UnicodeProperty::Base
      [[-1]]
    when Regexp::Expression::Backreference::Base
      if exp.referenced_expression.nil?
        raise ArgumentError, 'Missing referenced_expression - not parsed?'
      end
      # The target's quantifier does not apply to the captured/called body.
      exp.referenced_expressions.map { |target| [expression(target, true)] }
    when Regexp::Expression::Alternation, Regexp::Expression::Conditional::Expression
      exp.map { |child| [expression(child)] }
    when Regexp::Expression::Subexpression
      [sequence(exp.map { |child| expression(child) })]
    else
      raise ArgumentError, "Unsupported expression: #{exp.class}"
    end
  end

  def repeat(body, repetitions)
    lower, upper = repetitions.min, repetitions.max
    return [] if upper == 0
    return [body] if lower == 1 && upper == 1

    mandatory = power(body, lower)
    if upper == Float::INFINITY
      optional = rule([[]])
      @rules[optional] << [body, optional]
      @repetitions[optional] = [body, 0, upper]
    else
      optional = up_to(body, upper - lower)
    end
    [mandatory, optional]
  end

  def power(body, count)
    return @empty if count == 0

    factors = []
    while count > 0
      factors << body if count.odd?
      count /= 2
      body = rule([[body, body]]) if count > 0
    end
    factors.length == 1 ? factors.first : rule([sequence(factors)])
  end

  def up_to(body, count)
    return @empty if count == 0
    return rule([[], [body]]) if count == 1

    half = up_to(body, count / 2)
    factors = [half, half]
    factors << rule([[], [body]]) if count.odd?
    rule([sequence(factors)])
  end

  def minimums(rules)
    values = Array.new(rules.length)
    loop do
      changed = false
      rules.each_with_index do |alternatives, id|
        candidates = alternatives.map do |seq|
          parts = seq.map { |s| s < 0 ? -s : values[s] }
          parts.inject(0, :+) unless parts.include?(nil)
        end.compact
        value = candidates.min
        next if value.nil? || values[id] == value
        values[id] = value
        changed = true
      end
      return values unless changed
    end
  end

  def maximums
    values = Array.new(@rules.length)
    heights = Array.new(@rules.length, 0)
    propagate do |id|
      changed = false
      @rules[id].each do |seq|
        next if seq.any? { |s| s >= 0 && values[s].nil? }
        value = seq.inject(0) { |sum, s| sum + (s < 0 ? -s : values[s]) }
        next if values[id] && value <= values[id]
        height = 1 + (seq.map { |s| s < 0 ? 0 : heights[s] }.max || 0)
        # A strictly improving derivation taller than the number of rules
        # repeats a rule with positive context: that cycle can grow forever.
        values[id] = height > @rules.length ? Float::INFINITY : value
        heights[id] = height
        changed = true
      end
      changed
    end
    values
  end

  def lengths_up_to(limit)
    mask = (1 << (limit + 1)) - 1
    values = Array.new(@rules.length, 0)
    propagate do |id|
      value = @rules[id].inject(0) do |union, seq|
        bits = seq.inject(1) do |left, s|
          if s < 0
            -s > limit ? 0 : (left << -s) & mask
          else
            convolve(left, values[s], mask)
          end
        end
        union | bits
      end
      changed = value != values[id]
      values[id] = value
      changed
    end
    values
  end

  def propagate
    dependents = Array.new(@rules.length) { [] }
    @rules.each_with_index do |alternatives, id|
      alternatives.flatten.uniq.each { |s| dependents[s] << id if s >= 0 }
    end
    queue = (0...@rules.length).to_a
    queued = Array.new(@rules.length, true)
    until queue.empty?
      id = queue.pop
      queued[id] = false
      next unless yield(id)
      dependents[id].each do |parent|
        next if queued[parent]
        queue << parent
        queued[parent] = true
      end
    end
  end

  def convolve(left, right, mask)
    left, right = right, left if left.bit_length > right.bit_length
    result = 0
    until left == 0
      bit = left & -left
      result |= right << (bit.bit_length - 1)
      left ^= bit
    end
    result & mask
  end

  def compact_source(prefix)
    named, active, visited = {}, {}, {}
    queue = [[@root, false]]
    until queue.empty?
      id, leaving = queue.pop
      if leaving
        active.delete(id)
        visited[id] = true
      elsif active[id]
        named[id] = true
      elsif !visited[id]
        active[id] = true
        queue << [id, true]
        next if @minima[id].nil? || @maximums[id] == 0
        children = @repetitions[id] ? [@repetitions[id].first] : @rules[id].flatten
        children.reverse_each { |s| queue << [s, false] if s >= 0 }
      end
    end
    cache = {}
    definitions = named.keys.map do |id|
      "(?<#{prefix}#{id}>#{source_for(id, named, cache, prefix, true)}){0}"
    end.join
    definitions + source_for(@root, named, cache, prefix)
  end

  def source_for(id, named, cache, prefix, definition = false)
    return "\\g<#{prefix}#{id}>" if named[id] && !definition
    return cache[id] if cache.key?(id)
    cache[id] = if @minima[id].nil?
                  '(?!)'
                elsif @maximums[id] == 0
                  ''
                elsif (repetition = @repetitions[id])
                  body, lower, upper = repetition
                  source = source_for(body, named, cache, prefix)
                  if lower == 1 && upper == 1
                    source
                  else
                    # An option group also prevents Ruby's warnings about
                    # redundant nested quantifiers, e.g. (?:a?)*.
                    "(?-mix:#{source}){#{lower},#{upper unless upper == Float::INFINITY}}"
                  end
                else
                  alternatives = @rules[id].map do |seq|
                    parts = seq.map { |s| s < 0 ? ".{#{-s}}" : source_for(s, named, cache, prefix) }
                    seq.length == 2 && seq[0] == seq[1] ? "(?-mix:#{parts.first}){2}" : parts.join
                  end
                  alternatives.length == 1 ? alternatives.first : "(?:#{alternatives.join('|')})"
                end
  end

  # Ruby rejects left-recursive subexpression calls. Remove nullable and
  # unit productions, then eliminate left recursion before emitting groups.
  # Membership itself uses the grammar, not Ruby's recursion depth limit.
  def regexp_rules
    original = {}
    @rules.each_with_index { |alternatives, id| original[id] = alternatives }
    original = reachable_rules(original)
    rules = {}
    original.each do |id, alternatives|
      rules[id] = alternatives.flat_map do |seq|
        seq.inject([[]]) do |variants, s|
          extended = variants.map { |prefix| prefix + [s] }
          s >= 0 && @minima[s] == 0 ? extended + variants : extended
        end
      end.reject(&:empty?).uniq
    end
    without_units = {}
    rules.each_key do |id|
      seen, queue, alternatives = {}, [id], []
      until queue.empty?
        target = queue.pop
        next if seen[target]
        seen[target] = true
        rules[target].each do |seq|
          if seq.length == 1 && seq.first >= 0
            queue << seq.first
          else
            alternatives << seq
          end
        end
      end
      without_units[id] = alternatives.uniq
    end
    rules = reachable_rules(without_units)
    ordered = rules.keys
    next_id = @rules.length
    ordered.each_with_index do |id, index|
      ordered.take(index).each do |previous|
        rules[id] = rules[id].flat_map do |seq|
          seq.first == previous ? rules[previous].map { |prefix| prefix + seq.drop(1) } : [seq]
        end.uniq
      end
      recursive, other = rules[id].partition { |seq| seq.first == id }
      next if recursive.empty?
      suffix = next_id
      next_id += 1
      rules[id] = other.map { |seq| seq + [suffix] }
      rules[suffix] = [[]] + recursive.map { |seq| seq.drop(1) + [suffix] }
    end
    # Put a consuming terminal first as well: Ruby's recursion check rejects
    # some productive mutual cycles when progress is hidden behind calls.
    loop do
      changed = false
      rules.each do |id, alternatives|
        rules[id] = alternatives.flat_map do |seq|
          if !seq.empty? && seq.first >= 0
            changed = true
            rules[seq.first].map { |prefix| prefix + seq.drop(1) }
          else
            [seq]
          end
        end.uniq
      end
      break unless changed
    end
    reachable_rules(rules)
  end

  def reachable_rules(rules)
    # Epsilon removal can leave rules that no longer produce any word.
    productive = {}
    loop do
      before = productive.length
      rules.each do |id, alternatives|
        productive[id] = true if alternatives.any? { |seq| seq.all? { |s| s < 0 || productive[s] } }
      end
      break if before == productive.length
    end
    reachable, queue = {}, [@root]
    until queue.empty?
      id = queue.pop
      next if reachable.key?(id)
      reachable[id] = rules.fetch(id).select { |seq| seq.all? { |s| s < 0 || productive[s] } }
      reachable[id].flatten.each { |s| queue << s if s >= 0 }
    end
    reachable
  end
end

module Regexp::Expression
  MatchLength = Regexp::MatchLength

  class Base
    def match_length
      MatchLength.new(self)
    end
  end

  class Subexpression
    def inner_match_length
      dummy = Regexp::Expression::Root.construct
      dummy.expressions = expressions.map(&:clone)
      dummy.quantifier = quantifier && quantifier.clone
      dummy.match_length
    end
  end
end
