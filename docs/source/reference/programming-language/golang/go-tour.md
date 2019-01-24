# Go Tour

Heavily based on [A Tour of Go](https://tour.golang.org/)
with some codes of mine for the practice problems.

## Packages

Basic

> Every Go program is made up of packages.
> Programs start running in package main.
> the package name is the same as the last element of the import path

```go
package main

import (
   "fmt"
   "math/rand"
)
```

Export

> In Go, a name is exported if it begins with a capital letter.

## Types

[Go's Declaration Syntax](https://blog.golang.org/gos-declaration-syntax)

```go
func split(sum int) (x, y int) {
   x = sum * 4 / 9
   y = sum - x
   return
}
```

### Basic types

Go's basic types

```go
bool

string

int int8 int16 int32 int64
uint uint8 uint16 uint32 uint64 uintptr

byte // alias for uint8

rune // alias for int32
// represents a Unicode code point

float32 float64

complex64 complex128
```

Quoted from "A Tour of Go"

> The example shows variables of several types, and also that variable declarations may be "factored" into blocks, as with import statements.
> The int, uint, and uintptr types are usually 32 bits wide on 32-bit systems and 64 bits wide on 64-bit systems. When you need an integer value you should use int unless you have a specific reason to use a sized or unsigned integer type.

## Flow Control

Go can run statement before `if` or `for`

```go
if v := math.Pow(x, n); v < lim {
  return v
}
```

Snowme34's implementation of Newton algorithm:

```go
package main

import (
  "fmt"
  "math"
)

func Newton(a, b float64) float64 {
  return (a*a - b)/(2*a)
}

func Sqrt(x float64) float64 {
  const delta = 1e-12
  z := 1.0
  for a := Newton(z,x); math.Abs(z*z - x) > delta; a = Newton(z,x){
      z -= a
  }
  return z
}

func main() {
   fmt.Println(Sqrt(3))
   fmt.Println(math.Sqrt(3))
}
```

Switch without condition is `switch true`

A clean way to manage a long sequence of `if` statements:

```go
t := time.Now()
   switch {
   case t.Hour() < 12:
       fmt.Println("Good morning!")
   case t.Hour() < 17:
       fmt.Println("Good afternoon.")
   default:
       fmt.Println("Good evening.")
   }
```

Defer pushes function into stack, arguments are evaluated but calls are stacked

```go
for i := 0; i < 10; i++ {
       defer fmt.Println(i)
}

fmt.Println("done")
```

## More Types

```go
   v := Vertex{1, 2}
   p := &v
   p.X = 1e9            // ptrs to structs
   fmt.Println(v)
```

```go
   s := []struct {      // struct literals
       i int
       b bool
   }{
       {2, true},
       {3, false},
       {5, true},
       {7, true},
       {11, false},
       {13, true},
   }
```

## Arrays and Slices

```go
// all equivalent for a array with size 10
a[0:10]
a[:10]
a[0:]
a[:]
```

About slice

> A slice has both a length and a capacity.
> The length of a slice is the number of elements it contains.
> The capacity of a slice is the number of elements in the underlying array, counting from the first element in the slice.

```go
len(s)
cap(s)

// Extend its length.
s = s[:4]
printSlice(s)

// Drop its first two values.
s = s[2:]
printSlice(s)

//output:
// len=4 cap=6 [2 3 5 7]
// len=2 cap=4 [5 7]
```

> The zero value of a slice is nil.
> A nil slice has a length and capacity of 0 and has no underlying array.

```go
s == nil // true
```

Create dynamically-sized arrays using `make`

```go
b := make([]int, 0, 5) // len(b)=0, cap(b)=5

b = b[:cap(b)] // len(b)=5, cap(b)=5
b = b[1:]      // len(b)=4, cap(b)=4
```

slices of slices

```go
// Create a tic-tac-toe board.
   board := [][]string{
       []string{"_", "_", "_"},
       []string{"_", "_", "_"},
       []string{"_", "_", "_"},
   }
```

join strings

```go
fmt.Printf("%s\n", strings.Join(board[0], " "))
```

array and slice

> A slice cannot be grown beyond its capacity. Attempting to do so will cause a runtime panic, just as when indexing outside the bounds of a slice or array. Similarly, slices cannot be re-sliced below zero to access earlier elements in the array.

```go
b := [...]string{"Penn", "Teller"} // array
letters := []string{"a", "b", "c", "d"} // slice

b := []byte{'g', 'o', 'l', 'a', 'n', 'g'}
// b[1:4] == []byte{'o', 'l', 'a'}, sharing the same storage as b
```

### Growing slices (the copy and append functions)

To double the capacity of a slice:

`copy()`:

```go
func copy(dst, src []T) int
```

it will copy only up to the smaller number of elements

```go
t := make([]byte, len(s), (cap(s)+1)*2) // +1 in case cap(s) == 0
for i := range s {
t[i] = s[i]
}
s = t

// can be simplified to

t := make([]byte, len(s), (cap(s)+1)*2)
copy(t, s) // number of items copied
s = t
```

Full control over append

```go
func AppendByte(slice []byte, data ...byte) []byte {
  m := len(slice)
  n := m + len(data)
  if n > cap(slice) { // if necessary, reallocate
    // allocate double what's needed, for future growth.
    newSlice := make([]byte, (n+1)*2)
    copy(newSlice, slice)
    slice = newSlice
  }
  slice = slice[0:n]
  copy(slice[m:n], data)
  return slice
}
```

append (https://golang.org/pkg/builtin/#append)

```go
func append(s []T, x ...T) []T
```

```go
a := make([]int, 1)
// a == []int{0}
a = append(a, 1, 2, 3)
// a == []int{0, 1, 2, 3}

a := []string{"John", "Paul"}
b := []string{"George", "Ringo", "Pete"}
a = append(a, b...) // equivalent to "append(a, b[0], b[1], b[2])"
```

### Range

Range

> The range form of the for loop iterates over a slice or map.
> For slice, two values are returned for each iteration. The first is the index, and the second is a copy of the element at that index.

```go
for i, v := range someSlice{
  fmt.Printf("%d: %d\n", i, v)
}
for i := range pow {
  pow[i] = 1 << uint(i) // == 2**i
}
for _, value := range pow {
  fmt.Printf("%d\n", value)
}
```

## Maps

```go
m = make(map[string]Vertex)
m["Bell Labs"] = Vertex{
    40.68433, -74.39967,
}
```

> Map literals are like struct literals, but the keys are required.

```go
var m = map[string]Vertex{
   "Bell Labs": Vertex{
       40.68433, -74.39967,
   },
   "Google": Vertex{
       37.42202, -122.08408,
   },
}

//If the top-level type is just a type name, you can omit it from the elements of the literal.

var m = map[string]Vertex{
   "Bell Labs": {40.68433, -74.39967},
   "Google":    {37.42202, -122.08408},
}
```

> Insert and update, retrieve (zero-value if non-exist), delete, if contains:

```go
m := make(map[string]int)

m["Answer"] = 42
fmt.Println("The value:", m["Answer"])

m["Answer"] = 48
fmt.Println("The value:", m["Answer"])

delete(m, "Answer")
fmt.Println("The value:", m["Answer"])

//v, ok = m["Answer"] // if already declared
v, ok := m["Answer"]
fmt.Println("The value:", v, "Present?", ok)
```

## function values

closures

> A closure is a function value that references variables from outside its body. The function may access and assign to the referenced variables; in this sense the function is "bound" to the variables.

fibonacci closure:

```go
package main

import "fmt"

// fibonacci is a function that returns
// a function that returns an int.
func fibonacci() func() int {
   a,b := 0,1
   return func() int {
       b += a
       a = b-a
       return b-a
   }
}

func main() {
   f := fibonacci()
   for i := 0; i < 6; i++ {
       fmt.Println(f())
   }
}
```

## Methods

Methods are functions

> Go does not have classes. However, you can define methods on types.

> A method is a function with a special receiver argument.

> The receiver appears in its own argument list between the func keyword and the method name.

```go
type Vertex struct {
   X, Y float64
}

func (v Vertex) Abs() float64 {
   return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

func main() {
   v := Vertex{3, 4}
   fmt.Println(v.Abs())
}
```

If moving the receiver to the argument, use the normal function syntax, the functionality is identical

> You can only declare a method with a receiver whose type is defined in the same package as the method. You cannot declare a method with a receiver whose type is defined in another package (which includes the built-in types such as int).

```go
type MyFloat float64

func (f MyFloat) Abs() float64 {
   if f < 0 {
       return float64(-f)
   }
   return float64(f)
}
```

Pointer receiver

> Since methods often need to modify their receiver, pointer receivers are more common than value receivers.

```go
func (f *MyFloat) Inc() {
  *f++
}
```

Pointer indirection

If a method has a pointer receiver, then `v.go(5)` as `(&v).go(5)` where v is a value will
both be interpreted as `&v` by Go for convenience.

```go
var v MyObject
v.Walk(5)
p := &v
p.Walk(10)
```

The indirection also works in reverse direction, i.e. if the receiver is a value, Go will
regard `p.go(5)` as `(*p).go(5)` where p is a pointer.

Pointer receivers are recommended since it can modify and Go will not make a copy.

Mixture of 2 is discouraged.