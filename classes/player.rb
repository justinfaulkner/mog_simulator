class Player
  attr_accessor :money, :name, :tiers, :cards, :game, :plots, :couldnt_afford_count, :tier_order
  attr_accessor :upsets, :hand

  def initialize name, options = {}
    @name = name
    @strat = options[:strat]
    @cards = []
    @plots = []
    @couldnt_afford_count = 0
  end

  def stats
    print "#{@name} - Power: #{total_power} MW, $#{@money}. Cards: #{@cards.count}. Tiers: "
    @tiers.each_with_index do |value, index|
      print "#{value[0]}: #{value[1]}, "
    end
    puts
  end

  def go
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
    our_card
  end

  def pay_bank cost
    @money -= cost
  end

  def find_best_card family
    CardFinder.find(family, current_tier(family))
  end

  def find_card family, tier, version = 0
    CardFinder.find(family, tier, version)
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
    card_stats
    plot_stats
  end

  def research family
    upgrade_family family
  end

  def upgrade_family family
    puts "upgrading family #{family}"
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

  def gain_card card
    return unless card
    @cards << card
  end

  def gain_plot plot
    return unless plot
    @plots << plot
  end

  def plot_stats
    puts @plots.map{|plot|[plot.size, plot.family]}.inspect
  end

  def find_perfect_plot size, family
    @plots.find{|plot| plot.size == size && plot.family.include?(family)}
  end

  def find_awesome_plot size, family
    @plots.find{|plot| plot.can_fit?(size) && plot.family.include?(family)}
  end

  def use_plot plot_size, family
    if plot_size == :xs
      awesome_plot = find_perfect_plot :xs, :solar
      awesome_plot = find_awesome_plot :xs, :solar if awesome_plot.nil?
      if awesome_plot
        puts "BUILD: xs, but had a matching solar plot, so using that instead of free one!"
        @plots.delete awesome_plot
        return awesome_plot
      end
      puts "BUILD: using a free xs plot!"
      return Plot.new(:xs, [:none])
    end
    matching_plot = find_perfect_plot plot_size, family
    matching_plot = find_awesome_plot plot_size, family if matching_plot.nil?
    matching_plot = @plots.find{|plot| plot.size == plot_size } if matching_plot.nil?
    matching_plot = @plots.find{|plot| plot.can_fit?(plot_size)} if matching_plot.nil?
    plot = @plots.delete  matching_plot
    print "used #{matching_plot.size}, #{matching_plot.family}, now have: "
    plot_stats
    plot
  end

  def card_stats
    puts "Built cards:  #{@cards.count}"
    puts @cards.map{|c|c.to_s}
  end

  def upset_locals
    @upsets ||= 0
    @upsets += 1
  end

  def broken_percent
    return 0.0 if @cards.count == 0
    damaged_count = @cards.select{|card|card.damaged}.count
    percent = (damaged_count + 0.0)/@cards.count
    puts "Damage percent is: #{percent}"
    percent
  end

  def to_s
    "#{name}"
  end
end