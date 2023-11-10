# frozen_string_literal: true

require_relative 'piece'

# King
class King < Piece
  PREFIX = 'K'

  def to_s
    @color == :white ? white_king : black_king
  end
end
