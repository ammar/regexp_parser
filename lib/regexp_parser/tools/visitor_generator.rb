require 'erb'
require 'regexp_parser'

module Regexp::Tools
  class VisitorGenerator
    attr_reader :root_mod

    def initialize(root_mod = Regexp::Expression)
      @root_mod = root_mod
    end

    def visitor_code
      ERB.new(<<~END).result(binding).gsub(/^\s+\n/, "\n")
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
        <% each_class do |c| %>
          def <%= visitor_mtd_name(c) %>(node)
            puts "Visiting \#{node.type}" if $debug
          <% if c.instance_methods.include?(:expressions) %>
            visit_children(node)
          <% end %>end
        <% end %>end
      END
    end

    def node_code
      ERB.new(<<~END).result(binding)
        module Regexp::Expression<% each_class do |c| %>
          class <%= c.name.split('::')[2..-1].join('::') %>
            def accept(visitor)
              visitor.<%= visitor_mtd_name(c) %>(self)
            end
          end
        <% end %>end
      END
    end

    private

    def visitor_mtd_name(klass)
      name = klass.name
        .split('::')[2..-1].join('_')
        .gsub(/([a-z])([A-Z])/) { "#{$1}_#{$2}" }
        .downcase

      "visit_#{name}"
    end

    def each_class(mod = root_mod, &block)
      return to_enum(__method__, mod) unless block

      case mod
        when Class
          return if mod.name.split('::').last == 'Base'
          return unless mod < Regexp::Expression::Base
          yield mod
        when Module
          mod.constants.each do |c|
            each_class(mod.const_get(c), &block)
          end
      end
    end
  end
end
