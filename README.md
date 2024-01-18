# odin-ruby-chess
https://www.theodinproject.com/lessons/ruby-ruby-final-project


## Assignment
Build a command line Chess game where two players can play against each other.

- [ ] [ ] The game should be properly constrained – it should prevent players from making illegal moves and declare check or check mate in the correct situations.

- [ ] Make it so you can save the board at any time (remember how to serialize?)

- [ ] Write tests for the important parts. You don’t need to TDD it (unless you want to), but be sure to use RSpec tests for anything that you find yourself typing into the command line repeatedly.

Do your best to keep your classes modular and clean and your methods doing only one thing each. This is the largest program that you’ve written, so you’ll definitely start to see the benefits of good organization (and testing) when you start running into bugs.

Unfamiliar with Chess? Check out some of the additional resources to help you get your bearings.

Have fun! Check out the unicode characters for a little spice for your gameboard.

(Optional extension) Build a very simple AI computer player (perhaps who does a random legal move)

## Rules Scratchpaper

Columns, called files are labeled a-h from White's left to right
Rows, called ranks, are numbered 1-8 from white to bplack
The pieces uppercase letter + destination coor
pawns don't have a letter
captures insert an "x" before coor; if a pawn captures, the pawn's departure file prefixes
en passant can all add " e.p." to end
distinguish pieces by file/rank/file&rank if needed

black
a8 ... h8
...
a1 ... h1
white

white start

board should have is_check?(:white/:black)
board can also have is_checkmate?(:white/:black) by seeing if all legal king moves have is_check? -> pass a new_board with the placements

use Reversible algebraic notation

should board or game contain move history?
should board actually contain the pieces in cells? or should pieces have cell coor?
should I place "threat" as per chess evolved (for casting and maybe help with check/stalemate/checkmate verify)

board print self and list pieces
game contains board and side_white + side_black -> contain players

special rules:
en passant
castling
promotion
50-move draw

legal moves try
knight
rook -> bishop -> queen
pawn forward
pawn kill normal
king

special moves
pawn kill en passant !!! en passant is ONLY a pawn v pawn(2-square move) that must be taken the turn after
castling

O-O Kingside
O-O-O Queenside


Castling is permitted provided all of the following conditions are met:
Neither the king nor the rook has previously moved.
There are no pieces between the king and the rook.
The king is not currently in check.
The king does not pass through or finish on a square that is attacked by an enemy piece.

## State check logic

if it is white's turn then
    see if any of black target king -> white is in check
    go through all possible white moves(discarding any that result in check) -> black move results in no white king found on hypothtical board == return boards that still have a white king
    go through all possible special moves(castling and en passant)
    if there are no valid moves left, then white is in checkmate and the game is over -> (announce if checkmate, or just check, otherwise prompt next move)
