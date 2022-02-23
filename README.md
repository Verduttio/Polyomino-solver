# Polyomino-solver

Polyomino solver checks whether from given polyomines you can compose first given polyomino.

To make an executable file use `ghc Polyomino_solver.hs`. Then to run the program use `Polyomino_solver.(extension) [inputFile]`.

inputFile should contain main polyomino (polyomino we want to compose), and set of polyominoes.

inputFile structure:
main polyomino
1st polyomino
2nd polyomino
.
.
.

Polyomino representation
We represent each polyomino by its coordinates in a virtual array.
Example:
Let's say we have a polyomino:
###
  ##
   #
####

Let's add row and column numbers:
  0 1 2 3
0 # # #
1     # #
2       #
3 # # # #

Let's write down the coordinates now:
(0,0) (0,1) (0,2) (1,2) (1,3) (2,3) (3,0) (3,1) (3,2) (3,3)

And these numbers are the representation of our polyomino and should be put into the inputFile.
