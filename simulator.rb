puts "starting simulator..."

require './classes/rules'
require './classes/player'
require './classes/card'
require './classes/plot'
require './classes/game'
require './classes/plot_deck'
require './classes/action_phase'
require './classes/damage_phase'
require './classes/collect_phase'
require './classes/upkeep_phase'

class CardFinder
  @@cards = {
      solar: {
          #                         cost, power
          '1' => Card.new(:solar, 1, 4, 1, :xs),#3
          '2' => Card.new(:solar, 2, 10, 3, :s),#2.7
          '3' => Card.new(:solar, 3, 16, 6, :s),#2.43
          '4' => Card.new(:solar, 4, 20, 10, :s)#2.19
      },
      wind: {
          '1' => Card.new(:wind, 1, 2, 1, :s),#1.5
          '2' => Card.new(:wind, 2, 5, 3, :m),#1.35
          '3' => Card.new(:wind, 3, 8, 6, :l),#1.215
          '4' => Card.new(:wind, 4, 10, 10, :xl)#1.0935
      },
      hydro: {
          '1' => Card.new(:hydro, 1, 3, 1, :m),#2
          '2' => Card.new(:hydro, 2, 10, 4, :l),#1.84
          '3' => Card.new(:hydro, 3, 16, 8, :xl),#1.69
          '4' => Card.new(:hydro, 4, 24, 16, :xl)#1.55
      },
      geo: {
          '1' => Card.new(:geo, 1, 2, 1, :xs),
          '2' => Card.new(:geo, 2, 5, 3, :s),
          '3' => Card.new(:geo, 3, 4, 3, :s),
          '4' => Card.new(:geo, 4, 3, 3, :s)
      },
      nuclear: {
          '1' => Card.new(:nuclear, 1, 8, 8, :l),#2
          '2' => Card.new(:nuclear, 2, 10, 12, :xl),#1.9
          '3' => Card.new(:nuclear, 3, 10, 15, :xl),#1.8
          '4' => Card.new(:nuclear, 4, 12, 24, :xl)#1.71
      }
  }
  class << self
    def find family, card_id
      card_id = 4 if card_id > 4
      x = @@cards[family][card_id.to_s]
      return x
    end
  end
end

sum = 0
min = 100
max = 0
games = 1
afford_blocked = 0
games.times do
  p1 = Player.new 'p1', strat: BestStrat
  p1.tier_order = [:wind, :solar]
  p2 = Player.new 'p2'

  game = Game.new(players: [p1], money: 4)
  turns = game.start
  p1.card_stats
  puts "Couldn't afford: #{p1.couldnt_afford_count}"
  afford_blocked += p1.couldnt_afford_count
  puts "Done. Took #{turns} turns."
  sum += turns
  min = [turns, min].min
  max = [turns, max].max
end

afford_blocked_average = afford_blocked/(games * 1.0)
average = sum/(games * 1.0)

puts "Across #{games} games, on average took #{average} turns. Min: #{min}, Max: #{max}"
puts "Couldn't afford best card an average of #{afford_blocked_average} per game"