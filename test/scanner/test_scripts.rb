require File.expand_path("../../helpers", __FILE__)

class ScannerUnicodeScripts < Test::Unit::TestCase

  tests = {
    'Aghb'		                => :script_caucasian_albanian,
    'Caucasian Albanian'		  => :script_caucasian_albanian,

    'Arab'		                => :script_arabic,
    'Arabic'		              => :script_arabic,

    'Armi'		                => :script_imperial_aramaic,
    'Imperial Aramaic'        => :script_imperial_aramaic,

    'Armn'                    => :script_armenian,
    'Armenian'                => :script_armenian,

    'Avst'                    => :script_avestan,
    'Avestan'                 => :script_avestan,

    'Bali'                    => :script_balinese,
    'Balinese'                => :script_balinese,

    'Bamu'                    => :script_bamum,
	  'Bamum'                   => :script_bamum,

    'Bass'                    => :script_bassa_vah,
	  'Bassa Vah'               => :script_bassa_vah,

    'Batk'                    => :script_batak,
	  'Batak'                   => :script_batak,

    'Beng'                    => :script_bengali,
	  'Bengali'                 => :script_bengali,

    'Bopo'                    => :script_bopomofo,
	  'Bopomofo'                => :script_bopomofo,

    'Brah'                    => :script_brahmi,
	  'Brahmi'                  => :script_brahmi,

    'Brai'                    => :script_braille,
	  'Braille'                 => :script_braille,

    'Bugi'                    => :script_buginese,
	  'Buginese'                => :script_buginese,

    'Buhd'                    => :script_buhid,
	  'Buhid'                   => :script_buhid,

    'Cans'                    => :script_canadian_aboriginal,
	  'Canadian Aboriginal'     => :script_canadian_aboriginal,

    'Cari'                    => :script_carian,
	  'Carian'                  => :script_carian,

    'Cham'                    => :script_cham,

    'Cher'                    => :script_cherokee,
	  'Cherokee'                => :script_cherokee,

    'Copt'                    => :script_coptic,
	  'Coptic'                  => :script_coptic,
	  'Qaac'                    => :script_coptic,

    'Cprt'                    => :script_cypriot,
	  'Cypriot'                 => :script_cypriot,

    'Cyrl'                    => :script_cyrillic,
	  'Cyrillic'                => :script_cyrillic,

    'Deva'                    => :script_devanagari,
	  'Devanagari'              => :script_devanagari,

    'Dsrt'                    => :script_deseret,
	  'Deseret'                 => :script_deseret,


    'Dupl'                    => :script_duployan,
	  'Duployan'                => :script_duployan,


    'Egyp'                    => :script_egyptian_hieroglyphs,
	  'Egyptian Hieroglyphs'    => :script_egyptian_hieroglyphs,

    'Elba'                    => :script_elbasan,
	  'Elbasan'                 => :script_elbasan,

    'Ethi'                    => :script_ethiopic,
	  'Ethiopic'                => :script_ethiopic,

    'Geor'                    => :script_georgian,
	  'Georgian'                => :script_georgian,

    'Glag'                    => :script_glagolitic,
	  'Glagolitic'              => :script_glagolitic,

    'Goth'                    => :script_gothic,
	  'Gothic'                  => :script_gothic,

    'Gran'                    => :script_grantha,
	  'Grantha'                 => :script_grantha,

    'Grek'                    => :script_greek,
	  'Greek'                   => :script_greek,

    'Gujr'                    => :script_gujarati,
	  'Gujarati'                => :script_gujarati,

    'Guru'                    => :script_gurmukhi,
	  'Gurmukhi'                => :script_gurmukhi,

    'Hang'                    => :script_hangul,
	  'Hangul'                  => :script_hangul,

    'Hani'                    => :script_han,
	  'Han'                     => :script_han,

    'Hano'                    => :script_hanunoo,
	  'Hanunoo'                 => :script_hanunoo,

    'Hebr'                    => :script_hebrew,
	  'Hebrew'                  => :script_hebrew,

    'Hira'                    => :script_hiragana,
	  'Hiragana'                => :script_hiragana,

    'Hmng'                    => :script_pahawh_hmong,
	  'Pahawh Hmong'            => :script_pahawh_hmong,

    'Hrkt'                    => :script_katakana_or_hiragana,
	  'Katakana or Hiragana'    => :script_katakana_or_hiragana,

    'Ital'                    => :script_old_italic,
	  'Old Italic'              => :script_old_italic,

    'Java'                    => :script_javanese,
	  'Javanese'                => :script_javanese,

    'Kali'                    => :script_kayah_li,
	  'Kayah Li'                => :script_kayah_li,

    'Kana'                    => :script_katakana,
	  'Katakana'                => :script_katakana,

    'Khar'                    => :script_kharoshthi,
	  'Kharoshthi'              => :script_kharoshthi,

    'Khmr'                    => :script_khmer,
	  'Khmer'                   => :script_khmer,

    'Khoj'                    => :script_khojki,
	  'Khojki'                  => :script_khojki,

    'Knda'                    => :script_kannada,
	  'Kannada'                 => :script_kannada,

    'Kthi'                    => :script_kaithi,
	  'Kaithi'                  => :script_kaithi,

    'Lana'                    => :script_tai_tham,
	  'Tai Tham'                => :script_tai_tham,

    'Laoo'                    => :script_lao,
	  'Lao'                     => :script_lao,

    'Latn'                    => :script_latin,
	  'Latin'                   => :script_latin,

    'Lepc'                    => :script_lepcha,
	  'Lepcha'                  => :script_lepcha,

    'Limb'                    => :script_limbu,
	  'Limbu'                   => :script_limbu,

    'Lina'                    => :script_linear_a,
	  'Linear A'                => :script_linear_a,

    'Linb'                    => :script_linear_b,
	  'Linear B'                => :script_linear_b,

    'Lisu'                    => :script_lisu,

    'Lyci'                    => :script_lycian,
	  'Lycian'                  => :script_lycian,

    'Lydi'                    => :script_lydian,
	  'Lydian'                  => :script_lydian,

    'Mand'                    => :script_mandaic,
	  'Mandaic'                 => :script_mandaic,

    'Mlym'                    => :script_malayalam,
	  'Malayalam'               => :script_malayalam,

    'Mahj'                    => :script_mahajani,
	  'Mahajani'                => :script_mahajani,

    'Mani'                    => :script_manichaean,
	  'Manichaean'              => :script_manichaean,

    'Mend'                    => :script_mende_kikakui,
	  'Mende Kikakui'           => :script_mende_kikakui,

    'Modi'                    => :script_modi,

    'Mong'                    => :script_mongolian,
	  'Mongolian'               => :script_mongolian,

    'Mroo'                    => :script_mro,
	  'Mro'                     => :script_mro,

    'Mtei'                    => :script_meetei_mayek,
	  'Meetei Mayek'            => :script_meetei_mayek,

    'Mymr'                    => :script_myanmar,
	  'Myanmar'                 => :script_myanmar,

    'Narb'                    => :script_old_north_arabian,
	  'Old North Arabian'       => :script_old_north_arabian,

    'Nbat'                    => :script_nabataean,
	  'Nabataean'               => :script_nabataean,

    'Nkoo'                    => :script_nko,
	  'Nko'                     => :script_nko,

    'Ogam'                    => :script_ogham,
	  'Ogham'                   => :script_ogham,

    'Olck'                    => :script_ol_chiki,
	  'Ol Chiki'                => :script_ol_chiki,

    'Orkh'                    => :script_old_turkic,
	  'Old Turkic'              => :script_old_turkic,

    'Orya'                    => :script_oriya,
	  'Oriya'                   => :script_oriya,

    'Osma'                    => :script_osmanya,
	  'Osmanya'                 => :script_osmanya,

    'Palm'                    => :script_palmyrene,
	  'Palmyrene'               => :script_palmyrene,

    'Pauc'                    => :script_pau_cin_hau,
	  'Pau Cin Hau'             => :script_pau_cin_hau,

    'Perm'                    => :script_old_permic,
	  'Old Permic'              => :script_old_permic,

    'Phag'                    => :script_phags_pa,
	  'Phags Pa'                => :script_phags_pa,

    'Phli'                    => :script_inscriptional_pahlavi,
	  'Inscriptional Pahlavi'   => :script_inscriptional_pahlavi,

    'Phlp'                    => :script_psalter_pahlavi,
	  'Psalter Pahlavi'         => :script_psalter_pahlavi,

    'Phnx'		                => :script_phoenician,
	  'Phoenician'		          => :script_phoenician,

    'Prti'		                => :script_inscriptional_parthian,
	  'Inscriptional Parthian'  => :script_inscriptional_parthian,

    'Rjng'                    => :script_rejang,
	  'Rejang'                  => :script_rejang,

    'Runr'                    => :script_runic,
	  'Runic'                   => :script_runic,

    'Samr'                    => :script_samaritan,
	  'Samaritan'               => :script_samaritan,

    'Sarb'                    => :script_old_south_arabian,
	  'Old South Arabian'       => :script_old_south_arabian,

    'Saur'                    => :script_saurashtra,
	  'Saurashtra'              => :script_saurashtra,

    'Shaw'                    => :script_shavian,
	  'Shavian'                 => :script_shavian,

    'Sidd'                    => :script_siddham,
	  'Siddham'                 => :script_siddham,

    'Sind'                    => :script_khudawadi,
	  'Khudawadi'               => :script_khudawadi,

    'Sinh'                    => :script_sinhala,
	  'Sinhala'                 => :script_sinhala,

    'Sund'                    => :script_sundanese,
	  'Sundanese'               => :script_sundanese,

    'Sylo'                    => :script_syloti_nagri,
	  'Syloti Nagri'            => :script_syloti_nagri,

    'Syrc'                    => :script_syriac,
	  'Syriac'                  => :script_syriac,

    'Tagb'                    => :script_tagbanwa,
	  'Tagbanwa'                => :script_tagbanwa,

    'Tale'                    => :script_tai_le,
	  'Tai Le'                  => :script_tai_le,

    'Talu'                    => :script_new_tai_lue,
	  'New Tai Lue'             => :script_new_tai_lue,

    'Taml'                    => :script_tamil,
	  'Tamil'                   => :script_tamil,

    'Tavt'                    => :script_tai_viet,
	  'Tai Viet'                => :script_tai_viet,

    'Telu'                    => :script_telugu,
	  'Telugu'                  => :script_telugu,

    'Tfng'                    => :script_tifinagh,
	  'Tifinagh'                => :script_tifinagh,

    'Tglg'                    => :script_tagalog,
	  'Tagalog'                 => :script_tagalog,

    'Thaa'                    => :script_thaana,
	  'Thaana'                  => :script_thaana,

    'Thai'                    => :script_thai,

    'Tibt'                    => :script_tibetan,
	  'Tibetan'                 => :script_tibetan,

    'Tirh'                    => :script_tirhuta,
	  'Tirhuta'                 => :script_tirhuta,

    'Ugar'                    => :script_ugaritic,
	  'Ugaritic'                => :script_ugaritic,

    'Vaii'                    => :script_vai,
	  'Vai'                     => :script_vai,

    'Wara'                    => :script_warang_citi,
	  'Warang Citi'             => :script_warang_citi,

    'Xpeo'                    => :script_old_persian,
	  'Old Persian'             => :script_old_persian,

    'Xsux'                    => :script_cuneiform,
	  'Cuneiform'               => :script_cuneiform,

    'Yiii'                    => :script_yi,
	  'Yi'                      => :script_yi,

    'Zinh'                    => :script_inherited,
	  'Inherited'               => :script_inherited,
	  'Qaai'                    => :script_inherited,

    'Zyyy'                    => :script_common,
	  'Common'                  => :script_common,

    'Zzzz'                    => :script_unknown,
	  'Unknown'                 => :script_unknown,
  }

  tests.each_with_index do |(property, token), count|
    define_method "test_scanner_property_#{token}_#{count}" do
      tokens = RS.scan("a\\p{#{property}}c")
      result = tokens.at(1)

      assert_equal :property, result[0]
      assert_equal token,     result[1]
    end

    define_method "test_scanner_nonproperty_#{token}_#{count}" do
      tokens = RS.scan("a\\P{#{property}}c")
      result = tokens.at(1)

      assert_equal :nonproperty, result[0]
      assert_equal token,        result[1]
    end
  end

end
