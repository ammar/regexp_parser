require File.expand_path("../../helpers", __FILE__)

%w{
  anchors escapes groups meta properties quantifiers
  sets types utf8
}.each do|tc|
  require File.expand_path("../test_#{tc}", __FILE__)
end

class TestRegexpScanner < Test::Unit::TestCase

  def test_scanner_returns_an_array
    assert_instance_of( Array, RS.scan('abc') )
  end

  def test_scanner_returns_tokens_as_arrays
    tokens = RS.scan('^abc+[^one]{2,3}\b\d\\\C-C$')

    assert( tokens.all?{|token|
      token.kind_of?(Array) and token.length == 5
    }, "Not all tokens are arrays of 5 elements")
  end

  def test_scanner_token_count
    re = /^(one|two){2,3}([^d\]efm-qz\,\-]*)(ghi)+$/i

    assert_equal(26, RS.scan(re).length )
  end

end
