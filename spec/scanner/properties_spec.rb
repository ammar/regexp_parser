require 'spec_helper'

RSpec.describe('Property scanning') do
  include_examples 'scan property', 'Alnum',                    :alnum

  include_examples 'scan property', 'XPosixPunct',              :xposixpunct

  include_examples 'scan property', 'Newline',                  :newline

  include_examples 'scan property', 'Any',                      :any

  include_examples 'scan property', 'Assigned',                 :assigned

  include_examples 'scan property', 'L',                        :letter
  include_examples 'scan property', 'Letter',                   :letter

  include_examples 'scan property', 'Lu',                       :uppercase_letter
  include_examples 'scan property', 'Uppercase_Letter',         :uppercase_letter

  include_examples 'scan property', 'Ll',                       :lowercase_letter
  include_examples 'scan property', 'Lowercase_Letter',         :lowercase_letter

  include_examples 'scan property', 'Lt',                       :titlecase_letter
  include_examples 'scan property', 'Titlecase_Letter',         :titlecase_letter

  include_examples 'scan property', 'Lm',                       :modifier_letter
  include_examples 'scan property', 'Modifier_Letter',          :modifier_letter

  include_examples 'scan property', 'Lo',                       :other_letter
  include_examples 'scan property', 'Other_Letter',             :other_letter

  include_examples 'scan property', 'M',                        :mark
  include_examples 'scan property', 'Mark',                     :mark

  include_examples 'scan property', 'Mn',                       :nonspacing_mark
  include_examples 'scan property', 'Nonspacing_Mark',          :nonspacing_mark

  include_examples 'scan property', 'Mc',                       :spacing_mark
  include_examples 'scan property', 'Spacing_Mark',             :spacing_mark

  include_examples 'scan property', 'Me',                       :enclosing_mark
  include_examples 'scan property', 'Enclosing_Mark',           :enclosing_mark

  include_examples 'scan property', 'N',                        :number
  include_examples 'scan property', 'Number',                   :number

  include_examples 'scan property', 'Nd',                       :decimal_number
  include_examples 'scan property', 'Decimal_Number',           :decimal_number

  include_examples 'scan property', 'Nl',                       :letter_number
  include_examples 'scan property', 'Letter_Number',            :letter_number

  include_examples 'scan property', 'No',                       :other_number
  include_examples 'scan property', 'Other_Number',             :other_number

  include_examples 'scan property', 'P',                        :punctuation
  include_examples 'scan property', 'Punctuation',              :punctuation

  include_examples 'scan property', 'Pc',                       :connector_punctuation
  include_examples 'scan property', 'Connector_Punctuation',    :connector_punctuation

  include_examples 'scan property', 'Pd',                       :dash_punctuation
  include_examples 'scan property', 'Dash_Punctuation',         :dash_punctuation

  include_examples 'scan property', 'Ps',                       :open_punctuation
  include_examples 'scan property', 'Open_Punctuation',         :open_punctuation

  include_examples 'scan property', 'Pe',                       :close_punctuation
  include_examples 'scan property', 'Close_Punctuation',        :close_punctuation

  include_examples 'scan property', 'Pi',                       :initial_punctuation
  include_examples 'scan property', 'Initial_Punctuation',      :initial_punctuation

  include_examples 'scan property', 'Pf',                       :final_punctuation
  include_examples 'scan property', 'Final_Punctuation',        :final_punctuation

  include_examples 'scan property', 'Po',                       :other_punctuation
  include_examples 'scan property', 'Other_Punctuation',        :other_punctuation

  include_examples 'scan property', 'S',                        :symbol
  include_examples 'scan property', 'Symbol',                   :symbol

  include_examples 'scan property', 'Sm',                       :math_symbol
  include_examples 'scan property', 'Math_Symbol',              :math_symbol

  include_examples 'scan property', 'Sc',                       :currency_symbol
  include_examples 'scan property', 'Currency_Symbol',          :currency_symbol

  include_examples 'scan property', 'Sk',                       :modifier_symbol
  include_examples 'scan property', 'Modifier_Symbol',          :modifier_symbol

  include_examples 'scan property', 'So',                       :other_symbol
  include_examples 'scan property', 'Other_Symbol',             :other_symbol

  include_examples 'scan property', 'Z',                        :separator
  include_examples 'scan property', 'Separator',                :separator

  include_examples 'scan property', 'Zs',                       :space_separator
  include_examples 'scan property', 'Space_Separator',          :space_separator

  include_examples 'scan property', 'Zl',                       :line_separator
  include_examples 'scan property', 'Line_Separator',           :line_separator

  include_examples 'scan property', 'Zp',                       :paragraph_separator
  include_examples 'scan property', 'Paragraph_Separator',      :paragraph_separator

  include_examples 'scan property', 'C',                        :other
  include_examples 'scan property', 'Other',                    :other

  include_examples 'scan property', 'Cc',                       :control
  include_examples 'scan property', 'Control',                  :control

  include_examples 'scan property', 'Cf',                       :format
  include_examples 'scan property', 'Format',                   :format

  include_examples 'scan property', 'Cs',                       :surrogate
  include_examples 'scan property', 'Surrogate',                :surrogate

  include_examples 'scan property', 'Co',                       :private_use
  include_examples 'scan property', 'Private_Use',              :private_use

  include_examples 'scan property', 'Cn',                       :unassigned
  include_examples 'scan property', 'Unassigned',               :unassigned

  include_examples 'scan property', 'Age=1.1',                  :'age=1.1'
  include_examples 'scan property', 'Age=6.0',                  :'age=6.0'
  include_examples 'scan property', 'Age=10.0',                 :'age=10.0'

  include_examples 'scan property', 'ahex',                     :ascii_hex_digit
  include_examples 'scan property', 'ASCII_Hex_Digit',          :ascii_hex_digit

  include_examples 'scan property', 'Alphabetic',               :alphabetic

  include_examples 'scan property', 'Cased',                    :cased

  include_examples 'scan property', 'cwcf',                     :changes_when_casefolded
  include_examples 'scan property', 'Changes_When_Casefolded',  :changes_when_casefolded

  include_examples 'scan property', 'cwcm',                     :changes_when_casemapped
  include_examples 'scan property', 'Changes_When_Casemapped',  :changes_when_casemapped

  include_examples 'scan property', 'cwl',                      :changes_when_lowercased
  include_examples 'scan property', 'Changes_When_Lowercased',  :changes_when_lowercased

  include_examples 'scan property', 'cwt',                      :changes_when_titlecased
  include_examples 'scan property', 'Changes_When_Titlecased',  :changes_when_titlecased

  include_examples 'scan property', 'cwu',                      :changes_when_uppercased
  include_examples 'scan property', 'Changes_When_Uppercased',  :changes_when_uppercased

  include_examples 'scan property', 'ci',                       :case_ignorable
  include_examples 'scan property', 'Case_Ignorable',           :case_ignorable

  include_examples 'scan property', 'bidic',                    :bidi_control
  include_examples 'scan property', 'Bidi_Control',             :bidi_control

  include_examples 'scan property', 'Dash',                     :dash

  include_examples 'scan property', 'dep',                      :deprecated
  include_examples 'scan property', 'Deprecated',               :deprecated

  include_examples 'scan property', 'dia',                      :diacritic
  include_examples 'scan property', 'Diacritic',                :diacritic

  include_examples 'scan property', 'ext',                      :extender
  include_examples 'scan property', 'Extender',                 :extender

  include_examples 'scan property', 'grbase',                   :grapheme_base
  include_examples 'scan property', 'Grapheme_Base',            :grapheme_base

  include_examples 'scan property', 'grext',                    :grapheme_extend
  include_examples 'scan property', 'Grapheme_Extend',          :grapheme_extend

  include_examples 'scan property', 'grlink',                   :grapheme_link
  include_examples 'scan property', 'Grapheme_Link',            :grapheme_link

  include_examples 'scan property', 'hex',                      :hex_digit
  include_examples 'scan property', 'Hex_Digit',                :hex_digit

  include_examples 'scan property', 'Hyphen',                   :hyphen

  include_examples 'scan property', 'idc',                      :id_continue
  include_examples 'scan property', 'ID_Continue',              :id_continue

  include_examples 'scan property', 'ideo',                     :ideographic
  include_examples 'scan property', 'Ideographic',              :ideographic

  include_examples 'scan property', 'ids',                      :id_start
  include_examples 'scan property', 'ID_Start',                 :id_start

  include_examples 'scan property', 'idsb',                     :ids_binary_operator
  include_examples 'scan property', 'IDS_Binary_Operator',      :ids_binary_operator

  include_examples 'scan property', 'idst',                     :ids_trinary_operator
  include_examples 'scan property', 'IDS_Trinary_Operator',     :ids_trinary_operator

  include_examples 'scan property', 'joinc',                    :join_control
  include_examples 'scan property', 'Join_Control',             :join_control

  include_examples 'scan property', 'loe',                      :logical_order_exception
  include_examples 'scan property', 'Logical_Order_Exception',  :logical_order_exception

  include_examples 'scan property', 'Lowercase',                :lowercase

  include_examples 'scan property', 'Math',                     :math

  include_examples 'scan property', 'nchar',                    :noncharacter_code_point
  include_examples 'scan property', 'Noncharacter_Code_Point',  :noncharacter_code_point

  include_examples 'scan property', 'oalpha',                   :other_alphabetic
  include_examples 'scan property', 'Other_Alphabetic',         :other_alphabetic

  include_examples 'scan property', 'ogrext',                   :other_grapheme_extend
  include_examples 'scan property', 'Other_Grapheme_Extend',    :other_grapheme_extend

  include_examples 'scan property', 'oidc',                     :other_id_continue
  include_examples 'scan property', 'Other_ID_Continue',        :other_id_continue

  include_examples 'scan property', 'oids',                     :other_id_start
  include_examples 'scan property', 'Other_ID_Start',           :other_id_start

  include_examples 'scan property', 'olower',                   :other_lowercase
  include_examples 'scan property', 'Other_Lowercase',          :other_lowercase

  include_examples 'scan property', 'omath',                    :other_math
  include_examples 'scan property', 'Other_Math',               :other_math

  include_examples 'scan property', 'oupper',                   :other_uppercase
  include_examples 'scan property', 'Other_Uppercase',          :other_uppercase

  include_examples 'scan property', 'patsyn',                   :pattern_syntax
  include_examples 'scan property', 'Pattern_Syntax',           :pattern_syntax

  include_examples 'scan property', 'patws',                    :pattern_white_space
  include_examples 'scan property', 'Pattern_Whitespace',       :pattern_white_space

  include_examples 'scan property', 'qmark',                    :quotation_mark
  include_examples 'scan property', 'quotationmark',            :quotation_mark

  include_examples 'scan property', 'radical',                  :radical

  include_examples 'scan property', 'ri',                       :regional_indicator
  include_examples 'scan property', 'Regional_Indicator',       :regional_indicator

  include_examples 'scan property', 'sd',                       :soft_dotted
  include_examples 'scan property', 'Soft-Dotted',              :soft_dotted # test dash

  include_examples 'scan property', 'sterm',                    :sentence_terminal

  include_examples 'scan property', 'term',                     :terminal_punctuation
  include_examples 'scan property', 'Terminal_Punctuation',     :terminal_punctuation

  include_examples 'scan property', 'uideo',                    :unified_ideograph
  include_examples 'scan property', 'Unified_Ideograph',        :unified_ideograph

  include_examples 'scan property', 'Uppercase',                :uppercase

  include_examples 'scan property', 'vs',                       :variation_selector
  include_examples 'scan property', 'Variation_Selector',       :variation_selector

  include_examples 'scan property', 'wspace',                   :white_space
  include_examples 'scan property', 'whitespace',               :white_space

  include_examples 'scan property', 'xids',                     :xid_start
  include_examples 'scan property', 'XID_Start',                :xid_start

  include_examples 'scan property', 'xidc',                     :xid_continue
  include_examples 'scan property', 'XID_Continue',             :xid_continue
end
