
Feature: codebreaker submits guess
The codebreaker submits a guess of four coloured
pegs. The game marks the guess with black and
white "marker" pegs.

For each peg in the guess that matches the colour
and position of a peg in the secret code, the 
mark includes one black peg. For each additional
peg in the guess that matches the colour byt not 
the position of a peg in the secret code, a 
white peg is added to the mark.
Scenario Outline: submit guess
Given the secret code is <code>
When I guess <guess>
Then the mark should be <mark>
Scenarios: all colours correct
 | code    | guess   | mark |
 | r g y c | r g y c | bbbb |
 | r g y c | r g c y | bbww |
 | r g y c | y r g c | bwww |
 | r g y c | c r g y | wwww |

# Scenarios: 3 colours correct
#  | code    | guess   | mark |
#  | r g y c | w g y c | bbb  |
#  | r g y c | w r y c | bbw  |
#  | r g y c | w r g c | bww  |
#  | r g y c | w r g y | www  |

# Scenarios: 2 colours correct
#  | code    | guess   | mark |
#  | r g y c | w g w c | bb   |
#  | r g y c | w r w c | bw   |
#  | r g y c | g w w c | ww   |

# Scenarios: 1 colour correct
#  | code    | guess   | mark |
#  | r g y c | r w w w | b    |
#  | r g y c | w w r w | w    |


