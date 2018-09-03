require "./lib/cryp_solver.rb"

require "test/unit"

class Test_cryp_solver < Test::Unit::TestCase

  def test_sample
    assert_equal(4, 2+2)
  end

  def test_something
    assert_equal(something, "something")
  end

  def test_get_indices_of_repeaters
    assert_equal([[2,3]], "hello".get_indices_of_repeaters)
    assert_equal("excellence".get_indices_of_repeaters, [[0, 3, 6, 9], [4, 5], [2, 8]])
    assert_equal("XRRXXXR".get_indices_of_repeaters('X'), [[1, 2, 6]])
  end

  def test_eliminate_based_on_repeater_positions()
    x_word = "hXUUX"
    array_of_words = ["happy", "helpy", "hurry", "health"]
    assert_equal(["happy","hurry"], eliminate_based_on_repeater_positions(x_word, array_of_words))
  end

  def test_remove_all_without
    assert_equal(["Hello"],["Hello", "world", "unwelcome"].remove_all_without('e', 1))
  end
  # 
  # def test_Guess
  #   guess_one = Guess.new()
  #   guess_one.init_WT_from_string("Q ATF'I RFTX CTX ZTW BOOE MYTWI TEA MPO... YWI QF SZ NMVO, Q AQAF'I OJOF VOO QI NTSQFP. QI CQI SO BHTS ICO HOMH. --GCZEEQV AQEEOH")
  #   assert_equal( guess_one.word_tracker, [["q", "X", nil], ["atf'i", "XXX'X", nil], ["rftx", "XXXX", nil], ["ctx", "XXX", nil], ["ztw", "XXX", nil], ["booe", "XOOX", nil], ["mytwi", "XXXXX", nil], ["tea", "XXX", nil], ["mpo", "XXX", nil], ["ywi", "XXX", nil], ["qf", "XX", nil], ["sz", "XX", nil], ["nmvo", "XXXX", nil], ["aqaf'i", "AXAX'X", nil], ["ojof", "OXOX", nil], ["voo", "XOO", nil], ["qi", "XX", nil], ["ntsqfp", "XXXXXX", nil], ["cqi", "XXX", nil], ["so", "XX", nil], ["bhts", "XXXX", nil], ["ico", "XXX", nil], ["homh", "HXXH", nil]])
  # end

  def test_Vocab
    assert_equal(["all", "see", "too", "off", "add", "egg", "fee", "odd", "ill", "ass", "bee"], Vocab.get_possible_wordlist_from_x_word("XAA"))
    assert_equal(["lion's"], Vocab.get_possible_wordlist_from_x_word("XiXn'X"))
    assert_equal(["feel", "tool", "cool", "pool", "heel", "peel", "fool"], Vocab.get_possible_wordlist_from_x_word("XEEl"))
    assert_equal(["wouldn't", "couldn't", "course's", "couple's", "source's", "county's", "cousin's"], Vocab.get_possible_wordlist_from_x_word("XouXXX'X"))
    assert_equal(["in", "if", "hi"], Vocab.get_possible_wordlist_from_x_word("XX", "b","o","t","e","m","v","a","s","c","u"))
    assert_equal(["there", "these", "where", "piece", "scene", "theme"], Vocab.get_possible_wordlist_from_x_word("XXeXe"))
    assert_equal(["where", "piece", "scene"], Vocab.get_possible_wordlist_from_x_word("XXeXe", "t"))
    assert_equal(["break"], Vocab.get_possible_wordlist_from_x_word("XXeak", "e", "s"))
    assert_equal(["what've", "what're"], Vocab.get_possible_wordlist_from_x_word("wXXX'XX"))
    assert_equal(["what've", "what're", "must've"], Vocab.get_possible_wordlist_from_x_word("XXXX'XX"))
    assert_equal(["what'll", "they'll"], Vocab.get_possible_wordlist_from_x_word("XXXX'RR"))
    assert_equal(["won't", "can't", "ain't"], Vocab.get_possible_wordlist_from_x_word("XXX'X", "s", "d"))
    assert_equal(["war's", "tax's", "rat's"], Vocab.get_possible_wordlist_from_x_word("XaX'X", *("a".."p").to_a))
  end

  def test_UsefulStrings
    assert_equal(true, "XXXXX'Xe".has_chars_besides?("X","'"))
    assert_equal(false, "XXXXX'XX".has_chars_besides?("X","'"))
    assert_equal(true, "XXXe".has_chars_besides?("X"))
    assert_equal(false, "XXXX".has_chars_besides?("X"))
    assert_equal(true, "mistakes".has_repeater_chars?)
    assert_equal(false, "mistakes".has_repeater_chars?("s"))
    assert_equal(false, "weren't".has_repeater_chars?("w", "e", "r", "n", "'"))
  end




end
