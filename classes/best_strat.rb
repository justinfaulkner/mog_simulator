class BestStrat

  def self.take_turn player
    action = decide
    case action
      when :plot_shop
        player.take_action :plot_shop
      when :draw_card
        player.take_action :draw_card
      when :build
        buy_card
    end
  end

  def self.decide
    return :repair if player.broken_percent > 0.16
    return :draw_card if player.hand.blank?
    return :plot_shop if player.plots.blank?
    
  end

  def self.buy_card
    tier_order = player.tier_order
    bought_card = false
    tier_order.each do |family|
      best_card = player.find_best_card(family)
      puts "Family: #{family.inspect}"
      puts "Best card: #{best_card}"
      if player.has_compatible_plot(best_card)
        bought_card = try_to_build best_card, player
        break if bought_card
      else
        puts "Can't build best card, no compatible plot..."
      end
    end
    unless bought_card
      tier_order.each do |family|
        second_best_card = player.find_next_best_card(family)
        next if player.find_best_card(family) == second_best_card
        puts "Second Best card: #{second_best_card}"
        if player.has_compatible_plot(second_best_card)
          bought_card = try_to_build second_best_card, player
          break if bought_card
        else
          puts "Can't build second best card, no compatible plot..."
        end
      end
    end
  end

  def self.try_to_build card, player
    bought_card = false
    puts "Have a compatible plot!"
    puts player.plot_stats
    if player.can_afford_card card
      player.take_action :build, card: card
      bought_card = true
    else
      puts "... but can't afford card..."
    end
    bought_card
  end
end