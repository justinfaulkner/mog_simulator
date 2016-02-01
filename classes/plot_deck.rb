class PlotDeck
  def initialize
    @plots = populate
    @plots.shuffle!
    @plots.shuffle!
  end

  def stats
    puts "Size: #{@plots.length}"
    @plots.each do |plot|
      puts plot
    end
  end

  def draw
    @plots.shift
  end

  def weighted_families
    [[:geo, :solar], [:geo, :solar], [:geo, :solar], [:geo, :solar], [:none], [:wind], [:hydro]]
  end

  protected

  def populate
    plots = []
    {s: 50, m: 30, l: 20, xl: 10}.each do |pair|
      pair[1].times do
        family = weighted_families.shuffle.first
        plots << Plot.new(pair[0], family)
      end
    end
    plots
  end
end