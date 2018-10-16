require 'spec_helper'

RSpec.describe('Type scanning') do
  tests = {
    'a\\dc' => [1, :type, :digit, '\\d', 1, 3],
    'a\\Dc' => [1, :type, :nondigit, '\\D', 1, 3],
    'a\\hc' => [1, :type, :hex, '\\h', 1, 3],
    'a\\Hc' => [1, :type, :nonhex, '\\H', 1, 3],
    'a\\sc' => [1, :type, :space, '\\s', 1, 3],
    'a\\Sc' => [1, :type, :nonspace, '\\S', 1, 3],
    'a\\wc' => [1, :type, :word, '\\w', 1, 3],
    'a\\Wc' => [1, :type, :nonword, '\\W', 1, 3],
    'a\\Rc' => [1, :type, :linebreak, '\\R', 1, 3],
    'a\\Xc' => [1, :type, :xgrapheme, '\\X', 1, 3],
  }

  tests.each do |(pattern, (index, type, token, text, ts, te))|
    specify("scanner_#{type}_#{token}") do
      tokens = RS.scan(pattern)
      result = tokens.at(index)

      expect(result[0]).to eq type
      expect(result[1]).to eq token
      expect(result[2]).to eq text
      expect(result[3]).to eq ts
      expect(result[4]).to eq te
    end
  end
end
