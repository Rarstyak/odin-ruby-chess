# frozen_string_literal: true

require_relative 'piece'

# Queen
class Queen < Piece
  PREFIX = 'Q'

  def to_s
    @color == :white ? white_queen : black_queen
  end
end
