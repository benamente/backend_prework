require "./lib/cryp_solver.rb"

require "test/unit"

class Test_cryp_solver < Test::Unit::TestCase

  def test_sample
    assert_equal(4, 2+2)
  end



  def test_get_indices_of_repeaters
    assert_equal([[2,3]], "hello".get_indices_of_repeaters)
    assert_equal("excellence".get_indices_of_repeaters, [[0, 3, 6, 9], [4, 5], [2, 8]])
    assert_equal("XRRXXXR".get_indices_of_repeaters('X'), [[1, 2, 6]])
  end

  def test_remove_all_without
    assert_equal(["Hello"],["Hello", "world", "unwelcome"].remove_all_without('e', 1))
  end

  def test_Tracker
    cgram_s = "P RMF ME FCN FYUN FCN NGTNDFX, FCN TNMTRN LCM PDN XJTTMXNH FM ON PORN FM FNRR VMJ LCPF FM HM, LYRR FNRR VMJ FCPF VMJ BPI'F HM XMUNFCYIS NANI LCNI VMJ KIML VMJ BPI. PIH P RMF ME FCN FYUN YF'X VMJD EDYNIHX ... LCM FNRR VMJ VMJ BPI HM YF. --UPDK QJBKNDONDS"
    t1 = CrypTracker.new(string: cgram_s)
    t1.solve
    assert_equal(t1.solution, "A LOT OF THE TIME THE EXPERTS, THE PEOPLE WHO ARE SUPPOSED TO BE ABLE TO TELL YOU WHAT TO DO, WILL TELL YOU THAT YOU CAN'T DO SOMETHING EVEN WHEN YOU KNOW YOU CAN. AND A LOT OF THE TIME IT'S YOUR FRIENDS ... WHO TELL YOU YOU CAN DO IT. --MARK ZUCKERBERG")
  end

  def test_Vocab
    assert_equal(["all", "see", "too", "off", "add", "egg", "fee", "odd", "ill", "ass", "bee"], Vocab.get_likely_wordlist_from_x_string("XAA"))
    assert_equal(["lion's"], Vocab.get_likely_wordlist_from_x_string("XiXn'X"))
    assert_equal(["feel", "tool", "cool", "pool", "heel", "peel", "fool"], Vocab.get_likely_wordlist_from_x_string("XEEl"))
    assert_equal(["wouldn't", "couldn't", "course's", "couple's", "source's", "county's", "cousin's"], Vocab.get_likely_wordlist_from_x_string("XouXXX'X"))
    assert_equal(["in", "if", "hi"], Vocab.get_likely_wordlist_from_x_string("XX", solved_letters: ["b","o","t","e","m","v","a","s","c","u"]))
    assert_equal(["there", "these", "where", "piece", "scene", "theme"], Vocab.get_likely_wordlist_from_x_string("XXeXe"))
    assert_equal(["where", "piece", "scene"], Vocab.get_likely_wordlist_from_x_string("XXeXe", solved_letters: ["t"]))
    assert_equal(["break"], Vocab.get_likely_wordlist_from_x_string("XXeak", solved_letters: ["e", "s"]))
    assert_equal(["what're", "what've"], Vocab.get_likely_wordlist_from_x_string("wXXX'XX"))
    assert_equal(["what're", "what've", "must've"], Vocab.get_likely_wordlist_from_x_string("XXXX'XX"))
    assert_equal(["what'll", "they'll"], Vocab.get_likely_wordlist_from_x_string("XXXX'RR"))
    assert_equal(["won't", "can't", "ain't"], Vocab.get_likely_wordlist_from_x_string("XXX'X", solved_letters: ["s", "d"]))
    assert_equal(["war's", "tax's", "rat's"], Vocab.get_likely_wordlist_from_x_string("XaX'X", solved_letters: ("a".."p").to_a))
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
