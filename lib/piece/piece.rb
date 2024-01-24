# frozen_string_literal: true

# parent class Piece
# should serialize into piece type(sub class), color
class Piece
  include CharacterSet

  PREFIX = ''

  attr_reader :color

  def same_color?(piece)
    @color == piece&.color
  end

  def threaten_rel(board, coor, relative_array)
    list = []
    relative_array.each do |rel|
      rel_cell = board.get_cell(coor, rel)
      list.push(rel_cell&.coor) unless same_color?(rel_cell&.piece)
    end
    list.compact
  end

  def threaten_dir(board, coor, direction_array)
    list = []
    direction_array.each do |dir|
      rel_cell = board.get_cell(coor)
      loop do
        rel_cell = board.get_cell(rel_cell&.coor, dir)
        list.push(rel_cell&.coor) unless same_color?(rel_cell&.piece)
        break if rel_cell.nil? || rel_cell.piece
      end
    end
    list.compact
  end

  def initialize(color)
    @color = color
  end
end
