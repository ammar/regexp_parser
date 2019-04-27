require 'spec_helper'

RSpec.describe('Scanning errors') do
  specify('scanner unbalanced set') do
    expect { RS.scan('[[:alpha:]') }.to raise_error(RS::PrematureEndError)
  end

  specify('scanner unbalanced group') do
    expect { RS.scan('(abc') }.to raise_error(RS::PrematureEndError)
  end

  specify('scanner unbalanced interval') do
    expect { RS.scan('a{1,2') }.to raise_error(RS::PrematureEndError)
  end

  specify('scanner eof in property') do
    expect { RS.scan('\\p{asci') }.to raise_error(RS::PrematureEndError)
  end

  specify('scanner incomplete property') do
    expect { RS.scan('\\p{ascii abc') }.to raise_error(RS::PrematureEndError)
  end

  specify('scanner unknown property') do
    expect { RS.scan('\\p{foobar}') }.to raise_error(RS::UnknownUnicodePropertyError)
  end

  specify('scanner incomplete options') do
    expect { RS.scan('(?mix abc)') }.to raise_error(RS::ScannerError)
  end

  specify('scanner eof options') do
    expect { RS.scan('(?mix') }.to raise_error(RS::PrematureEndError)
  end

  specify('scanner incorrect options') do
    expect { RS.scan('(?mix^bc') }.to raise_error(RS::ScannerError)
  end

  specify('scanner eof escape') do
    expect { RS.scan('\\') }.to raise_error(RS::PrematureEndError)
  end

  specify('scanner eof in hex escape') do
    expect { RS.scan('\\x') }.to raise_error(RS::PrematureEndError)
  end

  specify('scanner eof in codepoint escape') do
    expect { RS.scan('\\u') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\u0') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\u00') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\u000') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\u{') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\u{00') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\u{0000') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\u{0000 ') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\u{0000 0000') }.to raise_error(RS::PrematureEndError)
  end

  specify('scanner eof in control sequence') do
    expect { RS.scan('\\c') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\c\\M') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\c\\M-') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\C') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\C-') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\C-\\M') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\C-\\M-') }.to raise_error(RS::PrematureEndError)
  end

  specify('scanner eof in meta sequence') do
    expect { RS.scan('\\M') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\M-') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\M-\\') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\M-\\c') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\M-\\C') }.to raise_error(RS::PrematureEndError)
    expect { RS.scan('\\M-\\C-') }.to raise_error(RS::PrematureEndError)
  end

  specify('scanner invalid hex escape') do
    expect { RS.scan('\\xZ') }.to raise_error(RS::InvalidSequenceError)
    expect { RS.scan('\\xZ0') }.to raise_error(RS::InvalidSequenceError)
  end

  specify('scanner invalid named group') do
    expect { RS.scan("(?'')") }.to raise_error(RS::InvalidGroupError)
    expect { RS.scan("(?''empty-name)") }.to raise_error(RS::InvalidGroupError)
    expect { RS.scan('(?<>)') }.to raise_error(RS::InvalidGroupError)
    expect { RS.scan('(?<>empty-name)') }.to raise_error(RS::InvalidGroupError)
  end
end
