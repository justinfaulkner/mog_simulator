class ActionPhase
  def go players, game
    puts "Starting action phase!"
    players.each do |player|
      player.go
    end
    puts "done with action phase!"
    return false
  end
end