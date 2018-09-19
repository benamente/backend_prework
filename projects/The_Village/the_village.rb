
require("pry")

require ("pp")
require ("yaml")
#Adding some methods to arrays and strings

class String
  def initial
    self[0,1]
  end
end

class Array
  def has_previous(item, index)
    test_arr = [0...index]
    return test_arr.include?(item)
  end
end

#Loose Methods

def get_objects_initials(arr)
  a = ""
  arr.each do |x|
    a += x.name.initial
  end
  return a
end

def get_choice(deck)
  count = 0
  deck.each do|x|
    if deck.index(x) == count
      print "Enter #{x.name.initial} for #{x.name}. "
    end
    count += 1
  end
  user_choice = ""
  user_choice = gets.chomp.upcase
  if user_choice == ""
    puts "invalid entry"
    return get_choice(deck)
  end
  if get_objects_initials(deck).include?(user_choice)
    #If I were really smart/had time, I could get it to handle cases where the initials are the same. The code would go here.
    deck.each do|x|
      if user_choice == x.name.initial
        return x
      end
    end
  else
    puts "invalid entry"
    get_choice(deck)
  end
end




def get_smallest_cost(arr)
  cheapest = arr[0].cost
  arr.each do |x|
    if x.cost < cheapest
      cheapest = x.cost
    end
  end
  return cheapest
end

def sum_buy(arr)
  count = 0
  arr.each do |x|
    count += x.buy
  end
  return count
end

def sum_force(arr)
  count = 0
  arr.each do |x|
    count += x.force
  end
  return count
end

def list(arr)
  deck_list = ""
  arr.each do |x|
    card_name = x.to_s
    deck_list += card_name
    deck_list += " "
  end
  return "  #{deck_list}"
end

#Only defining three classes: Ability, Card_type, Deck
#Defining each card type as a class seems unnecessary.

class Ability
  attr_accessor :name, :action, :info
  def initialize(name, action, info)
    @name = name
    @action = action
    @info = info
  end
  def activate
    action.call
  end
end

class Card_type
  attr_accessor :name, :cost, :buy, :force, :ability
  def initialize (name="", cost=0, buy=0, force=0, ability=nil)
    @name = name
    @cost = cost
    @buy = buy
    @force = force
    @ability = ability
  end

  def to_s
    "#{@name}"
  end
  def list_info
    if @ability.is_a?(Ability) == false
      "#{@name}-- Cost: #{@cost}  Buy: #{@buy}  Force: #{@force}"
    else
      "#{@name}-- Cost: #{@cost}  Buy: #{@buy}  Force: #{@force}  Ability: #{@ability.info}"
    end
  end

  def activate
    @ability.call
  end
end

def list_a_info(arr)
  arr.each do |x|
    puts "  " + x.list_info
  end
end

class Deck
  attr_accessor :name, :draw, :hand, :discard, :as_a, :hnum, :fnum, :pnum, :tnum, :hb, :hf
  def initialize(name = "", draw = Array.new, hand = Array.new, discard = Array.new)
    @name = name
    @draw = draw
    @hand = hand
    @discard = discard
    @as_a = [@draw, @hand, @discard]
    @draw.shuffle!
    @hb = 0
    @hf = 0
  end
  def draw_out(amount)
    if @draw.length < amount
      diff = amount - @draw.length
      puts "#{@name} has gone through all  #{@draw.length + @hand.length + @discard.length} of its cards. Reshuffling..."
      out = @draw.clone
      @draw.clear
      @draw.concat(@discard)
      @discard.clear
      @draw.shuffle!
      out.concat(@draw.shift(diff))

    else
      out = @draw.shift(amount)
    end
    return out
  end

  def draw_hand(amount)
    @hand.concat(draw_out(amount))
  end

  def discard_hand
    @discard.concat(hand)
    @hand.clear
  end

  def count_total(obj)
    return @draw.count(obj) + @hand.count(obj) + @discard.count(obj)
  end

  def set_stats
    @hnum = self.count_total(HUT)
    @fnum = self.count_total(FARM)
    @pnum = self.count_total(PITCHFORK)
    @tnum = self.count_total(TORCH)
  end
  def set_hand_stats
    @hf = sum_force(@hand)
    @hb = sum_buy(@hand) + $ability_buy
    $ability_buy = 0

  end

  def activate_abilities(cards)
    cards.each do |x|
      if x.ability.is_a?(Ability)
        x.ability.activate
      end
    end
    if $extra_cards != [] && $extra_cards != nil
      $player_deck.hand.concat($extra_cards)
      extra = $extra_cards.clone
      $extra_cards.clear
      self.activate_abilities(extra)
    end
  end
end



#Procs to be passed as arguments into Abilities

ADD_DISTANCE = Proc.new do
  $distance += $player_deck.tnum
end

ADD_FOOD = Proc.new do
  $food += 2
end

ADD_FOOD_AND_BUY = Proc.new do
  $food += $player_deck.fnum
  $ability_buy += $player_deck.pnum
end

MIDWIFE_PROC = Proc.new do
  increase = $player_deck.count_total(HUT) / 2
  $villager_count += increase
  puts "(Midwife)Your population increases by #{increase}."


end

ADD_PUNISHMENT = Proc.new do
  $punishment += 1
end

LIGHT_ON = Proc.new do
  $light_tof = true
end

MARKET_PROC = Proc.new do
  $extra_cards.concat($player_deck.draw_out(2))
  $store_deck.draw_hand(2)
end

#Initiating Abilities to be passed into card types
AGRICULTURE = Ability.new("Agriculture", ADD_FOOD_AND_BUY, "Adds food equal to the number of farms in your deck. Adds buy equal to pitchforks.")
LIGHT = Ability.new("Light", LIGHT_ON, "During attack, light allows you to decide which item the monster destroys.")
MARKET = Ability.new("Market", MARKET_PROC, "2 more cards become available to buy. Draw 2 cards.")
POPULATE = Ability.new("Populate", MIDWIFE_PROC, "Increases your population by the number of huts and farms in your deck/2 rounded down.")
PROVIDE = Ability.new("Provide", ADD_FOOD, "Provides 2 food, satisfying the monster's appetite.")
PUNISH = Ability.new("Punish", ADD_PUNISHMENT, "During attack, punishing blows decrease the monster's appetite by 1.")
DISTANCE = Ability.new("Distance", ADD_DISTANCE, "During attack, draw cards equal to your total torches and add their force to damage.")



#Initiating card types
MIDWIFE = Card_type.new("Midwife", 4, 0, 0, POPULATE)

HUT = Card_type.new("Hut", 1, 1)
FARM = Card_type.new("Farm", 2, 1, 0, PROVIDE)
DEALER = Card_type.new("Dealer", 3, 0, 0, MARKET)
WINDMILL = Card_type.new("Windmill", 4, 1, 0, AGRICULTURE)

PITCHFORK = Card_type.new("Pitchfork", 1, 0, 1)
TORCH = Card_type.new("Torch", 2, 0, 1, LIGHT)
BOWANDARROW = Card_type.new("Bow&Arrow", 4, 0, 2, DISTANCE)
SWORD = Card_type.new("Sword", 4, 0, 3, PUNISH)



#Setting global integers and booleans
$villager_count = 20
$monster_health = 20
$month = 0

$monster_appetite = 2
$monster_armor = 2

$distance = 0
$food = 0
$punishment = 0
$light_tof = false

$extra_cards = []

$ability_buy =0


#Dealing cards. Using global variables. Would be interested in learning how to restructure things so I don't need them. Class variables?
$player_deck = Deck.new("Player Deck", [HUT]*6 + [PITCHFORK] + [MIDWIFE] + [WINDMILL] + [TORCH])
$store_deck = Deck.new("Store Deck", [HUT]*80 + [PITCHFORK]*80 + [FARM]*70 + [TORCH]*70 + [DEALER]*50 + [BOWANDARROW]*40 + [SWORD]*40 + [WINDMILL]*30 + [MIDWIFE]*30)

$player_deck.draw_hand(5)
$store_deck.draw_hand(5)


#Defining methods to be included in a while loop that will run the game






def display_routine
  puts "\nMonths passed: #{$month}"
  puts "Villagers left: #{$villager_count}"
  puts "Monster health: #{$monster_health}" + "  Appetite: #{$monster_appetite}"

  puts "Your hand: " + list($player_deck.hand)
  puts "Draw pile: #{$player_deck.draw.length}  Discard pile: #{$player_deck.discard.length}"

  puts "Force: " + "#{$player_deck.hf}" + "  Buy power: " + "#{$player_deck.hb}"

  puts "\n    Available to buy:"
  $store_deck.as_a[1].each do |x|
    puts "  " + x.list_info
  end

end


def attack_or_buy_routine
  puts "\nAttack or Buy? (Enter A or B)?"
  $atk_or_buy = ""
  $atk_or_buy = gets.chomp.downcase
  if $atk_or_buy == 'a'
    puts "ATTACK!!!!"
    attack_routine
  elsif $atk_or_buy == 'b'
    $bought = false
    purchase_routine
  elsif $atk_or_buy == 'e'
    $game_active = false
  else
    puts "invalid entry"
    attack_or_buy_routine
  end
end

#not included in while loop but called by attack_or_buy_routine
def attack_routine
  if $distance > 0
    bonus_cards = $player_deck.draw_out($distance)
    $player_deck.hf += sum_force(bonus_cards)
    puts "Your draw and discard: #{list(bonus_cards)} for a total of #{sum_force(bonus_cards)} extra force"
    $player_deck.discard.concat(bonus_cards)
    bonus_cards.clear
    $distance = 0
  end
  puts "The Monster takes #{$player_deck.hf} damage."
  $monster_health -= $player_deck.hf
  if $monster_health <= 0
    puts "The monster is dead. The village is safe."
    score = $villager_count*2 - $month/2
    puts "Score: #{score}"
    score_routine(score)
    exit
  end
end

#not included in while loop but called by attack_or_buy_routine
def purchase_routine
  if $store_deck.as_a[1].empty? == true
    puts "Nothing more available"
    return
  end
  puts "What would you like to buy?"
  if get_smallest_cost($store_deck.as_a[1]) > $player_deck.hb
    if $bought == false
      puts "Items too expensive / not enough buy"
    end
    return
  end
  affordable_items = []
  $store_deck.as_a[1].each do |x|
    if x.cost <= $player_deck.hb
      affordable_items << x
    end
  end
  buy_choice = get_choice(affordable_items)
  if buy_choice.cost <= $player_deck.hb
    $player_deck.hb -= buy_choice.cost
    $store_deck.as_a[1].delete_at($store_deck.as_a[1].index(buy_choice))
    $player_deck.discard << buy_choice
    puts "#{buy_choice.name} has been added to your deck. #{$player_deck.hb} buy left."
    $bought = true
    purchase_routine
  end
end

def monster_routine
  this_round_appetite = $monster_appetite
  if $food > 0
    puts "The monster eats #{$food} food."
    if $food <= this_round_appetite
      this_round_appetite -= $food
      $food = 0
    else
      $food -= this_round_appetite
      this_round_appetite = 0
    end
  end

  case $atk_or_buy
  when "a"
    if $light_tof == false
      destroyed = $player_deck.hand.sample
    else
      puts "The light of your torch allows you to manuever. Which will you choose to sacrifice?"
      destroyed = get_choice($player_deck.hand)
    end
    $player_deck.hand.delete_at($player_deck.hand.index(destroyed))
    puts "The monster destroys your #{destroyed.name}. It is removed from the game."
    consumption = this_round_appetite - 1
    $villager_count -= consumption
    puts "Because you attacked, the monster is wary. The monster had an appetite for #{this_round_appetite} villagers, but ate only #{consumption}."
    if $punishment > 0
      $monster_appetite -= $punishment
      puts "The punishing blow of your Sword decreased the monster's appetite by #{$punishment}."
      $punishment = 0
    end
  when "b"
    $villager_count -= this_round_appetite
    puts "Because you didn't attack, the monster gorged. You lost #{this_round_appetite} villagers. The monster's appetite increases by 1."
    $monster_appetite += 1
  end
  puts "Press enter to begin the next round."
  gets
end

def deck_reset_routine
  if $villager_count >= 30
    num = 6
  elsif $villager_count >= 10
    num = 5
  elsif $villager_count >= 5
    num = 3
  end

  num =
  $player_deck.discard_hand
  $player_deck.draw_hand(5)
  $store_deck.discard_hand
  $store_deck.draw_hand(5)
end


#Some commented out code that can useful to run tests without running the game

=begin
test = true
display_routine
puts "\n\n"
while test == true
#puts $draw_pile

deck_reset_routine
display_routine
monster_routine

input = gets.chomp
if input == 'e' then break end
end
=end

def list_card_types
  puts "    BUY-RELATED"
  list_a_info([HUT, FARM, WINDMILL])
  puts "\n    ATTACK-RELATED"
  list_a_info([PITCHFORK, TORCH, BOWANDARROW, SWORD])
  puts "\n    OTHER\n"
  list_a_info([MIDWIFE, DEALER])
  puts "Press enter to begin."
  gets.chomp
  main_game
end

def begin_or_list
  puts "For a list of available cards and their abilities, enter L"
  puts "To begin, enter B"
  input = gets.chomp.downcase
  if input == 'b' || input == 'l'
    return input
  else
    puts "invalid entry."
    return begin_or_list
  end
end


def introduction
  puts "Welcome to The Village:"
  puts "           a simulated deck-building card game."
  puts "\nYou will be playing as a small village."
  puts "The village is plagued by a terrible monster."
  puts "\nEach month / round, you draw 5* cards."
  puts "With these cards, you may choose to attack the monster."
  puts "If you do, the damage you do is equal to the total 'force' of your hand."
  puts "But each time you attack, the monster destroys a random card in your hand."
  puts "\nInstead of attacking you can choose to add to your deck by buying cards."
  puts "A different random selection of 5 cards is available each round."
  puts "Each card has different stats (force, and buy) and different abilities."
  puts "You can't win just by attacking, eventually the monster will destroy all"
  puts "10 of your starting cards."
  puts "\nBut beware. Each time you choose not to attack in order to buy, the"
  puts "the monster gorges and grows hungrier."
  puts "\nYour starting cards are 6 huts (basic buy), 1 pitchfork, 1 torch,"
  puts "1 windmill, and 1 midwife."
  puts "\n *If the village is down to less than 10 villagers, you only draw 4."
  puts "Only 3 cards if less than 5 villagers. More than 30 villagers = 6 cards.)"
  puts "Good Luck."
end


def main_game
  $game_active = true
  while $monster_health >= 0 && $villager_count >= 0 && $game_active == true
    $player_deck.set_stats
    $player_deck.activate_abilities($player_deck.hand)
    $player_deck.set_hand_stats
    display_routine
    attack_or_buy_routine
    break if $game_active == false
    monster_routine
    deck_reset_routine
    $month += 1
  end

  puts "The monster has destroyed the village."
end


def score_routine(score)
  high_scores = YAML.load_file("high_scores.yml")
  if score >= high_scores[-1][0]
    puts "High score! Please enter your name:"
    name = gets.chomp
    high_scores[-1][0] = score
    high_scores[-1][1] = name
  end
  high_scores.sort!{|b, a|a[0] <=> b[0]}
  File.write("high_scores.yml", high_scores.to_yaml)
  print_scores(high_scores)
end

def print_scores(scores)
  puts "       SCORE       PLAYER"
  scores.each_with_index do |score, i|
    print (i+1).to_s
    print " " unless (i+1).to_s.length > 1
    print "  -- "
    print score[0].to_s
    print "." * (12 - score[0].to_s.length)
    print score[1]
    puts ""
  end
end

def run_game
  introduction
  case begin_or_list
  when 'l'
    list_card_types
  when 'b'
    puts "\n\n\n"
    main_game
  end
end


run_game
