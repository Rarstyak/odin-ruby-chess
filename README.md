# odin-ruby-chess
https://www.theodinproject.com/lessons/ruby-ruby-final-project


## Assignment
Build a command line Chess game where two players can play against each other.

The game should be properly constrained – it should prevent players from making illegal moves and declare check or check mate in the correct situations.

Make it so you can save the board at any time (remember how to serialize?)

Write tests for the important parts. You don’t need to TDD it (unless you want to), but be sure to use RSpec tests for anything that you find yourself typing into the command line repeatedly.

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
king

special moves
pawn kill
castling