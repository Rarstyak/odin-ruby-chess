# frozen_string_literal: true

# parent class Piece
# should serialize into piece type(sub class), color
class Piece
  include CharacterSet

  PREFIX = ''

  attr_reader :color

  def self.same_color?(piece)
    @color == piece.color
  end

  # def self.check_cell_relative(board, starting_cell, rel_x, rel_y)

  # end

  # def self.check_direction(board, starting_cell, rel_x, rel_y)

  # end

  # def self.legal_moves(board, starting_cell)
  #   # return array of all legal destination cells
  #   # x = cell.file_i
  #   # y = cell.rank_i
  # end

  def initialize(color)
    @color = color
  end

  # def move(board, starting_cell, destination_cell)
  #   return unless legal_moves(board, starting_cell).include?(destination_cell)

  #   starting_cell.clear
  #   destination_cell.set(self)
  #   PREFIX + destination_cell
  # end
end
