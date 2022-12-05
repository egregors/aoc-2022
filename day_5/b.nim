import strutils, sequtils, std/algorithm

# types

# base stack
type
    Stack* [T] = object 
        data: seq[T]

proc newStack*  [T](): Stack[T]                 = result.data = newSeq[T]()
proc len*       [T](s: Stack[T]): int           = s.data.len
proc isEmpty*   [T](s: Stack[T]): bool          = s.data.len == 0
proc push*      [T](s: var Stack[T], item: T)   = s.data.add(item)
proc peek*      [T](s: Stack[T]): T             = s.data[^1]
proc pop*       [T](s: var Stack[T]): T =
                                                result = s.peek()
                                                s.data.del(s.data.len-1)

proc pushMany*  [T](s: var Stack[T], items: seq[T]) =
                                                for item in items: s.push(item)

type
    Cargo* [T] = seq[Stack[T]]

proc newCargo*  [T](): Cargo[T]             = result = newSeq[Stack[T]]()
proc showTop*   [T](c: Cargo[T])            =
    var result: string
    for i in 0..c.len-1:
        if c[i].isEmpty(): result &= "_" else: result &= $c[i].peek()
    echo result

# commands
type
    Cmd* = object
        amount, src, dst: int

proc newCmdFromString* (s: string): Cmd =
    let a = s.split(" ")
    result.amount = parseInt(a[1])
    result.src = parseInt(a[3])
    result.dst = parseInt(a[5])

proc apply* [T](c: Cmd, xs: var Cargo[T]) =
    var buf = newSeq[T](c.amount)
    for i in 0..c.amount-1: buf[i] = xs[c.src-1].pop()
    xs[c.dst-1].pushMany(buf.reversed())

type
    Cmds* = seq[Cmd]

proc newCmdsFromFile* (path: string): Cmds =
    readFile(path).strip().splitLines().map(newCmdFromString)

# main
# --------------------------------------------------------------------------

# init stacks

# todo: read from file
var xs = newCargo[char]()
for i in 1..9:
    xs.add(newStack[char]())

# todo: make this in constructor
# [D]                     [N] [F]    
# [H] [F]             [L] [J] [H]    
# [R] [H]             [F] [V] [G] [H]
# [Z] [Q]         [Z] [W] [L] [J] [B]
# [S] [W] [H]     [B] [H] [D] [C] [M]
# [P] [R] [S] [G] [J] [J] [W] [Z] [V]
# [W] [B] [V] [F] [G] [T] [T] [T] [P]
# [Q] [V] [C] [H] [P] [Q] [Z] [D] [W]
#  1   2   3   4   5   6   7   8   9 

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
    xs[i].pushMany(cols[i])

# commands
for c in newCmdsFromFile("input.txt"):
    c.apply(xs)

xs.showTop()