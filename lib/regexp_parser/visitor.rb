require 'regexp_parser/visitor_nodes'

class Regexp::Visitor
  def visit_children(node)
    node.expressions.each do |exp|
      exp.accept(self)
    end
  end

  def visit(node)
    node.accept(self)
  end

  def visit_comment(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_group_options(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_group_named(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_group_atomic(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_group_passive(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_group_comment(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_group_capture(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_group_absence(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_root(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_keep_mark(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_literal(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_newline(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_assigned(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_xposix_punct(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_codepoint_surrogate(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_codepoint_private_use(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_codepoint_any(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_codepoint_unassigned(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_codepoint_format(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_codepoint_control(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_emoji(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_script(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_graph(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_any(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_block(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_derived(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_letter_cased(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_letter_uppercase(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_letter_lowercase(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_letter_titlecase(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_letter_modifier(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_letter_any(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_letter_other(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_age(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_number_other(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_number_decimal(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_number_letter(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_number_any(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_symbol_other(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_symbol_math(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_symbol_currency(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_symbol_modifier(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_symbol_any(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_digit(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_punctuation_initial(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_punctuation_final(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_punctuation_any(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_punctuation_open(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_punctuation_other(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_punctuation_connector(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_punctuation_dash(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_punctuation_close(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_space(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_word(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_separator_line(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_separator_paragraph(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_separator_space(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_separator_any(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_alnum(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_alpha(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_ascii(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_mark_combining(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_mark_nonspacing(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_mark_spacing(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_mark_enclosing(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_mark_any(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_blank(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_cntrl(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_lower(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_print(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_punct(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_upper(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_unicode_property_xdigit(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_free_space(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_anchor_end_of_string_or_before_end_of_line(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_anchor_beginning_of_string(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_anchor_end_of_string(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_anchor_beginning_of_string(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_anchor_end_of_string(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_anchor_end_of_string_or_before_end_of_line(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_anchor_beginning_of_line(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_anchor_beginning_of_line(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_anchor_end_of_line(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_anchor_match_start(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_anchor_end_of_line(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_anchor_word_boundary(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_anchor_non_word_boundary(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_sequence_operation(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_assertion_negative_lookbehind(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_assertion_lookahead(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_assertion_lookbehind(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_assertion_negative_lookahead(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_backreference_number(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_backreference_name_recursion_level(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_backreference_name_call(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_backreference_number_recursion_level(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_backreference_number_call(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_backreference_number_relative(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_backreference_number_call_relative(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_backreference_name(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_escape_sequence_newline(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_escape_sequence_backspace(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_escape_sequence_ascii_escape(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_escape_sequence_bell(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_escape_sequence_form_feed(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_escape_sequence_return(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_escape_sequence_tab(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_escape_sequence_vertical_tab(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_escape_sequence_codepoint_list(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_escape_sequence_meta(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_escape_sequence_octal(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_escape_sequence_meta_control(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_escape_sequence_abstract_meta_control_sequence(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_escape_sequence_literal(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_escape_sequence_hex(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_escape_sequence_codepoint(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_escape_sequence_control(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_alternation(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_white_space(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_posix_class(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_subexpression(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_sequence(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_alternative(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_character_set(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_character_type_digit(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_character_type_non_digit(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_character_type_space(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_character_type_non_space(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_character_type_non_hex(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_character_type_non_word(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_character_type_linebreak(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_character_type_word(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_character_type_extended_grapheme(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_character_type_any(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_character_type_hex(node)
    puts "Visiting #{node.type}" if $debug
  end

  def visit_conditional_branch(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_conditional_expression(node)
    puts "Visiting #{node.type}" if $debug

    visit_children(node)
  end

  def visit_conditional_condition(node)
    puts "Visiting #{node.type}" if $debug
  end
end
