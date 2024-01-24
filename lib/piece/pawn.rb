# frozen_string_literal: true

require_relative 'piece'

# Pawn
class Pawn < Piece
  PREFIX = ''

  def get_threat(board, coor)
    list = []
    forward_dir = @color == :white ? 1 : -1

    rel_cell_r = board.get_cell(coor, [1, 1 * forward_dir])
    rel_cell_l = board.get_cell(coor, [-1, 1 * forward_dir])
    rel_cell_f = board.get_cell(coor, [0, 1 * forward_dir])
    rel_cell_ff = board.get_cell(coor, [0, 2 * forward_dir])

    # only threaten diag if enemy present
    list.push(rel_cell_r&.coor) unless rel_cell_r&.empty? || same_color?(rel_cell_r&.piece)
    list.push(rel_cell_l&.coor) unless rel_cell_l&.empty? || same_color?(rel_cell_l&.piece)

    # 'threaten' to move forward if no piece
    # 'threaten' to move forward twice if no piece in either and coor[1] == 1 (white) or coor[1] == 6
    if rel_cell_f.empty?
      list.push(rel_cell_f&.coor)
      if rel_cell_ff.empty? && ((@color == :white && coor[1] == 1) || (@color == :black && coor[1] == 6))
        list.push(rel_cell_ff&.coor)
      end
    end

    list.compact
  end

  def to_s
    @color == :white ? white_pawn : black_pawn
  end
end
