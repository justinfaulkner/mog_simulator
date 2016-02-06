class ActionPhase
  def go players, game
    puts "== ACTION =="
    players.each do |player|
      player.go
    end
    return false
  end
end