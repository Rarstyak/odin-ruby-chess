# frozen_string_literal: true

require_relative 'piece'

# Bishop
class Bishop < Piece
  PREFIX = 'B'

  def get_threat(board, coor)
    rel_dir = [[1, 1], [1, -1], [-1, -1], [-1, 1]]
    threaten_dir(board, coor, rel_dir)
  end

  def to_s
    @color == :white ? white_bishop : black_bishop
  end
end
