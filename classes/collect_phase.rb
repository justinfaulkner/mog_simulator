class CollectPhase
  def go players, game
    puts "Stating Collect phase!"
    players.each do |player|
      earnings = player.collect_money
      puts "Player #{player.to_s} earned $#{earnings}"
    end
    puts "Done with Collect phase!"
    return false
  end
end