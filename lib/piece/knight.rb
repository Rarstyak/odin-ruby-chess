# frozen_string_literal: true

require_relative 'piece'

# Knight
class Knight < Piece
  PREFIX = 'N'

  def get_threat(board, coor)
    rel_list = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
    threaten_rel(board, coor, rel_list)
  end

  def to_s
    @color == :white ? white_knight : black_knight
  end
end
