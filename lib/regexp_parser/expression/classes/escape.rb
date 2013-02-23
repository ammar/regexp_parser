module Regexp::Expression

  module EscapeSequence
    class Base          < Regexp::Expression::Base; end

    class Literal       < EscapeSequence::Base; end

    class AsciiEscape   < EscapeSequence::Base; end
    class Backspace     < EscapeSequence::Base; end
    class Bell          < EscapeSequence::Base; end
    class FormFeed      < EscapeSequence::Base; end
    class Newline       < EscapeSequence::Base; end
    class Return        < EscapeSequence::Base; end
    class Space         < EscapeSequence::Base; end
    class Tab           < EscapeSequence::Base; end
    class VerticalTab   < EscapeSequence::Base; end

    class Octal         < EscapeSequence::Base; end
    class Hex           < EscapeSequence::Base; end
    class HexWide       < EscapeSequence::Base; end

    class Control       < EscapeSequence::Base; end
    class Meta          < EscapeSequence::Base; end
    class MetaControl   < EscapeSequence::Base; end
  end

end
