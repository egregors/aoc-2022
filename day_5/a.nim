import lib
import sequtils, std/algorithm

# input:
# [D]                     [N] [F]    
# [H] [F]             [L] [J] [H]    
# [R] [H]             [F] [V] [G] [H]
# [Z] [Q]         [Z] [W] [L] [J] [B]
# [S] [W] [H]     [B] [H] [D] [C] [M]
# [P] [R] [S] [G] [J] [J] [W] [Z] [V]
# [W] [B] [V] [F] [G] [T] [T] [T] [P]
# [Q] [V] [C] [H] [P] [Q] [Z] [D] [W]
#  1   2   3   4   5   6   7   8   9 

var cargo = newCargo[char]()
for i in 1..9: cargo.add(newStack[char]())

var cols = @[
    "DHRZSPWQ",
    "FHQWRBV",
    "HSVC",
    "GFH",
    "ZBJGP",
    "LFWHJTQ",
    "NJVLDWTZ",
    "FHGJCZTD",
    "HBMVPW",
].mapIt(it.reversed)

for i in 0..cols.len-1:
    cargo[i].pushMany(cols[i])

cargo.apply9000Cmds(newCmdsFromFile("input.txt"))
cargo.showTop()

