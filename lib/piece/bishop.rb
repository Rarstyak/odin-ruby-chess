# frozen_string_literal: true

require_relative 'piece'

# Bishop
class Bishop < Piece
  PREFIX = 'B'

  def to_s
    @color == :white ? white_bishop : black_bishop
  end
end
