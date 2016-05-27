require File.expand_path("../../helpers", __FILE__)

class ExpressionToS < Test::Unit::TestCase

  def test_expression_to_s_literal_alternation
    pattern = 'abcd|ghij|klmn|pqur'

    assert_equal pattern, RP.parse(pattern).to_s
  end

  def test_expression_to_s_quantified_alternations
    pattern = '(?:a?[b]+(c){2}|d+[e]*(f)?)|(?:g+[h]?(i){2,3}|j*[k]{3,5}(l)?)'

    assert_equal pattern, RP.parse(pattern).to_s
  end

  def test_expression_to_s_quantified_sets
    pattern = '[abc]+|[^def]{3,6}'

    assert_equal pattern, RP.parse(pattern).to_s
  end

  def test_expression_to_s_property_sets
    pattern = '[\a\b\p{Lu}\P{Z}\c\d]+'

    assert_equal pattern, RP.parse(pattern, 'ruby/1.9').to_s
  end

  def test_expression_to_s_groups
    pattern = "(a(?>b(?:c(?<n>d(?'N'e)??f)+g)*+h)*i)++"

    assert_equal pattern, RP.parse(pattern, 'ruby/1.9').to_s
  end

  def test_expression_to_s_assertions
    pattern = '(a+(?=b+(?!c+(?<=d+(?<!e+)?f+)?g+)?h+)?i+)?'

    assert_equal pattern, RP.parse(pattern, 'ruby/1.9').to_s
  end

  def test_expression_to_s_comments
    pattern = '(?#start)a(?#middle)b(?#end)'

    assert_equal pattern, RP.parse(pattern).to_s
  end

  def test_expression_to_s_options
    pattern = '(?mix:start)a(?-mix:middle)b(?i-mx:end)'

    assert_equal pattern, RP.parse(pattern).to_s
  end

  def test_expression_to_s_url
    pattern = '(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*'+
              '\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)'

    assert_equal pattern, RP.parse(pattern).to_s
  end

  def test_expression_to_s_multiline_source
    multiline = %r{
      \A
      a?      # One letter
      b{2,5}  # Another one
      [c-g]+  # A set
      \z
    }x

    assert_equal multiline.source, RP.parse(multiline).to_s
  end

  def test_expression_to_s_multiline_to_s
    multiline = %r{
      \A
      a?      # One letter
      b{2,5}  # Another one
      [c-g]+  # A set
      \z
    }x

    assert_equal multiline.to_s, RP.parse(multiline.to_s).to_s
  end

  # Free spacing expressions that use spaces between quantifiers and their
  # targets do not produce identical results due to the way quantifiers are
  # applied to expressions (members, not nodes) and the merging of consecutive
  # space nodes. This tests that they produce equivalent results.
  def test_expression_to_s_multiline_equivalence
    multiline = %r{
      \A
      a   ?             # One letter
      b {2,5}           # Another one
      [c-g]  +          # A set
      \z
    }x

    str  = 'bbbcged'
    root = RP.parse(multiline)

    assert_equal multiline.match(str)[0],
                 Regexp.new(root.to_s, Regexp::EXTENDED).match(str)[0]
  end

end
