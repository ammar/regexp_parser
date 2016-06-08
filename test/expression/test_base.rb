require File.expand_path("../../helpers", __FILE__)

class ExpressionBase < Test::Unit::TestCase

  def test_expression_to_re
    re_text = '^a*(b([cde]+))+f?$'

    re = RP.parse(re_text).to_re

    assert re.is_a?(::Regexp),
           'Not a Regexp, but should be'

    assert_equal re.source, re_text
  end

  def test_expression_level
    regexp = /^a(b(c(d)))e$/
    root = RP.parse(regexp)

    %w{^ a (b(c(d))) e $}.each_with_index do |t, i|
      assert_equal t, root[i].to_s
      assert_equal 0, root[i].level
    end

    assert_equal 'b', root[2][0].to_s
    assert_equal 1,   root[2][0].level

    assert_equal 'c', root[2][1][0].to_s
    assert_equal 2,   root[2][1][0].level

    assert_equal 'd', root[2][1][1][0].to_s
    assert_equal 3,   root[2][1][1][0].level
  end

  def test_expression_terminal?
    root = RP.parse('^a([b]+)c$')

    assert_equal false, root.terminal?

    assert_equal true,  root[0].terminal?
    assert_equal true,  root[1].terminal?
    assert_equal false, root[2].terminal?
    assert_equal true,  root[2][0].terminal?
    assert_equal true,  root[3].terminal?
    assert_equal true,  root[4].terminal?
  end

  def test_expression_alt_terminal?
    root = RP.parse('^(ab|cd)$')

    assert_equal false, root.terminal?

    assert_equal true,  root[0].terminal?
    assert_equal false, root[1].terminal?
    assert_equal false, root[1][0].terminal?
    assert_equal false, root[1][0][0].terminal?
    assert_equal true,  root[1][0][0][0].terminal?
    assert_equal false, root[1][0][1].terminal?
    assert_equal true,  root[1][0][1][0].terminal?
  end

  def test_expression_coded_offset
    root = RP.parse('^a*(b+(c?))$')

    assert_equal '@0+12', root.coded_offset

    # All top level offsets
    [
      [ '@0+1', '^'         ],
      [ '@1+2', 'a*'        ],
      [ '@3+8', '(b+(c?))'  ],
      ['@11+1', '$'         ],
    ].each_with_index do |check, i|
      against = [ root[i].coded_offset, root[i].to_s ]

      assert_equal check, against
    end

    # Nested expression
    assert_equal ['@4+2', 'b+'], [root[2][0].coded_offset, root[2][0].to_s]

    # Nested subexpression
    assert_equal ['@6+4', '(c?)'], [root[2][1].coded_offset, root[2][1].to_s]

    # Nested subexpression expression
    assert_equal ['@7+2', 'c?'], [root[2][1][0].coded_offset, root[2][1][0].to_s]
  end

end
