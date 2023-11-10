# frozen_string_literal: true

require_relative 'piece'

# Pawn
class Pawn < Piece
  PREFIX = ''

  def to_s
    @color == :white ? white_pawn : black_pawn
  end
end
