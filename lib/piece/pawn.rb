# frozen_string_literal: true

require_relative 'piece'

# Pawn
class Pawn < Piece
  PREFIX = ''

  # def get_threat(board, coor)
  #   list = []
  #   if @color == :white
  #     # only threaten rel [[1, 1], [-1, 1]] if enemy present
  #     # 'threaten' to move forward if no piece
  #     # 'threaten' to move forward twice if no piece in either
  #     # ??? kill en passant
  #   end
  #   if @color == :black
  #     # only threaten rel [[1, -1], [-1, -1]] if enemy present
  #     # 'threaten' to move forward if no piece
  #     # 'threaten' to move forward twice if no piece in either
  #     # ??? kill en passant
  #   end
  #   list.compact
  # end

  def to_s
    @color == :white ? white_pawn : black_pawn
  end
end
