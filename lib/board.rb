# frozen_string_literal: true

require_relative 'character_set'
require_relative 'notation'
require_relative 'cell'

require_relative './piece/bishop'
require_relative './piece/king'
require_relative './piece/knight'
require_relative './piece/pawn'
require_relative './piece/queen'
require_relative './piece/rook'

# Game Board
class Board
  include CharacterSet
  include Notation

  NUM_FILE = 8
  NUM_RANK = 8
  PIECE_TYPES = %w[Rook Knight Bishop Queen King Pawn].freeze
  DEFAULT_PIECES = [
    [[0,7], 'Rook', :black],
    [[1,7], 'Knight', :black],
    [[2,7], 'Bishop', :black],
    [[3,7], 'Queen', :black],
    [[4,7], 'King', :black],
    [[5,7], 'Bishop', :black],
    [[6,7], 'Knight', :black],
    [[7,7], 'Rook', :black],

    [[0,6], 'Pawn', :black],
    [[1,6], 'Pawn', :black],
    [[2,6], 'Pawn', :black],
    [[3,6], 'Pawn', :black],
    [[4,6], 'Pawn', :black],
    [[5,6], 'Pawn', :black],
    [[6,6], 'Pawn', :black],
    [[7,6], 'Pawn', :black],

    [[0,1], 'Pawn', :white],
    [[1,1], 'Pawn', :white],
    [[2,1], 'Pawn', :white],
    [[3,1], 'Pawn', :white],
    [[4,1], 'Pawn', :white],
    [[5,1], 'Pawn', :white],
    [[6,1], 'Pawn', :white],
    [[7,1], 'Pawn', :white],

    [[0,0], 'Rook', :white],
    [[1,0], 'Knight', :white],
    [[2,0], 'Bishop', :white],
    [[3,0], 'Queen', :white],
    [[4,0], 'King', :white],
    [[5,0], 'Bishop', :white],
    [[6,0], 'Knight', :white],
    [[7,0], 'Rook', :white],
  ].freeze

  # Castling requires the king and that rook haven't moved, that they are both there, and there are no inbetween
  # These 6 booleans + cell checks are all needed since if they are killed, they can't be there
  def initialize(pieces_array = DEFAULT_PIECES, history = [])
    @grid = Array.new(NUM_FILE) { |file_i| Array.new(NUM_RANK) { |rank_i| Cell.new(file_i, rank_i) } }
    @history = history
    load_pieces(pieces_array)
  end

  def current_turn
    @history.length
  end

  def who_turn(turn=current_turn)
    turn.even? ? :white : :black
  end

  def notation_place(notation, piece)
    coor_place(coor_from_notation(notation), piece)
  end

  def notation_move(start_notation, end_notation)
    coor_move(coor_from_notation(start_notation), coor_from_notation(end_notation))
  end

  # moves are hashes with
    # name
    # forward
    # backward

  def move_valid?(move)
    move[:forward].call
    move_into_check = check?(who_turn)
    move[:backward].call
    !move_into_check
  end

  def list_legal_moves
    list = []

    # get moves from threat (needs to be verified against moving into check)
    # get moves from castling
    # get moves from en passant (needs to be verified against moving into check)
    list.concat(get_color_threat_moves, get_color_castle_moves, get_e_p_moves)

    # verify against moving into check
    list.select{ |move| move_valid?(move) }
  end

  def list_legal_move_names
    list_legal_moves.map { |move| move[:name] }
  end

  def play_move(move_name)
    case list_legal_moves
    in [*, { name: ^move_name } => move, *]
      move[:forward].call
      @history.push(move)
    else
      nil
    end
  end

  def undo_move(turn=current_turn)
    while current_turn >= turn
      @history.pop[:backward].call
    end
  end

  # can_castle?
  def can_castle?(color, side)
    if color == :white && side == 'queenside'
      k_coor = [4,0]
      r_coor = [0,0]

      empty_list = [[1,0], [2,0], [3,0]]
      check_list = [[2,0], [3,0], [4,0]]
    elsif color == :white && side == 'kingside'
      k_coor = [4,0]
      r_coor = [7,0]

      empty_list = [[5,0], [6,0]]
      check_list = [[4,0], [5,0], [6,0]]
    elsif color == :black && side == 'queenside'
      k_coor = [4,7]
      r_coor = [0,7]

      empty_list = [[1,7], [2,7], [3,7]]
      check_list = [[2,7], [3,7], [4,7]]
    elsif color == :black && side == 'kingside'
      k_coor = [4,7]
      r_coor = [7,7]

      empty_list = [[5,7], [6,7]]
      check_list = [[4,7], [5,7], [6,7]]
    else
      puts 'can_castle? input error'
      return
    end

    k_piece = get_piece(k_coor)
    r_piece = get_piece(r_coor)

    history_check = get_history

    # king has not moved
    # rook has not moved
    return false unless k_piece.class.name == "King" && k_piece.color == color && !history_check.include?(notation_from_coor(k_coor))
    return false unless r_piece.class.name == "Rook" && r_piece.color == color && !history_check.include?(notation_from_coor(r_coor))

    # There are no pieces between the king and the rook.
    return false unless empty_list.all? { |coor| get_cell(coor).empty? }

    # The king is not currently in check.
    # The king does not pass through or finish on a square that is attacked by an enemy piece.
    enemy_threat = get_color_threat(other_color(color))
    return false unless check_list.none? { |coor| enemy_threat.include?(coor) }

    return true
  end

  # returns file(x coor in letter) via match or nil
  def last_move_double_pawn(turn=current_turn)
    return nil if turn == 0
    last_turn = @history[turn - 1][:name]
    last_turn[/^([a-h])2-(\1)4$/, 1] || last_turn[/^([a-h])7-(\1)5$/, 1]
  end
  # FOR ALL either castling OR (.?)([a-g])([1-8])(-|x)(.?)([a-g])([1-8])( e.p.)?

  # returns possible, but not check verified en passant
  def get_e_p_moves(turn=current_turn)
    file = last_move_double_pawn(turn)
    list = []

    return list if file.nil?

    last_turn = who_turn(turn - 1)
    this_turn = who_turn(turn)

    if last_turn == :white
      p_coor = coor_from_notation(file + '4')
      b_coor = [p_coor[0], p_coor[1] - 1]
    end

    if last_turn == :black
      p_coor = coor_from_notation(file + '5')
      b_coor = [p_coor[0], p_coor[1] + 1]
    end

    l_coor = [p_coor[0] - 1, p_coor[1]]
    r_coor = [p_coor[0] + 1, p_coor[1]]

    p_piece = get_piece(p_coor)
    l_piece = get_piece(l_coor)
    r_piece = get_piece(r_coor)

    return list unless p_piece.class.name == "Pawn" && p_piece.color == last_turn && get_cell(b_coor).empty?

    if l_piece.class.name == "Pawn" && l_piece.color == this_turn
      name = "#{notation_from_coor(l_coor)}x#{notation_from_coor(b_coor)} e.p."
      list.push({
        name: name,
        forward: lambda { coor_move(l_coor, b_coor); coor_clear(p_coor) },
        backward: lambda { coor_move(b_coor, l_coor); coor_place_new(p_coor, "Pawn", last_turn) }
      })
    end

    if r_piece.class.name == "Pawn" && r_piece.color == this_turn
      name = "#{notation_from_coor(r_coor)}x#{notation_from_coor(b_coor)} e.p."
      list.push({
        name: name,
        forward: lambda { coor_move(r_coor, b_coor); coor_clear(p_coor) },
        backward: lambda { coor_move(b_coor, r_coor); coor_place_new(p_coor, "Pawn", last_turn) }
      })
    end

    list
  end

  # is the color, whose turn it is, in check?
  def check?(color=who_turn)
    get_color_threat(other_color(color)).include?(king?(color))
  end

  def stale_mate?
    list_legal_moves.length == 0 && !check?
  end

  def check_mate?
    list_legal_moves.length == 0 && check?
  end

  # returns coordinate of king if on board
  def king?(color=who_turn)
    case list_pieces
    in [*, [_ => k_coor, 'King', ^color], *]
      k_coor
    else
      nil
    end
  end

  # Checks standard movement threat, ignores enpassant and castling which can not be used to kill a king
  def get_color_threat(color=who_turn)
    list = []
    @grid.flatten.each do |cell|
      list.concat(cell.piece.get_threat(self, cell.coor)) if cell.piece.color == color unless cell.empty?
    end
    list
  end

  # Checks standard movement threat, ignores enpassant and castling which can not be used to kill a king
  def get_color_threat_moves(color=who_turn)
    list = []
    @grid.flatten.each do |cell|
      unless cell.empty?
        if cell.piece.color == color
          cell.piece.get_threat(self, cell.coor).each do |threat|
            threat_cell = get_cell(threat)
            kill = get_piece(threat)

            if (cell.piece.class.name == "Pawn" && (get_cell(threat).rank == '1' or get_cell(threat).rank == '8'))
              # INSERT PROMOTION HERE AS [].each of MOVEs? -> if cell.piece.class.name == "Pawn" && get_cell(threat).rank == '1' or get_cell(threat).rank == '8'
              [["Bishop", "B"], ["Knight", "N"], ["Queen", "Q"], ["Rook", "R"]].each do |type|
                name = cell.piece.class::PREFIX + cell.notation
                name += threat_cell.empty? ? '-' : "x#{threat_cell.piece.class::PREFIX}"
                name += threat_cell.notation
                name += '=' + type[1]
                list.push({
                  name: name,
                  forward: lambda { coor_clear(cell.coor); coor_place_new(threat, type[0], color) },
                  backward: lambda { coor_place_new(cell.coor, "Pawn", color); coor_place_new(threat, kill.class.name, other_color(color)) }
                })
              end
            else
              name = cell.piece.class::PREFIX + cell.notation
              name += threat_cell.empty? ? '-' : "x#{threat_cell.piece.class::PREFIX}"
              name += threat_cell.notation
              list.push({
                name: name,
                forward: lambda { coor_move(cell.coor, threat) },
                backward: lambda { coor_move(threat, cell.coor); coor_place_new(threat, kill.class.name, other_color(color)) }
              })
            end
          end
        end
      end
    end
    list
  end

  # Checks only castling
  def get_color_castle_moves(color=who_turn)
    list = []

    if color == :white
      if can_castle?(:white, 'queenside')
        list.push({
          name: 'O-O-O',
          forward: lambda { coor_move([4,0], [2,0]); coor_move([0,0], [3,0]) },
          backward: lambda { coor_move([2,0], [4,0]); coor_move([3,0], [0,0]) }
        })
      end

      if can_castle?(:white, 'kingside')
        list.push({
          name: 'O-O',
          forward: lambda { coor_move([4,0], [6,0]); coor_move([7,0], [5,0]) },
          backward: lambda { coor_move([6,0], [4,0]); coor_move([5,0], [7,0]) }
        })
      end
    end

    if color == :black
      if can_castle?(:black, 'queenside')
        list.push({
          name: 'O-O-O',
          forward: lambda { coor_move([4,7], [2,7]); coor_move([0,7], [3,7]) },
          backward: lambda { coor_move([2,7], [4,7]); coor_move([3,7], [0,7]) }
        })
      end

      if can_castle?(:black, 'kingside')
        list.push({
          name: 'O-O',
          forward: lambda { coor_move([4,7], [6,7]); coor_move([7,7], [5,7]) },
          backward: lambda { coor_move([6,7], [4,7]); coor_move([5,7], [7,7]) }
        })
      end
    end

    list
  end

  def coor_move(start_coor, end_coor)
    piece = get_piece(start_coor)
    coor_place(end_coor, piece)
    coor_clear(start_coor)
  end

  def coor_place_new(coor, p_class, p_color)
    piece = eval(p_class).new(p_color) if PIECE_TYPES.include?(p_class)
    get_cell(coor)&.set(piece)
  end

  def coor_place(coor, piece)
    get_cell(coor)&.set(piece)
  end

  def coor_clear(coor)
    get_cell(coor)&.clear
  end

  def get_piece(coor, rel = [0, 0])
    get_cell(coor, rel)&.piece
  end

  def get_cell(coor, rel = [0, 0])
    return unless coor_is_valid?([coor[0] + rel[0], coor[1] + rel[1]])

    @grid[coor[0] + rel[0]][coor[1] + rel[1]]
  end

  # IO

  def list_pieces(coor = true)
    list = []
    @grid.flatten.each do |cell|
      list.push([coor ? cell.coor : cell.notation, cell.piece.class.name, cell.piece.color]) unless cell.empty?
    end
    list
  end

  def load_pieces(pieces_array)
    pieces_array.each do |entry|
      coor_place_new(entry[0], entry[1], entry[2].to_sym)
    end
  end

  # Display

  def display_game
    display_history
    puts ''
    print_board(true, true)
    puts ''
    display_turn
    display_status
    puts ''
  end

  def display_turn
    puts "Turn #{(current_turn / 2).floor + 1} for #{who_turn}"
  end

  def display_status
    if check_mate?
      puts "Checkmate, #{other_color(who_turn)} wins!"
    elsif stale_mate?
      puts "Stalemate, #{who_turn} has no legal moves!"
    elsif check?
      puts "#{who_turn} is in check!"
    end
  end

  def get_history(stop=current_turn)
    string = "History\n"
    @history.each_with_index do |move, turn|
      break if turn >= stop
      string += "#{(turn / 2).floor + 1}. #{move[:name]}" if turn.even?
      string += " #{move[:name]}\n" if turn.odd?
    end
    string
  end

  def display_history(stop=current_turn)
    puts get_history(stop)
  end

  def display_cell(file_i, rank_i, bg_color_even = "\e[0m", bg_color_odd = "\e[0m")
    print (rank_i + file_i).even? ? bg_color_even : bg_color_odd
    print @grid[file_i][rank_i]
    print "\e[0m"
  end

  def print_board(with_bg_colors = false, with_labels = false)
    puts ' abcdefgh' if with_labels
    (0...NUM_RANK).to_a.reverse.each do |rank_i|
      print(rank_i + 1) if with_labels
      (0...NUM_FILE).each do |file_i|
        if with_bg_colors
          display_cell(file_i, rank_i, "\e[45m", "\e[42m")
        else
          display_cell(file_i, rank_i)
        end
      end
      print(rank_i + 1) if with_labels
      puts ''
    end
    puts ' abcdefgh' if with_labels
  end
end
