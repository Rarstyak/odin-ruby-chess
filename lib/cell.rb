# frozen_string_literal: true

# Cell
class Cell
  attr_reader :file_i, :rank_i, :file, :rank, :notation

  def initialize(file_i, rank_i)
    @file_i = file_i
    @rank_i = rank_i
    @file = ('a'..'h').to_a[file_i]
    @rank = rank_i + 1
    @notation = "(#{file}#{rank})"
  end

  def to_s
    notation
  end
end
