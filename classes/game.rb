class Game
  def initialize args
    @players = args[:players]
    @start_money = args[:money] || 200
    @rules = Rules.new self
    @phases = [DamagePhase.new, CollectPhase.new, ActionPhase.new, UpkeepPhase.new]
  end

  def setup_players
    @players.each do |player|
      player.game = self
      player.money = @start_money
      player.tiers = {solar: 1, wind: 1, hydro: 1, geo: 1, nuclear: 1}
      player.cards = []
    end
  end

  def setup_decks
    @plot_deck = PlotDeck.new
  end

  def start
    setup_players
    setup_decks
    no_winner = true
    turn = 0
    while no_winner do
      turn += 1
      puts "\nTurn #{turn}\n"
      no_winner = play_season
    end
    turn
  end

  def play_season
    no_winner = true
    @phases.each do |phase|
      winner = phase.go @players, self
      puts "[ENTER] when ready"
      gets
      if winner
        puts "Player #{winner} has won!"
        no_winner = false
      end
    end
    no_winner
  end

  def take_action player, action, args = {}
    @rules.take_action player, action, args
  end

  def draw_plot
    @plot_deck.draw
  end

  def won? player
    won = player.total_power >= 50
    puts "Won? #{won} - #{player.total_power}"
    return won
  end
end
