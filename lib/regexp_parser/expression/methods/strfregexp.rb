module Regexp::Expression

  class Base

    #   %l  Level (depth) of the expression. Returns 'root' for the root
    #       expression, returns zero or higher for all others.
    #
    #   %x  Index of the expression at its depth. Available when using
    #       the sprintf_tree method only.
    #
    #   %s  Start offset within the whole expression.
    #   %e  End offset within the whole expression.
    #   %S  Length of expression.
    #
    #   %o  Coded offset and length, same as '@%s+%S'
    #
    #   %y  Type of expression.
    #   %k  Token of expression.
    #   %i  ID, same as '%y:%k'
    #
    #   %c  Quantified?, as 1 or 0
    #   %C  Quantified?, as Y or N
    #
    #   %q  Quantifier info, as {m[,M]}
    #   %Q  Quantifier text
    #
    #   %z  Quantifier min
    #   %Z  Quantifier max
    #
    #   %t  Full text of the expression (string)
    #   %~t Full text if the expression is terminal, otherwise %i
    #   %T  Full text of the expression (result of inspect)
    #
    #   %b  Basic info, same as '%o %i'
    #   %m  Most info, same as '%b %q'
    #   %a  All info, same as '%m %t'
    #
    def strfregexp(format = '%a', index = nil)
      have_index    = index ? true : false

      part = {}

      # NOTE: Order is important! Fields that use other fields in their
      # definition must appear before the fields they use.
      part_keys = %w{a m b o i l x s e S y k c C q Q z Z t ~t T}
      part.keys.each {|k| part[k] = "<?#{k}?>"}

      part['l'] = level ? "#{'%d' % level}" : 'root'
      part['x'] = "#{'%d' % index}" if have_index

      part['s'] = starts_at
      part['S'] = full_length
      part['e'] = starts_at + full_length
      part['o'] = coded_offset

      part['k'] = token
      part['y'] = type
      part['i'] = '%y:%k'

      if quantified?
        part['c'] = '1'
        part['C'] = 'Y'

        if quantifier.max == -1
          part['q'] = "{#{quantifier.min}, or-more}"
        else
          part['q'] = "{#{quantifier.min}, #{quantifier.max}}"
        end

        part['Q'] = quantifier.text
        part['z'] = quantifier.min
        part['Z'] = quantifier.max
      else
        part['c'] = '0'
        part['C'] = 'N'
        part['q'] = '{1}'
        part['Q'] = ''
        part['z'] = '1'
        part['Z'] = '1'
      end

      part['t'] = to_s
      part['~t'] = terminal? ? to_s : "#{type}:#{token}"
      part['T'] = part['t'].inspect

      part['b'] = '%o %i'
      part['m'] = '%b %q'
      part['a'] = '%m %t'

      out = format.dup

      part_keys.each do |k|
        out.gsub!(/%#{k}/, part[k].to_s)
      end

      out
    end

    alias :strfre :strfregexp
  end

  class Subexpression < Regexp::Expression::Base
    def strfregexp_tree(format = '%a', indent = true, separator = "\n")
      output = [self.strfregexp(format)]

      output += map {|exp, index|
        ind = indent ? ('  ' * (exp.level + 1)) : ''
        exp.strfregexp("#{ind}#{format}", index)
      }

      output.join(separator)
    end
  end
end
