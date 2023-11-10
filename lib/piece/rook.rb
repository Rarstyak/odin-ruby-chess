# frozen_string_literal: true

require_relative 'piece'

# Rook
class Rook < Piece
  PREFIX = 'R'

  def to_s
    @color == :white ? white_rook : black_rook
  end
end
