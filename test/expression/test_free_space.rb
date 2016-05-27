require File.expand_path("../../helpers", __FILE__)

class ExpressionFreeSpace < Test::Unit::TestCase

  def test_expression_white_space_quantify_raises_error
    regexp = %r{
      a # Comment
    }x

    root = RP.parse(regexp)

    space = root[0]
    assert_equal FreeSpace::WhiteSpace, space.class

    assert_raise( RuntimeError ) {
      space.quantify(:dummy, '#')
    }
  end

  def test_expression_comment_quantify_raises_error
    regexp = %r{
      a # Comment
    }x

    root = RP.parse(regexp)

    comment = root[3]
    assert_equal FreeSpace::Comment, comment.class

    assert_raise( RuntimeError ) {
      comment.quantify(:dummy, '#')
    }
  end

end
