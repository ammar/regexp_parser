require File.expand_path('../1.8', __FILE__)

module Regexp::Syntax

  module Ruby
    class V191 < Regexp::Syntax::Ruby::V18
      include Regexp::Syntax::Token

      def initialize
        super

        implements :backref, Group::Backreference::All +
          Group::SubexpressionCall::All

        implements :escape, CharacterType::Hex

        implements :quantifier, 
          Quantifier::Reluctant + Quantifier::Possessive

        implements :set, 
          CharacterSet::POSIX::Extensions 

        implements :subset, CharacterSet::OpenClose +
          CharacterSet::Extended + CharacterSet::Types +
          CharacterSet::POSIX::Standard 
      end

      def normalize(type, token)
        case type
        when :backref
          normalize_backref(type, token)
        else
          super
        end
      end

      def normalize_backref(type, token)
        case token
        when :name_ref_ab, :name_ref_sq
          [:backref, :name_ref]
        when :name_call_ab, :name_call_sq
          [:backref, :name_call]
        when :name_nest_ref_ab, :name_nest_ref_sq
          [:backref, :name_nest_ref]
        when :number_ref_ab, :number_ref_sq
          [:backref, :number_ref]
        when :number_call_ab, :number_call_sq
          [:backref, :number_call]
        when :number_rel_ref_ab, :number_rel_ref_sq
          [:backref, :number_rel_ref]
        when :number_rel_call_ab, :number_rel_call_sq
          [:backref, :number_rel_call]
        when :number_nest_ref_ab, :number_nest_ref_sq
          [:backref, :number_nest_ref]
        else
          [type, token]
        end
      end

    end
  end

end
