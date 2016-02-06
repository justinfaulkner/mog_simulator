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
require './classes/best_strat'
require './classes/card_deck'


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