module Regexp::Expression
  class Base

    # Test if this expression has the given test_type, which can be either
    # a symbol or an array of symbols to check against the expression's type.
    #
    #   # is it a :group expression
    #   exp.type? :group
    #
    #   # is it a :set, :subset, or :meta
    #   exp.type? [:set, :subset, :meta]
    #
    def type?(test_type)
      case test_type
      when Array
        if test_type.include?(:*)
          return (test_type.include?(type) or test_type.include?(:*))
        else
          return test_type.include?(type)
        end
      when Symbol
        return (type == test_type or test_type == :*)
      else
        raise "Array or Symbol expected, #{test_type.class.name} given"
      end
    end

    # Test if this expression has the given test_token, and optionally a given
    # test_type.
    #
    #   # Any expressions
    #   exp.is? :*  # always returns true
    #
    #   # is it a :capture
    #   exp.is? :capture
    #
    #   # is it a :character and a :set
    #   exp.is? :character, :set
    #
    #   # is it a :meta :dot
    #   exp.is? :dot, :meta
    #
    #   # is it a :meta or :escape :dot
    #   exp.is? :dot, [:meta, :escape]
    #
    def is?(test_token, test_type = nil)
      return true if test_token === :*
      token == test_token and (test_type ? type?(test_type) : true)
    end

    # Test if this expression matches an entry in the given scope spec.
    #
    # A scope spec can be one of:
    #
    #   . An array: Interpreted as a set of tokens, tested for inclusion
    #               of the expression's token.
    #
    #   . A hash:   Where the key is interpreted as the expression type
    #               and the value is either a symbol or an array. In this
    #               case, when the scope is a hash, one_of? calls itself to
    #               evaluate the key's value.
    #
    #   . A symbol: matches the expression's token or type, depending on
    #               the level of the call. If one_of? is called directly with
    #               a symbol then it will always be checked against the
    #               type of the expression. If it's being called for a value
    #               from a hash, it will be checked against the token of the
    #               expression.
    #
    #   # any expression
    #   exp.one_of?(:*) # always true
    #
    #   # like exp.type?(:group)
    #   exp.one_of?(:group)
    #
    #   # any expression of type meta
    #   exp.one_of?(:meta => :*)
    #
    #   # meta dots and alternations
    #   exp.one_of?(:meta => [:dot, :alternation])
    #
    #   # meta dots and any set tokens
    #   exp.one_of?({meta: [:dot], set: :*})
    #
    def one_of?(scope, top = true)
      case scope
      when Array
        if scope.include?(:*)
          return (scope.include?(token) or scope.include?(:*))
        else
          return scope.include?(token)
        end

      when Hash
        if scope.has_key?(:*)
          test_type = scope.has_key?(type) ? type : :*
          return one_of?(scope[test_type], false)
        else
          return (scope.has_key?(type) and one_of?(scope[type], false))
        end

      when Symbol
        return true if scope == :*

        return is?(scope) unless top
        return type?(scope) if top

      else
        raise "Array, Hash, or Symbol expected, #{scope.class.name} given"
      end

      false
    end

  end
end
