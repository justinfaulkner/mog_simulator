class Player
  attr_accessor :money, :name, :tiers, :cards, :game, :plots, :couldnt_afford_count, :tier_order
  attr_accessor :upsets

  def initialize name, options = {}
    @name = name
    @strat = options[:strat]
    @cards = []
    @plots = []
    @couldnt_afford_count = 0
  end

  def stats
    puts "#{@name} - Power: #{total_power} MW, $#{@money}. Cards: #{@cards.count}. Tiers: "
    @tiers.each_with_index do |value, index|
      print "#{value[0]}: #{value[1]}, "
    end
  end

  def go
    puts "Starting - #{@name}"
    stats
    @strat.take_turn self if @strat
  end

  def take_action action, args = {}
    @game.take_action self, action, args
  end

  def collect_money
    earnings = 0
    @cards.each do |card|
      earnings += card.actual_earnings
    end
    @money += earnings
    earnings
  end

  def buy_card_if_possible(card)
    if can_afford_card card
      buy_card(card)
    else
      puts "cannot afford #{card}"
    end
  end

  def can_afford_card card
    can = @money >= card.cost
    puts "Can afford #{card.to_s}? #{can.inspect} - have $#{@money}, costs $#{card.cost}"
    unless can
      @couldnt_afford_count += 1
    end
    can
  end

  def play_card(card, plot)
    our_card = card.copy
    our_card.attach_plot plot
    @cards << our_card
  end

  def pay_bank cost
    @money -= cost
  end

  def find_best_card family
    CardFinder.find(family, current_tier(family))
  end

  def find_next_best_card family
    lower_tier = current_tier(family) - 1 || 1
    lower_tier = 1 if lower_tier == 0
    CardFinder.find(family, lower_tier)
  end

  def current_tier family
    @tiers[family]
  end

  def total_power
    power = 0
    @cards.each do |card|
      power += card.actual_power
    end
    return power
  end

  def can_upgrade family
    card_count_of_family(family) > 5
  end

  def card_count_of_family family
    tier = current_tier(family)
    matching_cards = @cards.select do |card|
      card.family == family && card.tier == tier
    end
    matching_cards.count
  end

  def upkeep
    Rules::FAMILIES.each do |family|
      upgrade_family family if can_upgrade family
    end
    stats
  end

  def upgrade_family family
    tiers[family] += 1
    puts "#{family} upgraded! now is #{tiers[family]}"
  end

  def buy_card card
    take_action :build, card: card
  end

  def has_compatible_plot card
    plot_size = card.required_plot_size
    has_plot? plot_size
  end

  def has_plot? needed_size
    return true if needed_size == :xs
    @plots.find do |plot|
      plot.can_fit?(needed_size)
    end
  end

  def gain_plot plot
    return unless plot
    @plots << plot
  end

  def plot_stats
    puts @plots.map{|plot|plot.size}.inspect
  end

  def use_plot plot_size
    plot = @plots.delete @plots.find{|plot| plot.size == plot_size}
    puts "used #{plot_size}, now have: "
    plot_stats
    plot
  end

  def card_stats
    puts "[] #{@cards.count}"
    @cards.map do |c|
      plot_family = ''
      if c.attached_plot
        plot_family = c.attached_plot.family
      end
      x = "#{c.family} T#{c.tier} #{c.power}MW, P #{plot_family}"
      puts x
      x
    end
  end

  def upset_locals
    @upsets ||= 0
    @upsets += 1
  end

  def to_s
    "#{name}"
  end
end