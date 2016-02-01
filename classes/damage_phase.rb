class DamagePhase
  def go players, game
    players.each do |player|
      check_damage player
    end
    puts "Done with Damage phase!"
    return false
  end

  def check_damage player
    [:wind, :nuclear].each do |family|
      matching_cards = player.cards.select{|card|card.family == family}
      puts "For #{family}: #{matching_cards.count} cards to roll for damage..."
      randomly_damage matching_cards, player
    end
  end

  def randomly_damage cards, player
    groups_of_six_cards = divide_into_sixes cards
    groups_of_six_cards.each do |group|
      random_index = (0..5).to_a.sample
      selected_card = group[random_index]
      puts "Rolling for damage - #{group.first.family}: #{random_index}"
      damage_card(selected_card, player) if selected_card
    end
  end

  def damage_card card, player
    puts "Damaging card: #{card.to_s}"
    card.mark_damaged
    player.upset_locals if card.family == :nuclear
  end

  def divide_into_sixes cards
    groups = []
    while cards.length > 0 do
      groups << cards.shift(6)
      puts groups.inspect
    end
    groups
  end
end