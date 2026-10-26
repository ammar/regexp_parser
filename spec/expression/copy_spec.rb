# frozen_string_literal: true

require 'spec_helper'

[:clone, :dup].each do |copy_method|
  RSpec.describe("Expression::Base##{copy_method}") do
    specify 'links a fresh tree' do
      root = RP.parse('(a)\\1\\1')
      copy = root.public_send(copy_method)

      expect(copy.to_s).to eq root.to_s
      expect(copy).not_to equal root
      expect(copy[0]).not_to equal root[0]
      expect(copy[0].parent).to equal copy
      expect(copy[1].referenced_expression).to eq root[1].referenced_expression
      expect(copy[1].referenced_expression).to equal copy[0]
      expect(copy[2].referenced_expression).to equal copy[0]
      expect(copy[1].referenced_expressions).not_to equal root[1].referenced_expressions
      expect(copy[0][0].text).to eq('a').and eq(root[0][0].text)
      expect(copy[0][0].text).not_to equal(root[0][0].text)
    end

    specify 'causes no shared state' do
      root = RP.parse(regexp_with_all_features)
      copy = root.public_send(copy_method)
      shared = Leto.shared_mutables(root, copy)
      expect(shared).to be_empty, "found shared mutables:\n#{shared.join("\n")}"
    end

    specify 'copies a frozen expression with native freeze behavior' do
      root = RP.parse('(a)\\1').freeze
      copy = root.public_send(copy_method)

      expect(copy.frozen?).to eq(copy_method == :clone)
      expect(copy[0].parent).to equal copy
      expect(copy[1].referenced_expression).to equal copy[0]
      expect(copy[0]).not_to equal root[0]
      expect(copy[0]).not_to be_frozen
    end

    specify 'copies scoped options and quantifiers' do
      root = RP.parse(/^(?i:a)b+$/i)
      copy = root.public_send(copy_method)

      expect(copy[1].options).to eq root[1].options
      expect(copy[2].quantifier.text).to eq root[2].quantifier.text

      # regression test
      expect { root[2].public_send(copy_method) }.not_to(change {
        [root[2].quantifier.object_id, root[2].quantifier.text.object_id]
      })
    end

    specify 'copies nested subexpressions without replacing the original children' do
      root = RP.parse(/^a(b([cde])f)g$/)
      copy = root.public_send(copy_method)

      expect(copy.to_s).to eq root.to_s

      # regression test
      expect { root.public_send(copy_method) }.not_to(change { root.expressions.object_id })
    end

    specify 'copies named group attributes' do
      root = RP.parse('^(?<somename>a)+bc$')
      copy = root.public_send(copy_method)

      expect(copy[1].name).to eq root[1].name
      expect(copy[1].name).not_to equal root[1].name
      expect(copy[1].text).to eq root[1].text
    end

    specify 'copies option changes without replacing the original changes' do
      root = RP.parse('foo(?i)bar')
      copy = root.public_send(copy_method)

      expect(copy[1].option_changes).to eq root[1].option_changes
      expect(copy[1].option_changes).not_to equal root[1].option_changes

      # regression test
      expect { root[1].public_send(copy_method) }
        .not_to(change { root[1].option_changes.object_id })
    end

    specify 'preserves sequence serialization' do
      root = RP.parse(/(a|b)/)
      copy = root.public_send(copy_method)

      # regression test
      expect(copy.to_s).to eq root.to_s
    end

    specify 'resolves a forward reference to a later child' do
      root = RP.parse('\\g<1>(a)')
      copy = root.public_send(copy_method)

      expect(copy[0].referenced_expression).to equal copy[1]
      expect(copy[1].parent).to equal copy
    end

    specify 'resolves recursive references to the copied root' do
      root = RP.parse('a|b\\g<0>')
      copy = root.public_send(copy_method)

      root_call = root.dig(0, 1, 1)
      copy_call = copy.dig(0, 1, 1)

      expect(copy.to_s).to eq root.to_s
      expect(copy).to eq root
      expect(copy).not_to equal root
      expect(copy_call).to eq root_call
      expect(copy_call).not_to equal root_call
      expect(copy_call.referenced_expression).to equal copy
      expect(copy.parent).to be_nil
      expect(root_call.referenced_expression).to equal root
    end

    specify 'resolves mutually recursive groups' do
      root = RP.parse('(?<a>a\\g<b>?)(?<b>b\\g<a>?)')
      copy = root.public_send(copy_method)

      expect(copy[0][1].referenced_expression).to equal copy[1]
      expect(copy[1][1].referenced_expression).to equal copy[0]
      expect(copy[0].parent).to equal copy
      expect(copy[1].parent).to equal copy
    end

    specify 'uses a separate context for each operation' do
      root = RP.parse('a|b\\g<0>')
      first = root.public_send(copy_method)
      second = root.public_send(copy_method)

      expect(first).not_to equal second
      expect(first.dig(0, 1, 1).referenced_expression).to equal first
      expect(second.dig(0, 1, 1).referenced_expression).to equal second
    end
  end
end

RSpec.describe('Expression::Base#unquantified_clone') do
  it 'produces a clone' do
    root = RP.parse(/^a(b([cde])f)g$/)
    copy = root.unquantified_clone

    expect(copy.to_s).to eq root.to_s
    expect(copy).not_to equal root
  end

  it 'does not carry over the callee quantifier' do
    [/a{3}/, /[a]{3}/, /(a|b){3}/].each do |regexp|
      expression = RP.parse(regexp)[0]

      expect(expression).to be_quantified
      expect(expression.unquantified_clone).not_to be_quantified
    end
  end

  it 'keeps quantifiers of callee children' do
    expression = RP.parse(/(a{3}){3}/)[0]

    expect(expression[0]).to be_quantified
    expect(expression.unquantified_clone[0]).to be_quantified
  end
end
