module Regexp::Expression
  module Escape
    class Base < Regexp::Expression::Base
      def codepoint
        char.ord
      end

      if ''.respond_to?(:undump)
        def char
          %("#{text}").undump
        end
      else
        # poor man's unescape without using eval
        require 'yaml'
        def char
          YAML.load(%Q(---\n"#{text}"\n))
        end
      end
    end

    class Literal < Escape::Base
      def char
        text[1..-1]
      end
    end

    class AsciiEscape   < Escape::Base; end
    class Backspace     < Escape::Base; end
    class Bell          < Escape::Base; end
    class FormFeed      < Escape::Base; end
    class Newline       < Escape::Base; end
    class Return        < Escape::Base; end
    class Tab           < Escape::Base; end
    class VerticalTab   < Escape::Base; end

    class Hex           < Escape::Base; end
    class Codepoint     < Escape::Base; end

    class CodepointList < Escape::Base
      def char
        raise NoMethodError, 'CodepointList responds only to #chars'
      end

      def codepoint
        raise NoMethodError, 'CodepointList responds only to #codepoints'
      end

      def chars
        codepoints.map { |cp| cp.chr('utf-8') }
      end

      def codepoints
        text.scan(/\h+/).map(&:hex)
      end
    end

    class Octal < Escape::Base
      def char
        text[1..-1].to_i(8).chr('utf-8')
      end
    end

    class AbstractMetaControlSequence < Escape::Base
      def char
        codepoint.chr('utf-8')
      end

      private

      def control_sequence_to_s(control_sequence)
        five_lsb = control_sequence.unpack('B*').first[-5..-1]
        ["000#{five_lsb}"].pack('B*')
      end

      def meta_char_to_codepoint(meta_char)
        byte_value = meta_char.ord
        byte_value < 128 ? byte_value + 128 : byte_value
      end
    end

    class Control < AbstractMetaControlSequence
      def codepoint
        control_sequence_to_s(text).ord
      end
    end

    class Meta < AbstractMetaControlSequence
      def codepoint
        meta_char_to_codepoint(text[-1])
      end
    end

    class MetaControl < AbstractMetaControlSequence
      def codepoint
        meta_char_to_codepoint(control_sequence_to_s(text))
      end
    end
  end
end
