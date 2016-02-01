class Plot
  attr_accessor :size, :family

  def initialize size, family
    @size = size
    @family = family
  end

  def can_fit? needed_size
    size_values = {xs: 0, s: 1, m: 2, l: 3, xl: 4}
    needed_value = size_values[needed_size]
    size_values[@size] >= needed_value
  end

  def to_s
    "(#{size} plot, #{family})"
  end
end