class Cell
  attr_reader :x, :y, :notation

  def initialize(x, y)
    @x = x
    @y = y
    @notation = "(#{('a'..'h').to_a[x]}#{y + 1})"
  end

  def to_s
    notation
  end
end
