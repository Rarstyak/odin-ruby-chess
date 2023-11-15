# frozen_string_literal: true

require_relative 'piece'

# Rook
class Rook < Piece
  PREFIX = 'R'

  def get_threat(board, coor)
    rel_dir = [[0, 1], [1, 0], [0, -1], [-1, 0]]
    threaten_dir(board, coor, rel_dir)
  end

  def to_s
    @color == :white ? white_rook : black_rook
  end
end
