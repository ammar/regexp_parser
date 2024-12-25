require_relative 'error'

require_relative 'expression/shared'
require_relative 'expression/base'
require_relative 'expression/quantifier'
require_relative 'expression/subexpression'
require_relative 'expression/sequence'
require_relative 'expression/sequence_operation'

require_relative 'expression/classes/alternation'
require_relative 'expression/classes/anchor'
require_relative 'expression/classes/backreference'
require_relative 'expression/classes/character_set'
require_relative 'expression/classes/character_set/intersection'
require_relative 'expression/classes/character_set/range'
require_relative 'expression/classes/character_type'
require_relative 'expression/classes/conditional'
require_relative 'expression/classes/escape_sequence'
require_relative 'expression/classes/free_space'
require_relative 'expression/classes/group'
require_relative 'expression/classes/keep'
require_relative 'expression/classes/literal'
require_relative 'expression/classes/posix_class'
require_relative 'expression/classes/root'
require_relative 'expression/classes/unicode_property'

require_relative 'expression/methods/construct'
require_relative 'expression/methods/escape_sequence_char'
require_relative 'expression/methods/escape_sequence_codepoint'
require_relative 'expression/methods/human_name'
require_relative 'expression/methods/match'
require_relative 'expression/methods/match_length'
require_relative 'expression/methods/negative'
require_relative 'expression/methods/options'
require_relative 'expression/methods/parts'
require_relative 'expression/methods/printing'
require_relative 'expression/methods/strfregexp'
require_relative 'expression/methods/tests'
require_relative 'expression/methods/traverse'
