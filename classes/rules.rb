class Rules
  FAMILIES = [:solar, :wind, :hydro, :geo, :nuclear]
  TIERS = [1, 2, 3, 4]
  PLOT_SIZES = [:xs, :s, :m, :l, :xl]

  def initialize game
    @game = game
  end

  def take_action player, action, args = {}
    puts "*** #{player} is using #{action}... #{args.inspect}"
    case action
      when :build
        build player, args
      when :draw_card
        draw_card player, args
      when :plot_shop
        plot_shop player, args
      when :repair
        repair player, args
      else
        puts "Error: Unrecognized action: #{action}"
    end
  end

  private

  def build player, args = {}
    card = args[:card]
    player.pay_bank card.cost
    plot = player.use_plot(card.required_plot_size, card.family)
    card_copy = player.play_card card, plot
    puts "Bought #{card_copy}!"
  end

  def draw_card player, args = {}
    drawn_card = @game.draw_card
    if drawn_card
      player.gain_card draw_card
      puts "Drew card: #{drawn_card}"
    end
  end

  def plot_shop player, args = {}
    # size = args[:size]
    # family = args[:family]
    drawn_plot = @game.draw_plot
    if drawn_plot
      player.gain_plot drawn_plot
      puts "Gained plot #{drawn_plot}"
      player.plot_stats
    end
  end

  def repair player, args = {}
    count = 0
    player.cards.select{|c|c.damaged}.each do |card|
      card.fix
      puts "REPAIR: repaired #{card.to_s}"
      count += 1
    end
    puts "REPAIR: total: repaired #{count} cards."
  end
end