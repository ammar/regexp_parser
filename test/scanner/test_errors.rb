require File.expand_path("../../helpers", __FILE__)

class ScannerErrors < Test::Unit::TestCase

  def test_scanner_unbalanced_set
    assert_raise( Regexp::Scanner::PrematureEndError ) { RS.scan('[[:alpha:]') }
  end

  def test_scanner_unbalanced_group
    assert_raise( Regexp::Scanner::PrematureEndError ) { RS.scan('(abc') }
  end

  def test_scanner_unbalanced_interval
    assert_raise( Regexp::Scanner::PrematureEndError ) { RS.scan('a{1,2') }
  end

  def test_scanner_incomplete_property
    assert_raise( Regexp::Scanner::PrematureEndError ) { RS.scan('\p{ascii abc') }
  end

  def test_scanner_unknown_property
    assert_raise( Regexp::Scanner::UnknownUnicodePropertyError ) { RS.scan('\p{foobar}') }
  end

  def test_scanner_incomplete_options
    assert_raise( Regexp::Scanner::ScannerError ) { RS.scan('(?mix abc)') }
  end

  def test_scanner_eof_options
    assert_raise( Regexp::Scanner::PrematureEndError ) { RS.scan('(?mix') }
  end

  def test_scanner_incorrect_options
    assert_raise( Regexp::Scanner::ScannerError ) { RS.scan('(?mix^bc') }
  end
end
