require File.expand_path("../../helpers", __FILE__)

class Expressionstrfregexp < Test::Unit::TestCase

  def test_expression_strfre_alias
    assert_equal true, RP.parse(/a/).respond_to?(:strfre)
  end

  def test_expression_strfregexp_level
    root = RP.parse(/a(b(c))/)

    assert_equal 'root', root.strfregexp('%l')

    a = root.first
    assert_equal '%0', a.strfregexp('%%l')

    b = root[1].first
    assert_equal '<1>', b.strfregexp('<%l>')

    c = root[1][1].first
    assert_equal '[at: 2]', c.strfregexp('[at: %l]')
  end

  def test_expression_strfregexp_start_end
    root = RP.parse(/a(b(c))/)

    assert_equal '0', root.strfregexp('%s')
    assert_equal '7', root.strfregexp('%e')

    a = root.first
    assert_equal '%0', a.strfregexp('%%s')
    assert_equal '1', a.strfregexp('%e')

    group_1 = root[1]
    assert_equal 'GRP:1', group_1.strfregexp('GRP:%s')
    assert_equal '7', group_1.strfregexp('%e')

    b = group_1.first
    assert_equal '<@2>', b.strfregexp('<@%s>')
    assert_equal '3', b.strfregexp('%e')

    c = group_1.last.first
    assert_equal '[at: 4]',  c.strfregexp('[at: %s]')
    assert_equal '5', c.strfregexp('%e')
  end

  def test_expression_strfregexp_length
    root = RP.parse(/a[b]c/)

    assert_equal '5', root.strfregexp('%S')

    a = root.first
    assert_equal '1', a.strfregexp('%S')

    set = root[1]
    assert_equal '3', set.strfregexp('%S')
  end

  def test_expression_strfregexp_coded_offset
    root = RP.parse(/a[b]c/)

    assert_equal '@0+5', root.strfregexp('%o')

    a = root.first
    assert_equal '@0+1', a.strfregexp('%o')

    set = root[1]
    assert_equal '@1+3', set.strfregexp('%o')
  end

  def test_expression_strfregexp_type_token
    root = RP.parse(/a[b](c)/)

    assert_equal 'expression', root.strfregexp('%y')
    assert_equal 'root', root.strfregexp('%k')
    assert_equal 'expression:root', root.strfregexp('%i')
    assert_equal 'Regexp::Expression::Root', root.strfregexp('%c')

    a = root.first
    assert_equal 'literal', a.strfregexp('%y')
    assert_equal 'literal', a.strfregexp('%k')
    assert_equal 'literal:literal', a.strfregexp('%i')
    assert_equal 'Regexp::Expression::Literal', a.strfregexp('%c')

    set = root[1]
    assert_equal 'set', set.strfregexp('%y')
    assert_equal 'character', set.strfregexp('%k')
    assert_equal 'set:character', set.strfregexp('%i')
    assert_equal 'Regexp::Expression::CharacterSet', set.strfregexp('%c')

    group = root.last
    assert_equal 'group', group.strfregexp('%y')
    assert_equal 'capture', group.strfregexp('%k')
    assert_equal 'group:capture', group.strfregexp('%i')
    assert_equal 'Regexp::Expression::Group::Capture', group.strfregexp('%c')
  end

  def test_expression_strfregexp_quantifier
    root = RP.parse(/a+[b](c)?d{3,4}/)

    assert_equal '{1}', root.strfregexp('%q')
    assert_equal '', root.strfregexp('%Q')
    assert_equal '1, 1', root.strfregexp('%z, %Z')

    a = root.first
    assert_equal '{1, or-more}', a.strfregexp('%q')
    assert_equal '+', a.strfregexp('%Q')
    assert_equal '1, -1', a.strfregexp('%z, %Z')

    set = root[1]
    assert_equal '{1}', set.strfregexp('%q')
    assert_equal '', set.strfregexp('%Q')
    assert_equal '1, 1', set.strfregexp('%z, %Z')

    group = root[2]
    assert_equal '{0, 1}', group.strfregexp('%q')
    assert_equal '?', group.strfregexp('%Q')
    assert_equal '0, 1', group.strfregexp('%z, %Z')

    d = root.last
    assert_equal '{3, 4}', d.strfregexp('%q')
    assert_equal '{3,4}', d.strfregexp('%Q')
    assert_equal '3, 4', d.strfregexp('%z, %Z')
  end

  def test_expression_strfregexp_text
    root = RP.parse(/a(b(c))|[d-gk-p]+/)

    assert_equal 'a(b(c))|[d-gk-p]+', root.strfregexp('%t')
    assert_equal 'expression:root', root.strfregexp('%~t')

    alt = root.first
    assert_equal 'a(b(c))|[d-gk-p]+', alt.strfregexp('%t')
    assert_equal 'a(b(c))|[d-gk-p]+', alt.strfregexp('%T')
    assert_equal 'meta:alternation', alt.strfregexp('%~t')

    seq_1 = alt.first
    assert_equal 'a(b(c))', seq_1.strfregexp('%t')
    assert_equal 'a(b(c))', seq_1.strfregexp('%T')
    assert_equal 'expression:sequence', seq_1.strfregexp('%~t')

    group = seq_1[1]
    assert_equal '(b(c))', group.strfregexp('%t')
    assert_equal '(b(c))', group.strfregexp('%T')
    assert_equal 'group:capture', group.strfregexp('%~t')

    seq_2 = alt.last
    assert_equal '[d-gk-p]+', seq_2.strfregexp('%t')
    assert_equal '[d-gk-p]+', seq_2.strfregexp('%T')

    set = seq_2.first
    assert_equal '[d-gk-p]', set.strfregexp('%t')
    assert_equal '[d-gk-p]+', set.strfregexp('%T')
    assert_equal '[d-gk-p]+', set.strfregexp('%~t')
  end

  def test_expression_strfregexp_combined
    root = RP.parse(/a{5}|[b-d]+/)

    assert_equal '@0+11 expression:root', root.strfregexp('%b')
    assert_equal root.strfregexp('%o %i'), root.strfregexp('%b')

    assert_equal '@0+11 expression:root {1}', root.strfregexp('%m')
    assert_equal root.strfregexp('%b %q'), root.strfregexp('%m')

    assert_equal '@0+11 expression:root {1} a{5}|[b-d]+', root.strfregexp('%a')
    assert_equal root.strfregexp('%m %t'), root.strfregexp('%a')
  end

  def test_expression_strfregexp_tree
    root = RP.parse(/a[b-d]*(e(f+))?/)

    assert_equal(
      "@0+15 expression:root\n" +
      "  @0+1 a\n" +
      "  @1+6 [b-d]*\n" +
      "  @7+8 group:capture\n" +
      "    @8+1 e\n" +
      "    @9+4 group:capture\n" +
      "      @10+2 f+",
      root.strfregexp_tree('%>%o %~t')
    )
  end

  def test_expression_strfregexp_tree_separator
    root = RP.parse(/a[b-d]*(e(f+))?/)

    assert_equal(
      "@0+15 expression:root-SEP-" +
      "  @0+1 a-SEP-" +
      "  @1+6 [b-d]*-SEP-" +
      "  @7+8 group:capture-SEP-" +
      "    @8+1 e-SEP-" +
      "    @9+4 group:capture-SEP-" +
      "      @10+2 f+",
      root.strfregexp_tree('%>%o %~t', true, '-SEP-')
    )
  end

  def test_expression_strfregexp_tree_exclude_self
    root = RP.parse(/a[b-d]*(e(f+))?/)

    assert_equal(
      "@0+1 a\n" +
      "@1+6 [b-d]*\n" +
      "@7+8 group:capture\n" +
      "  @8+1 e\n" +
      "  @9+4 group:capture\n" +
      "    @10+2 f+",
      root.strfregexp_tree('%>%o %~t', false)
    )
  end

end
