class Card
  attr_reader :family, :tier, :cost, :earnings, :power, :required_plot_size, :attached_plot
  attr_reader :damaged

  def initialize family, tier, cost, power, plot_size
    @family = family
    @tier = tier
    @cost = cost
    # @earnings = (power/2.0*4).round/4.0
    @earnings = power/2.0
    @power = power
    @required_plot_size = plot_size
  end

  def copy
    self.class.new(@family, @tier, @cost, @power, @required_plot_size)
  end

  def to_s
    family = @family.upcase
    "#{family} T#{@tier} #{@power}MW, P#{@attached_plot.family if @attached_plot} #{'** DAMAGED **' if @damaged}"
  end

  def actual_power
    return 0 if @damaged
    if @attached_plot && @attached_plot.family.include?(@family)
      power * 2
    else
      power
    end
  end

  def actual_earnings
    return 0 if @damaged
    if @attached_plot && @attached_plot.family.include?(@family)
      earnings * 2
    else
      earnings
    end
  end

  def attach_plot plot
    @attached_plot = plot
  end

  def mark_damaged
    @damaged = true
  end

  def fix
    @damaged = false
  end
end
