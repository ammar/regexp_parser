module Regexp::Expression
  class Comment
    def accept(visitor)
      visitor.visit_comment(self)
    end
  end

  class Group::Options
    def accept(visitor)
      visitor.visit_group_options(self)
    end
  end

  class Group::Named
    def accept(visitor)
      visitor.visit_group_named(self)
    end
  end

  class Group::Atomic
    def accept(visitor)
      visitor.visit_group_atomic(self)
    end
  end

  class Group::Passive
    def accept(visitor)
      visitor.visit_group_passive(self)
    end
  end

  class Group::Comment
    def accept(visitor)
      visitor.visit_group_comment(self)
    end
  end

  class Group::Capture
    def accept(visitor)
      visitor.visit_group_capture(self)
    end
  end

  class Group::Absence
    def accept(visitor)
      visitor.visit_group_absence(self)
    end
  end

  class Root
    def accept(visitor)
      visitor.visit_root(self)
    end
  end

  class Keep::Mark
    def accept(visitor)
      visitor.visit_keep_mark(self)
    end
  end

  class Literal
    def accept(visitor)
      visitor.visit_literal(self)
    end
  end

  class UnicodeProperty::Newline
    def accept(visitor)
      visitor.visit_unicode_property_newline(self)
    end
  end

  class UnicodeProperty::Assigned
    def accept(visitor)
      visitor.visit_unicode_property_assigned(self)
    end
  end

  class UnicodeProperty::XPosixPunct
    def accept(visitor)
      visitor.visit_unicode_property_xposix_punct(self)
    end
  end

  class UnicodeProperty::Codepoint::Surrogate
    def accept(visitor)
      visitor.visit_unicode_property_codepoint_surrogate(self)
    end
  end

  class UnicodeProperty::Codepoint::PrivateUse
    def accept(visitor)
      visitor.visit_unicode_property_codepoint_private_use(self)
    end
  end

  class UnicodeProperty::Codepoint::Any
    def accept(visitor)
      visitor.visit_unicode_property_codepoint_any(self)
    end
  end

  class UnicodeProperty::Codepoint::Unassigned
    def accept(visitor)
      visitor.visit_unicode_property_codepoint_unassigned(self)
    end
  end

  class UnicodeProperty::Codepoint::Format
    def accept(visitor)
      visitor.visit_unicode_property_codepoint_format(self)
    end
  end

  class UnicodeProperty::Codepoint::Control
    def accept(visitor)
      visitor.visit_unicode_property_codepoint_control(self)
    end
  end

  class UnicodeProperty::Emoji
    def accept(visitor)
      visitor.visit_unicode_property_emoji(self)
    end
  end

  class UnicodeProperty::Script
    def accept(visitor)
      visitor.visit_unicode_property_script(self)
    end
  end

  class UnicodeProperty::Graph
    def accept(visitor)
      visitor.visit_unicode_property_graph(self)
    end
  end

  class UnicodeProperty::Any
    def accept(visitor)
      visitor.visit_unicode_property_any(self)
    end
  end

  class UnicodeProperty::Block
    def accept(visitor)
      visitor.visit_unicode_property_block(self)
    end
  end

  class UnicodeProperty::Derived
    def accept(visitor)
      visitor.visit_unicode_property_derived(self)
    end
  end

  class UnicodeProperty::Letter::Cased
    def accept(visitor)
      visitor.visit_unicode_property_letter_cased(self)
    end
  end

  class UnicodeProperty::Letter::Uppercase
    def accept(visitor)
      visitor.visit_unicode_property_letter_uppercase(self)
    end
  end

  class UnicodeProperty::Letter::Lowercase
    def accept(visitor)
      visitor.visit_unicode_property_letter_lowercase(self)
    end
  end

  class UnicodeProperty::Letter::Titlecase
    def accept(visitor)
      visitor.visit_unicode_property_letter_titlecase(self)
    end
  end

  class UnicodeProperty::Letter::Modifier
    def accept(visitor)
      visitor.visit_unicode_property_letter_modifier(self)
    end
  end

  class UnicodeProperty::Letter::Any
    def accept(visitor)
      visitor.visit_unicode_property_letter_any(self)
    end
  end

  class UnicodeProperty::Letter::Other
    def accept(visitor)
      visitor.visit_unicode_property_letter_other(self)
    end
  end

  class UnicodeProperty::Age
    def accept(visitor)
      visitor.visit_unicode_property_age(self)
    end
  end

  class UnicodeProperty::Number::Other
    def accept(visitor)
      visitor.visit_unicode_property_number_other(self)
    end
  end

  class UnicodeProperty::Number::Decimal
    def accept(visitor)
      visitor.visit_unicode_property_number_decimal(self)
    end
  end

  class UnicodeProperty::Number::Letter
    def accept(visitor)
      visitor.visit_unicode_property_number_letter(self)
    end
  end

  class UnicodeProperty::Number::Any
    def accept(visitor)
      visitor.visit_unicode_property_number_any(self)
    end
  end

  class UnicodeProperty::Symbol::Other
    def accept(visitor)
      visitor.visit_unicode_property_symbol_other(self)
    end
  end

  class UnicodeProperty::Symbol::Math
    def accept(visitor)
      visitor.visit_unicode_property_symbol_math(self)
    end
  end

  class UnicodeProperty::Symbol::Currency
    def accept(visitor)
      visitor.visit_unicode_property_symbol_currency(self)
    end
  end

  class UnicodeProperty::Symbol::Modifier
    def accept(visitor)
      visitor.visit_unicode_property_symbol_modifier(self)
    end
  end

  class UnicodeProperty::Symbol::Any
    def accept(visitor)
      visitor.visit_unicode_property_symbol_any(self)
    end
  end

  class UnicodeProperty::Digit
    def accept(visitor)
      visitor.visit_unicode_property_digit(self)
    end
  end

  class UnicodeProperty::Punctuation::Initial
    def accept(visitor)
      visitor.visit_unicode_property_punctuation_initial(self)
    end
  end

  class UnicodeProperty::Punctuation::Final
    def accept(visitor)
      visitor.visit_unicode_property_punctuation_final(self)
    end
  end

  class UnicodeProperty::Punctuation::Any
    def accept(visitor)
      visitor.visit_unicode_property_punctuation_any(self)
    end
  end

  class UnicodeProperty::Punctuation::Open
    def accept(visitor)
      visitor.visit_unicode_property_punctuation_open(self)
    end
  end

  class UnicodeProperty::Punctuation::Other
    def accept(visitor)
      visitor.visit_unicode_property_punctuation_other(self)
    end
  end

  class UnicodeProperty::Punctuation::Connector
    def accept(visitor)
      visitor.visit_unicode_property_punctuation_connector(self)
    end
  end

  class UnicodeProperty::Punctuation::Dash
    def accept(visitor)
      visitor.visit_unicode_property_punctuation_dash(self)
    end
  end

  class UnicodeProperty::Punctuation::Close
    def accept(visitor)
      visitor.visit_unicode_property_punctuation_close(self)
    end
  end

  class UnicodeProperty::Space
    def accept(visitor)
      visitor.visit_unicode_property_space(self)
    end
  end

  class UnicodeProperty::Word
    def accept(visitor)
      visitor.visit_unicode_property_word(self)
    end
  end

  class UnicodeProperty::Separator::Line
    def accept(visitor)
      visitor.visit_unicode_property_separator_line(self)
    end
  end

  class UnicodeProperty::Separator::Paragraph
    def accept(visitor)
      visitor.visit_unicode_property_separator_paragraph(self)
    end
  end

  class UnicodeProperty::Separator::Space
    def accept(visitor)
      visitor.visit_unicode_property_separator_space(self)
    end
  end

  class UnicodeProperty::Separator::Any
    def accept(visitor)
      visitor.visit_unicode_property_separator_any(self)
    end
  end

  class UnicodeProperty::Alnum
    def accept(visitor)
      visitor.visit_unicode_property_alnum(self)
    end
  end

  class UnicodeProperty::Alpha
    def accept(visitor)
      visitor.visit_unicode_property_alpha(self)
    end
  end

  class UnicodeProperty::Ascii
    def accept(visitor)
      visitor.visit_unicode_property_ascii(self)
    end
  end

  class UnicodeProperty::Mark::Combining
    def accept(visitor)
      visitor.visit_unicode_property_mark_combining(self)
    end
  end

  class UnicodeProperty::Mark::Nonspacing
    def accept(visitor)
      visitor.visit_unicode_property_mark_nonspacing(self)
    end
  end

  class UnicodeProperty::Mark::Spacing
    def accept(visitor)
      visitor.visit_unicode_property_mark_spacing(self)
    end
  end

  class UnicodeProperty::Mark::Enclosing
    def accept(visitor)
      visitor.visit_unicode_property_mark_enclosing(self)
    end
  end

  class UnicodeProperty::Mark::Any
    def accept(visitor)
      visitor.visit_unicode_property_mark_any(self)
    end
  end

  class UnicodeProperty::Blank
    def accept(visitor)
      visitor.visit_unicode_property_blank(self)
    end
  end

  class UnicodeProperty::Cntrl
    def accept(visitor)
      visitor.visit_unicode_property_cntrl(self)
    end
  end

  class UnicodeProperty::Lower
    def accept(visitor)
      visitor.visit_unicode_property_lower(self)
    end
  end

  class UnicodeProperty::Print
    def accept(visitor)
      visitor.visit_unicode_property_print(self)
    end
  end

  class UnicodeProperty::Punct
    def accept(visitor)
      visitor.visit_unicode_property_punct(self)
    end
  end

  class UnicodeProperty::Upper
    def accept(visitor)
      visitor.visit_unicode_property_upper(self)
    end
  end

  class UnicodeProperty::Xdigit
    def accept(visitor)
      visitor.visit_unicode_property_xdigit(self)
    end
  end

  class FreeSpace
    def accept(visitor)
      visitor.visit_free_space(self)
    end
  end

  class Anchor::EndOfStringOrBeforeEndOfLine
    def accept(visitor)
      visitor.visit_anchor_end_of_string_or_before_end_of_line(self)
    end
  end

  class Anchor::BeginningOfString
    def accept(visitor)
      visitor.visit_anchor_beginning_of_string(self)
    end
  end

  class Anchor::EndOfString
    def accept(visitor)
      visitor.visit_anchor_end_of_string(self)
    end
  end

  class Anchor::BeginningOfString
    def accept(visitor)
      visitor.visit_anchor_beginning_of_string(self)
    end
  end

  class Anchor::EndOfString
    def accept(visitor)
      visitor.visit_anchor_end_of_string(self)
    end
  end

  class Anchor::EndOfStringOrBeforeEndOfLine
    def accept(visitor)
      visitor.visit_anchor_end_of_string_or_before_end_of_line(self)
    end
  end

  class Anchor::BeginningOfLine
    def accept(visitor)
      visitor.visit_anchor_beginning_of_line(self)
    end
  end

  class Anchor::BeginningOfLine
    def accept(visitor)
      visitor.visit_anchor_beginning_of_line(self)
    end
  end

  class Anchor::EndOfLine
    def accept(visitor)
      visitor.visit_anchor_end_of_line(self)
    end
  end

  class Anchor::MatchStart
    def accept(visitor)
      visitor.visit_anchor_match_start(self)
    end
  end

  class Anchor::EndOfLine
    def accept(visitor)
      visitor.visit_anchor_end_of_line(self)
    end
  end

  class Anchor::WordBoundary
    def accept(visitor)
      visitor.visit_anchor_word_boundary(self)
    end
  end

  class Anchor::NonWordBoundary
    def accept(visitor)
      visitor.visit_anchor_non_word_boundary(self)
    end
  end

  class SequenceOperation
    def accept(visitor)
      visitor.visit_sequence_operation(self)
    end
  end

  class Assertion::NegativeLookbehind
    def accept(visitor)
      visitor.visit_assertion_negative_lookbehind(self)
    end
  end

  class Assertion::Lookahead
    def accept(visitor)
      visitor.visit_assertion_lookahead(self)
    end
  end

  class Assertion::Lookbehind
    def accept(visitor)
      visitor.visit_assertion_lookbehind(self)
    end
  end

  class Assertion::NegativeLookahead
    def accept(visitor)
      visitor.visit_assertion_negative_lookahead(self)
    end
  end

  class Backreference::Number
    def accept(visitor)
      visitor.visit_backreference_number(self)
    end
  end

  class Backreference::NameRecursionLevel
    def accept(visitor)
      visitor.visit_backreference_name_recursion_level(self)
    end
  end

  class Backreference::NameCall
    def accept(visitor)
      visitor.visit_backreference_name_call(self)
    end
  end

  class Backreference::NumberRecursionLevel
    def accept(visitor)
      visitor.visit_backreference_number_recursion_level(self)
    end
  end

  class Backreference::NumberCall
    def accept(visitor)
      visitor.visit_backreference_number_call(self)
    end
  end

  class Backreference::NumberRelative
    def accept(visitor)
      visitor.visit_backreference_number_relative(self)
    end
  end

  class Backreference::NumberCallRelative
    def accept(visitor)
      visitor.visit_backreference_number_call_relative(self)
    end
  end

  class Backreference::Name
    def accept(visitor)
      visitor.visit_backreference_name(self)
    end
  end

  class EscapeSequence::Newline
    def accept(visitor)
      visitor.visit_escape_sequence_newline(self)
    end
  end

  class EscapeSequence::Backspace
    def accept(visitor)
      visitor.visit_escape_sequence_backspace(self)
    end
  end

  class EscapeSequence::AsciiEscape
    def accept(visitor)
      visitor.visit_escape_sequence_ascii_escape(self)
    end
  end

  class EscapeSequence::Bell
    def accept(visitor)
      visitor.visit_escape_sequence_bell(self)
    end
  end

  class EscapeSequence::FormFeed
    def accept(visitor)
      visitor.visit_escape_sequence_form_feed(self)
    end
  end

  class EscapeSequence::Return
    def accept(visitor)
      visitor.visit_escape_sequence_return(self)
    end
  end

  class EscapeSequence::Tab
    def accept(visitor)
      visitor.visit_escape_sequence_tab(self)
    end
  end

  class EscapeSequence::VerticalTab
    def accept(visitor)
      visitor.visit_escape_sequence_vertical_tab(self)
    end
  end

  class EscapeSequence::CodepointList
    def accept(visitor)
      visitor.visit_escape_sequence_codepoint_list(self)
    end
  end

  class EscapeSequence::Meta
    def accept(visitor)
      visitor.visit_escape_sequence_meta(self)
    end
  end

  class EscapeSequence::Octal
    def accept(visitor)
      visitor.visit_escape_sequence_octal(self)
    end
  end

  class EscapeSequence::MetaControl
    def accept(visitor)
      visitor.visit_escape_sequence_meta_control(self)
    end
  end

  class EscapeSequence::AbstractMetaControlSequence
    def accept(visitor)
      visitor.visit_escape_sequence_abstract_meta_control_sequence(self)
    end
  end

  class EscapeSequence::Literal
    def accept(visitor)
      visitor.visit_escape_sequence_literal(self)
    end
  end

  class EscapeSequence::Hex
    def accept(visitor)
      visitor.visit_escape_sequence_hex(self)
    end
  end

  class EscapeSequence::Codepoint
    def accept(visitor)
      visitor.visit_escape_sequence_codepoint(self)
    end
  end

  class EscapeSequence::Control
    def accept(visitor)
      visitor.visit_escape_sequence_control(self)
    end
  end

  class Alternation
    def accept(visitor)
      visitor.visit_alternation(self)
    end
  end

  class WhiteSpace
    def accept(visitor)
      visitor.visit_white_space(self)
    end
  end

  class PosixClass
    def accept(visitor)
      visitor.visit_posix_class(self)
    end
  end

  class Subexpression
    def accept(visitor)
      visitor.visit_subexpression(self)
    end
  end

  class Sequence
    def accept(visitor)
      visitor.visit_sequence(self)
    end
  end

  class Alternative
    def accept(visitor)
      visitor.visit_alternative(self)
    end
  end

  class CharacterSet
    def accept(visitor)
      visitor.visit_character_set(self)
    end
  end

  class CharacterType::Digit
    def accept(visitor)
      visitor.visit_character_type_digit(self)
    end
  end

  class CharacterType::NonDigit
    def accept(visitor)
      visitor.visit_character_type_non_digit(self)
    end
  end

  class CharacterType::Space
    def accept(visitor)
      visitor.visit_character_type_space(self)
    end
  end

  class CharacterType::NonSpace
    def accept(visitor)
      visitor.visit_character_type_non_space(self)
    end
  end

  class CharacterType::NonHex
    def accept(visitor)
      visitor.visit_character_type_non_hex(self)
    end
  end

  class CharacterType::NonWord
    def accept(visitor)
      visitor.visit_character_type_non_word(self)
    end
  end

  class CharacterType::Linebreak
    def accept(visitor)
      visitor.visit_character_type_linebreak(self)
    end
  end

  class CharacterType::Word
    def accept(visitor)
      visitor.visit_character_type_word(self)
    end
  end

  class CharacterType::ExtendedGrapheme
    def accept(visitor)
      visitor.visit_character_type_extended_grapheme(self)
    end
  end

  class CharacterType::Any
    def accept(visitor)
      visitor.visit_character_type_any(self)
    end
  end

  class CharacterType::Hex
    def accept(visitor)
      visitor.visit_character_type_hex(self)
    end
  end

  class Conditional::Branch
    def accept(visitor)
      visitor.visit_conditional_branch(self)
    end
  end

  class Conditional::Expression
    def accept(visitor)
      visitor.visit_conditional_expression(self)
    end
  end

  class Conditional::Condition
    def accept(visitor)
      visitor.visit_conditional_condition(self)
    end
  end
end
