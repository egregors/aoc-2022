package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
	"time"
)

type Cell rune

const (
	empty Cell = '.'
	mark  Cell = '#'
)

type Point struct {
	V    Cell
	R, C int
	Next *Point
}

type Field struct {
	Cells [][]Cell
	Head  Point
	Tail  Point
	Start Point

	ps []*Point
}

func NewField(n int) *Field {
	f := &Field{
		Cells: make([][]Cell, n),
	}
	for i := range f.Cells {
		f.Cells[i] = make([]Cell, n)
		for j := 0; j < n; j++ {
			f.Cells[i][j] = empty
		}
	}
	return f
}

func NewFieldA(n int) *Field {
	f := NewField(n)
	ini := n / 2
	f.Start = Point{'s', ini, ini, nil}
	f.Tail = Point{'T', ini, ini, nil}
	f.Head = Point{'H', ini, ini, &f.Tail}
	return f
}

func NewFieldB(n int) *Field {
	f := NewField(n)
	ini := n / 2
	f.Start = Point{'s', ini, ini, nil}
	f.Tail = Point{'9', ini, ini, nil}
	f.ps = []*Point{
		{'1', ini, ini, nil},
		{'2', ini, ini, nil},
		{'3', ini, ini, nil},
		{'4', ini, ini, nil},
		{'5', ini, ini, nil},
		{'6', ini, ini, nil},
		{'7', ini, ini, nil},
		{'8', ini, ini, nil},
	}
	for i := 0; i < len(f.ps)-1; i++ {
		f.ps[i].Next = f.ps[i+1]
	}
	f.ps[len(f.ps)-1].Next = &f.Tail
	f.Head = Point{
		V:    'H',
		R:    ini,
		C:    ini,
		Next: f.ps[0],
	}
	return f
}

func (f *Field) String() string {
	var s string
	for i := range f.Cells {
		for j := range f.Cells[i] {
			// tODO:
			cell := f.Cells[i][j]
			//cell := empty
			if f.Start.R == i && f.Start.C == j {
				cell = f.Start.V
			}
			if f.Tail.R == i && f.Tail.C == j {
				cell = f.Tail.V
			}

			for pi := len(f.ps) - 1; pi >= 0; pi-- {
				if f.ps[pi].R == i && f.ps[pi].C == j {
					cell = f.ps[pi].V
				}
			}

			if f.Head.R == i && f.Head.C == j {
				cell = f.Head.V
			}

			s += string(cell)
		}
		s += "\n"
	}
	s += "---"
	return s
}

func (f *Field) pullTail(h, t *Point) {
	// it a tail on the same point as head - do nothing
	if h.R == t.R && h.C == t.C {
		return
	}

	// straight
	dirs := [][]int{
		{-2, 0}, // U
		{2, 0},  // D
		{0, -2}, // L
		{0, 2},  // R
	}
	// ok
	for _, dir := range dirs {
		newR, newC := t.R+dir[0], t.C+dir[1]
		if newR >= 0 && newR < len(f.Cells) && newC >= 0 && newC < len(f.Cells) {
			// find the head
			if newR == h.R && newC == h.C {
				if t == &f.Tail {
					f.Cells[t.R][t.C] = mark
				}

				if t.R != newR {
					t.R += dir[0] / 2
				} else {
					t.C += dir[1] / 2
				}
			}
		}
	}

	// cross
	//		 X x . x X
	//		 x . . . x
	//		 . . T . .
	//		 x . . . x
	//		 X x . x X
	dirs = [][]int{
		{-2, -1}, // UL
		{-2, -2}, // UUL
		{-1, -2}, // LU

		{-2, 1}, // UR
		{-2, 2}, // UUR
		{-1, 2}, // RD

		{1, -2}, // LD
		{2, -2}, // LDD
		{2, -1}, // DL

		{1, 2}, // RD
		{2, 2}, // RDD
		{2, 1}, // DR
	}
	for _, dir := range dirs {
		newR, newC := t.R+dir[0], t.C+dir[1]
		if newR >= 0 && newR < len(f.Cells) && newC >= 0 && newC < len(f.Cells) {
			// find the head
			if newR == h.R && newC == h.C {
				if t == &f.Tail {
					f.Cells[t.R][t.C] = mark
				}

				if h.R > t.R {
					if h.C > t.C {
						t.R += 1
						t.C += 1
					} else {
						t.R += 1
						t.C -= 1
					}
				} else {
					if h.C > t.C {
						t.R -= 1
						t.C += 1
					} else {
						t.R -= 1
						t.C -= 1
					}
				}
			}
			continue
		}
	}

	if t.Next != nil {
		f.pullTail(t, t.Next)
	}
}

func (f *Field) print() {
	duration := 50 * time.Millisecond
	fmt.Print("\033[H\033[2J")
	fmt.Println(f)
	time.Sleep(duration)
}

func (f *Field) Move(m Move) {
	switch m.Dir {
	case "U":
		for i := 0; i < m.Dis; i++ {
			f.Head.R--
			f.pullTail(&f.Head, f.Head.Next)
			//f.print()
		}
	case "D":
		for i := 0; i < m.Dis; i++ {
			f.Head.R++
			f.pullTail(&f.Head, f.Head.Next)
			//f.print()
		}
	case "L":
		for i := 0; i < m.Dis; i++ {
			f.Head.C--
			f.pullTail(&f.Head, f.Head.Next)
			//f.print()
		}
	case "R":
		for i := 0; i < m.Dis; i++ {
			f.Head.C++
			f.pullTail(&f.Head, f.Head.Next)
			//f.print()
		}
	}
}

func (f *Field) CountMarks() int {
	f.Cells[f.Tail.R][f.Tail.C] = mark
	count := 0
	for _, r := range f.Cells {
		for _, c := range r {
			if c != empty {
				count++
			}
		}
	}
	return count
}

type Move struct {
	Dir string
	Dis int
}

func NewMove(s string) Move {
	move := strings.Split(s, " ")
	dis, _ := strconv.Atoi(move[1])
	return Move{move[0], dis}
}

func readFromFile(path string) []Move {
	file, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	var moves []Move

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		moves = append(moves, NewMove(scanner.Text()))
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	return moves
}

func main() {
	moves := readFromFile("input.txt")
	n := 500

	// a
	f := NewFieldA(n)
	for _, m := range moves {
		f.Move(m)
	}
	fmt.Println("a:", f.CountMarks())

	// b
	f = NewFieldB(n)
	for _, m := range moves {
		f.Move(m)
	}

	fmt.Println("b:", f.CountMarks())
}
