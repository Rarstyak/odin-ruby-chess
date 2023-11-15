# frozen_string_literal: true

require_relative 'piece'

# King
class King < Piece
  PREFIX = 'K'

  def get_threat(board, coor)
    rel_list = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
    threaten_rel(board, coor, rel_list)
  end

  def to_s
    @color == :white ? white_king : black_king
  end
end
