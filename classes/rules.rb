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
      else
        puts "Error: Unrecognized action: #{action}"
    end
  end

  private

  def build player, args = {}
    card = args[:card]
    player.pay_bank card.cost
    plot = player.use_plot card.required_plot_size
    player.play_card card.copy, plot
    puts "Bought #{card}!"
  end

  def draw_card player, args = {}

  end

  def plot_shop player, args = {}
    # size = args[:size]
    # family = args[:family]
    drawn_plot = @game.draw_plot
    if drawn_plot
      player.gain_plot drawn_plot
      puts "Gained plot #{drawn_plot}"
    end
  end
end