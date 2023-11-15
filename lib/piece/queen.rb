# frozen_string_literal: true

require_relative 'piece'

# Queen
class Queen < Piece
  PREFIX = 'Q'

  def get_threat(board, coor)
    rel_dir = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
    threaten_dir(board, coor, rel_dir)
  end

  def to_s
    @color == :white ? white_queen : black_queen
  end
end
