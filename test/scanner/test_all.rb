require File.expand_path("../../helpers", __FILE__)

%w{
  anchors escapes
}.each do|tc|
  require File.expand_path("../test_#{tc}", __FILE__)
end

class TestRegexpScanner < Test::Unit::TestCase

  def test_scanner_returns_an_array
    assert_instance_of( Array, RS.scan('abc'))
  end

  def test_scanner_returns_tokens_as_arrays
    tokens = RS.scan('^abc+[^one]{2,3}\b\d\\\C-C$')

    assert( tokens.all?{|token| token.kind_of?(Array)},
          "Not all array members are arrays")

    assert( tokens.all?{|token| token.length == 5},
          "Not all array have 5 elements")
  end

  def test_scanner_token_count
    assert_equal(28,
      RS.scan(/^(one|two){2,3}([^d\]efm-qz\,\-]*)(ghi)+$/i).length)
  end

end
