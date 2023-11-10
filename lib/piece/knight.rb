# frozen_string_literal: true

require_relative 'piece'

# Knight
class Knight < Piece
  PREFIX = 'N'

  def to_s
    @color == :white ? white_knight : black_knight
  end
end
