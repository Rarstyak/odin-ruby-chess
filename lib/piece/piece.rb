# frozen_string_literal: true

# parent class Piece
class Piece
  include CharacterSet

  PREFIX = ''

  attr_reader :color, :cell

  def self.same_color?(piece)
    @color == piece.color
  end

  def initialize(color, cell)
    @color = color
    @cell = cell
    @moved = false
  end

  def moved?
    @moved
  end

  def move(destination_cell, board)
    return unless legal_moves(board).include?(destination_cell)

    # cell clear
    # destination_cell set piece self
    @moved = true
    PREFIX + destination_cell
  end

  def legal_moves(board)
    # return array of all legal destination cells
    # x = cell.file_i
    # y = cell.rank_i
  end
end
