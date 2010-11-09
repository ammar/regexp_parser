require File.expand_path("../../helpers", __FILE__)

class ScannerErrors < Test::Unit::TestCase

  def test_scanner_unbalanced_set
    assert_raise( RuntimeError ) { RS.scan('[[:alpha:]') }
  end

  def test_scanner_unbalanced_group
    assert_raise( RuntimeError ) { RS.scan('(abc') }
  end

  def test_scanner_unbalanced_interval
    assert_raise( RuntimeError ) { RS.scan('a{1,2') }
  end

  def test_scanner_unbalanced_interval_bre
    assert_raise( RuntimeError ) { RS.scan('a\{1') }
  end

  def test_scanner_incomplete_property
    assert_raise( RuntimeError ) { RS.scan('\p{ascii abc') }
  end

  def test_scanner_incomplete_options
    assert_raise( RuntimeError ) { RS.scan('(?mix abc)') }
  end

  def test_scanner_eof_options
    assert_raise( RuntimeError ) { RS.scan('(?mix') }
  end

  def test_scanner_incorrect_options
    assert_raise( RuntimeError ) { RS.scan('(?mix^bc') }
  end
end
