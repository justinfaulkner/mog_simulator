class Plot
  attr_accessor :size, :family

  def initialize size, family
    @size = size
    @family = family
  end

  def to_s
    "(#{size} plot, #{family})"
  end
end