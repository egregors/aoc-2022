import strutils, sequtils, std/algorithm

type Stack* [T] = object 
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

type Cmd* = object
    amount, src, dst: int

proc newCmdFromString* (s: string): Cmd =
    let a = s.split(" ")
    result.amount = parseInt(a[1])
    result.src = parseInt(a[3])
    result.dst = parseInt(a[5])

type Cmds* = seq[Cmd]

proc newCmdsFromFile* (path: string): Cmds =
    readFile(path).strip().splitLines().map(newCmdFromString)

type Cargo* [T] = seq[Stack[T]]

proc newCargo* [T](): Cargo[T] = result = newSeq[Stack[T]]()

proc apply9000Cmds* [T](c: var Cargo[T], cmds: Cmds) = 
    for cmd in cmds:
        for i in 0..cmd.amount-1:
            c[cmd.dst-1].push(c[cmd.src-1].pop())

proc apply9001Cmds* [T](c: var Cargo[T], cmds: Cmds) = 
    for cmd in cmds:
        var buf = newSeq[T](cmd.amount)
        for i in 0..cmd.amount-1: buf[i] = c[cmd.src-1].pop()
        c[cmd.dst-1].pushMany(buf.reversed())

proc showTop* [T](c: Cargo[T]) =
    var result = ""
    for i in 0..c.len-1:
        if c[i].isEmpty(): 
            result &= "_" else: result &= $c[i].peek()
    echo result
