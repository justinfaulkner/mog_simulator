class UpkeepPhase
  def go players, game
    puts "== UPKEEP =="
    winner = false
    players.each do |player|
      player.upkeep
      if game.won? player
        winner = player
      end
    end
    return winner
  end
end