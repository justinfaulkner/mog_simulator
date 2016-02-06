require './classes/player'

class BestStrat

  def self.take_turn player
    action, args = decide player
    case action
    when :plot_shop
      player.take_action :plot_shop
    when :draw_card
      player.take_action :draw_card
    when :build
      buy_card player
    when :repair
      player.take_action :repair
    when :research
      player.research args[0]
    else
      raise "PROBLEM - unrecognized action: #{action}"
    end
  end

  def self.decide player
    puts ""
    if player.broken_percent > 0.16
      puts "DECIDE: More than 16% broken... so repairing!"
      return [:repair]
    else
      if player.broken_percent > 0
        puts "DECIDE: player broken percent is: #{player.broken_percent}, not 0.16, so ignoring for now..."
      end
    end
    family_to_research = should_research player
    puts "Decided to research: #{family_to_research}"
    if family_to_research
      return [:research, [family_to_research]]
    end
    # return :draw_card if player.hand.nil? || player.hand.empty?
    if player.tier_order[0] != :solar && (player.plots.nil? || player.plots.empty?)
      puts "DECIDE: no plots, so plot shopping!"
      return [:plot_shop]
    end
    if !can_afford_anything(player)
      puts "DECIDE: can't afford any good cards.. plot shopping!"
      return [:plot_shop]
    end
    if no_awesome_plot(player) && flip_coin
      puts "DECIDE: don't have an awesome plot, flipped coin, going for it... PLOT SHOP!"
      return [:plot_shop]
    end
    puts "DECIDE: NOTHING ELSE TO DO... SO.... BUYING!"
    return [:build]
  end

  def self.no_awesome_plot player
    player.tier_order.each do |family|
      best_card = player.find_best_card(family)
      return false if player.find_awesome_plot best_card.required_plot_size, best_card.family
    end
    return true
  end

  def self.flip_coin
    [true, false].shuffle.shuffle.first
  end

  def self.can_afford_anything player
    tier_order = player.tier_order
    [4, 3, 2, 1].each do |tier|
      tier_order.each do |family|
        next if player.current_tier(family) < tier
        best_card = player.find_card(family, tier)
        if player.can_afford_card(best_card) && player.has_compatible_plot(best_card)
          return true
        end
      end
    end
    return false
  end

  def self.buy_card player
    tier_order = player.tier_order
    [4, 3, 2, 1].each do |tier|
      tier_order.each do |family|
        next if player.current_tier(family) < tier
        puts "BUY: Family: #{family.inspect}, Tier: #{tier}"
        best_card = player.find_card(family, tier)
        bought_card = build_card_if_plottable player, best_card
        return true if bought_card
      end
    end
    return false
  end

  def self.build_card_if_plottable player, card
    puts "BUY: card: #{card.to_s}"
    if player.has_compatible_plot(card)
      bought_card = try_to_build card, player
      return true if bought_card
    else
      puts "BUY: Can't build card, no compatible plot... requires, #{card.required_plot_size}"
      player.plot_stats
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

  def self.should_research player
    player.tier_order.each do |family|
      count = player.card_count_of_family(family)
      research_chance = 0.1
      research_chance = 0.25 if count == 2
      research_chance = 0.5 if count == 3
      research_chance = 0.75 if count > 3
      roll = rand
      puts "Should research #{family}? roll: #{roll}, needs to be < #{research_chance}"
      if roll < research_chance
        return family
      end
    end
    return false
  end
end
