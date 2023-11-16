# frozen_string_literal: true

require_relative 'piece'

# Pawn
class Pawn < Piece
  PREFIX = ''

  def get_threat(board, coor)
    list = []
    if @color == :white
      # only threaten rel [[1, 1], [-1, 1]] if enemy present
      rel_cell_r = board.get_cell(coor, [1, 1])
      list.push(rel_cell_r&.coor) unless rel_cell_r&.piece.nil? or same_color?(rel_cell_r&.piece)
      rel_cell_l = board.get_cell(coor, [-1, 1])
      list.push(rel_cell_l&.coor) unless rel_cell_l&.piece.nil? or same_color?(rel_cell_l&.piece)
      # 'threaten' to move forward if no piece
      rel_cell_f = board.get_cell(coor, [0, 1])
      list.push(rel_cell_f&.coor) if rel_cell_f&.piece.nil?
      # 'threaten' to move forward twice if no piece in either and coor[1] == 1
      rel_cell_ff = board.get_cell(coor, [0, 2])
      list.push(rel_cell_ff&.coor) if rel_cell_f&.piece.nil? and rel_cell_ff&.piece.nil? and coor[1] == 1
      # ??? kill en passant
    end
    if @color == :black
      # only threaten rel [[1, -1], [-1, -1]] if enemy present
      rel_cell_r = board.get_cell(coor, [1, -1])
      list.push(rel_cell_r&.coor) unless rel_cell_r&.piece.nil? or same_color?(rel_cell_r&.piece)
      rel_cell_l = board.get_cell(coor, [-1, -1])
      list.push(rel_cell_l&.coor) unless rel_cell_l&.piece.nil? or same_color?(rel_cell_l&.piece)
      # 'threaten' to move forward if no piece
      rel_cell_f = board.get_cell(coor, [0, -1])
      list.push(rel_cell_f&.coor) if rel_cell_f&.piece.nil?
      # 'threaten' to move forward twice if no piece in either and coor[1] == 6
      rel_cell_ff = board.get_cell(coor, [0, -2])
      list.push(rel_cell_ff&.coor) if rel_cell_f&.piece.nil? and rel_cell_ff&.piece.nil? and coor[1] == 6
      # ??? kill en passant
    end
    list.compact
  end

  def to_s
    @color == :white ? white_pawn : black_pawn
  end
end
