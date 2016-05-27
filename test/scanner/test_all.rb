require File.expand_path("../../helpers", __FILE__)

%w{
  anchors errors escapes free_space groups literals
  meta properties quantifiers scripts sets types unicode_blocks
}.each do|tc|
  require File.expand_path("../test_#{tc}", __FILE__)
end

if RUBY_VERSION >= '2.0.0'
  %w{conditionals keep}.each do|tc|
    require File.expand_path("../test_#{tc}", __FILE__)
  end
end

class TestRegexpScanner < Test::Unit::TestCase

  def test_scanner_returns_an_array
    assert_instance_of Array, RS.scan('abc')
  end

  def test_scanner_returns_tokens_as_arrays
    tokens = RS.scan('^abc+[^one]{2,3}\b\d\\\C-C$')

    all_arrays = tokens.all? do |token|
      token.kind_of?(Array) and token.length == 5
    end

    assert all_arrays, 'Not all tokens are arrays of 5 elements'
  end

  def test_scanner_token_count
    re = /^(one|two){2,3}([^d\]efm-qz\,\-]*)(ghi)+$/i

    assert_equal 26, RS.scan(re).length
  end

end
