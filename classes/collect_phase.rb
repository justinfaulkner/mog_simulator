class CollectPhase
  def go players, game
    puts "== COLLECT =="
    players.each do |player|
      earnings = player.collect_money
      puts "#{player.to_s} earned $#{earnings}... now: $#{player.money}"
    end
    return false
  end
end