class UpkeepPhase
  def go players, game
    puts "Starting Upkeep!"
    winner = false
    players.each do |player|
      player.upkeep
      if game.won? player
        winner = player
      end
    end
    puts "Done with upkeep!"
    return winner
  end
end