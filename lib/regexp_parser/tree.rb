module Regexp::Parser

  class Tree
    attr_reader :nodes, :last_node

    def initialize
      @nodes     = []
      @last_node = nil
    end

    def <<(node)
      @nodes << (@last_node = node)
    end
  end

end
