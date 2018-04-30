require File.expand_path("../../helpers", __FILE__)

class ScannerErrors < Test::Unit::TestCase

  def test_scanner_unbalanced_set
    assert_raise( RS::PrematureEndError ) { RS.scan('[[:alpha:]') }
  end

  def test_scanner_unbalanced_group
    assert_raise( RS::PrematureEndError ) { RS.scan('(abc') }
  end

  def test_scanner_unbalanced_interval
    assert_raise( RS::PrematureEndError ) { RS.scan('a{1,2') }
  end

  def test_scanner_eof_in_property
    assert_raise( RS::PrematureEndError ) { RS.scan('\p{asci') }
  end

  def test_scanner_incomplete_property
    assert_raise( RS::PrematureEndError ) { RS.scan('\p{ascii abc') }
  end

  def test_scanner_unknown_property
    assert_raise( RS::UnknownUnicodePropertyError ) { RS.scan('\p{foobar}') }
  end

  def test_scanner_incomplete_options
    assert_raise( RS::ScannerError ) { RS.scan('(?mix abc)') }
  end

  def test_scanner_eof_options
    assert_raise( RS::PrematureEndError ) { RS.scan('(?mix') }
  end

  def test_scanner_incorrect_options
    assert_raise( RS::ScannerError ) { RS.scan('(?mix^bc') }
  end

  def test_scanner_eof_escape
    assert_raise( RS::PrematureEndError ) { RS.scan('\\') }
  end

  def test_scanner_eof_in_hex_escape
    assert_raise( RS::PrematureEndError ) { RS.scan('\x') }
  end

  def test_scanner_eof_in_codepoint_escape
    assert_raise( RS::PrematureEndError ) { RS.scan('\u') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\u0') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\u00') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\u000') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\u{') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\u{00') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\u{0000') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\u{0000 ') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\u{0000 0000') }
  end

  def test_scanner_eof_in_control_sequence
    assert_raise( RS::PrematureEndError ) { RS.scan('\c') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\c\M') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\c\M-') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\C') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\C-') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\C-\M') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\C-\M-') }
  end

  def test_scanner_eof_in_meta_sequence
    assert_raise( RS::PrematureEndError ) { RS.scan('\M') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\M-') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\M-\\') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\M-\c') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\M-\C') }
    assert_raise( RS::PrematureEndError ) { RS.scan('\M-\C-') }
  end

  def test_scanner_invalid_hex_escape
    assert_raise( RS::InvalidSequenceError ) { RS.scan('\xZ') }
    assert_raise( RS::InvalidSequenceError ) { RS.scan('\xZ0') }
  end

  def test_scanner_invalid_named_group
    assert_raise( RS::InvalidGroupError ) { RS.scan("(?'')") }
    assert_raise( RS::InvalidGroupError ) { RS.scan("(?''empty-name)") }
    assert_raise( RS::InvalidGroupError ) { RS.scan("(?<>)") }
    assert_raise( RS::InvalidGroupError ) { RS.scan("(?<>empty-name)") }
  end
end
