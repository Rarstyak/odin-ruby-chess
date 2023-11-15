# frozen_string_literal: true

# Notation
module Notation
  def coor_from_notation(notation)
    return unless (notation.is_a? String) && (notation.length == 2)

    file_i = notation[0].ord - 97
    rank_i = notation[1].to_i - 1
    verifty_coor([file_i, rank_i])
  end

  def verifty_coor(coor)
    coor if coor_is_valid?(coor)
  end

  def coor_is_valid?(coor)
    coor[0].between?(0, 7) && coor[1].between?(0, 7)
  end
end
