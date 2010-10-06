%%{
  machine re;

  action character_type   {}
  action anchor           {}
  action escape_sequence  {}
  action character_class  {}
  action zero_or_one      {}
  action zero_or_more     {}
  action one_or_more      {}
  action literal          {}

  main := |*

    '\\'+[dDhHsSwW] {
      tree << Node::CharacterType.new(data, ts, te)
    };

    '\\'+[AbBzZG] {
      tree << Node::Anchor.new(data, ts, te)
    };

    # escaped chars aren't really nodes, are they? maybe not always.
    #'\\' {
    #  tree << Node::Base.new(:escape_sequence , data, ts, te)
    #};

    # any probably is too much, escapes can occur in sets
    '['.any+.']' {
      tree << Node::CharacterSet.new(data, ts, te)
    };

    '(' {
      newtree = Node::Group.new(data, ts, te)
      nesting.push newtree
      tree << newtree
      tree=newtree
    };

    ')' {
      nesting.pop
      tree=nesting.last
    };

    # incomplte, there's more than just alpha
    alpha+ {
      tree << Node::Literal.new(data, ts, te)
    };

    # doesn't account for exact, min only, or max only, not to mention ugly
    '{'.[0-9]+.space*.','.space*.[0-9]+.'}' {
      range = data[ts..te-1].pack('c*').gsub(/\{|\}/, '').split(',').each {|i| i.strip}
      tree.last_node.quantify(:repetetion, range.first, range.last)
    };

    '?' { tree.last_node.quantify(:zero_or_one,  0, 1) };
    '*' { tree.last_node.quantify(:zero_or_more, 0) };
    '+' { tree.last_node.quantify(:one_or_more,  1) };

  *|;

}%%

require File.expand_path('../tree', __FILE__)
require File.expand_path('../node', __FILE__)

class Regexp
  module Parser
    %% write data;

    def self.parse(data)
      data = data.source if data.is_a?(Regexp) # or #to_s to get options?
      data = data.unpack("c*") if data.is_a?(String)

      eof  = data.length

      nesting=[tree = Tree.new]

      %% write init;
      %% write exec;

      tree
    end

  end # module Parser
end # class Regexp
