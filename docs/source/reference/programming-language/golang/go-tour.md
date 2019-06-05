# Go Tour

Heavily based on [A Tour of Go](https://tour.golang.org/)
with some codes of mine for the practice problems.

[Effective Go](https://golang.org/doc/effective_go.html)

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

### Different Equal Sign

`=` is assignment

`:=` is declaration and assignment, type is automatically inferred

[Difference between := and = operators in Go](https://stackoverflow.com/questions/17891226/difference-between-and-operators-in-go)

### Const

Created at compile time

Must be evaluated by compiler

Can only be 

* number
* char (rune)
* string
* boolean

[iota](https://github.com/golang/go/wiki/Iota)

[Effective Go - Constants](https://golang.org/doc/effective_go.html#constants)

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

Note that in Go it is safe to return a pointer to local variable.
See [Effective Go Composite Literals](https://golang.org/doc/effective_go.html#composite_literals).

## Flow Control

Go can run statement before `if` or `for`

```go
if v := math.Pow(x, n); v < lim {
  return v
}
```

`for` is go's `while`

```go
for i < 1 {
	i++
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

No pointer arithmetic

```go
var p *int // zero is nil
p = &a
*p = 1
```

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

// slice can grow up from its end
// but cannot grow back from its head, i.e. cannot get the "dropped" first values back
s = s[s:cap(s)] // grow to its capacity
s = s[-1:] // illegal
```

> The zero value of a slice is nil.
> A nil slice has a length and capacity of 0 and has no underlying array.

```go
s == nil // true
```

Create dynamically-sized arrays using `make`

> The make function takes a type, a length, and an optional capacity. When called, make allocates an array and returns a slice that refers to that array.

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
b := [...]string{"Penn", "Teller"} // array (have the compiler count the array elements)
letters := []string{"a", "b", "c", "d"} // slice (leave out the element count)

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

## Interfaces

`a set of method signatures`

A value of interface can be anything as long as those methods are implemented.

Note the indirection will not count, i.e. only a pointer receiver method will not
suffice for the value to have those methods.

```go
type Itf interface {
	M() float64
}

func main() {
	var a Itf

	f := FF(math.Sqrt2)
	v := MyStruct{1, 0}

	a = f  // a FF implements M()
	a = &v // a *MyStruct implements M()

	// v is a MyStruct (not *MyStruct) without M()
	a = v // will give error

	fmt.Println(a.M())
}

type FF float64

func (f FF) M() float64 {
	return float64(f)
}

type MyStruct struct {
	X, Y float64
}

func (ms *MyStruct) M() float64 {
  return ms.X
}
```

Interfaces are implemented implicitly

No explicit declaration or arrangement is necessary (can appear everywhere).

> interface values can be thought of as a tuple of a value and a concrete type

If the value is `nil`, method will be called with a nil receiver.

> In some languages this would trigger a null pointer exception, but in Go it is common to write methods that gracefully handle being called with a nil receiver

```go
func (t *T) M() {
	if t == nil {
		fmt.Println("<nil>")
		return
	}
	fmt.Println(t.S)
}
```

> an interface value that holds a nil concrete value is itself non-nil.

Cannot call methods of `nil` interface values since no *concrete* method specified.

### Empty Interface

Specifies zero methods.

```go
interface{}
```

Holds values of any type.

> Empty interfaces are used by code that handles values of unknown type. For example, fmt.Print takes any number of arguments of type interface{}.

```go
func main() {
  var emp interface{}

  fmt.Printf("(%v, %T)\n", emp, emp)

  emp = 39

  fmt.Printf("(%v, %T)\n", emp, emp)

  emp = "39"

  fmt.Printf("(%v, %T)\n", emp, emp)
}
```

## Type Assertions

Assets if interface value `i` has `T` and assign to t if success.

```go
t := i.(T)     // Trigger a Panic if not T
t, ok := i.(T) // return (zero value, false) if not T
```

Type switches

```go
func check(i interface{}) {
  switch v := i.(type) {
  case T:
    // here v has type T
  case S:
    // here v has type S
  default:
    // no match; here v has the same type as i
  }
}
```

## Stringers

Defined by `fmt` package.

```go
type Stringer interface {
    String() string
}

func (a Apple) String() string {
	return fmt.Sprintf("%v (%v years)", p.Size, p.Age)
}
```

Like "toString" of Java. Any type with this method implemented will be used to print
by packages like `fmt`.

## Errors

Similar to `Stringer`, another interface for errors:

```go
type error interface {
    Error() string
}
```

```go
i, err := strconv.Atoi("42")
if err != nil {
    fmt.Printf("couldn't convert number: %v\n", err)
    return
}
fmt.Println("Converted integer:", i)
```

```go
package main

import (
	"fmt"
	"math"
)

func Newton(a, b float64) float64 {
  return (a*a - b)/(2*a)
}

func Sqrt(x float64) (float64, error) {
  if(x < 0) {
  	return x, ErrNegativeSqrt(x)
  }
  const delta = 1e-12
  z := 1.0
  for a := Newton(z,x); math.Abs(z*z - x) > delta; a = Newton(z,x){
      z -= a
  }
  return z, nil
}

type ErrNegativeSqrt float64

func (e ErrNegativeSqrt) Error() string {
	return fmt.Sprintf("negative number cannot calc square root: %v", float64(e)) // A call to fmt.Sprint(e) inside the Error method will send the program into an infinite loop.
}

func main() {
  fmt.Println(ErrNegativeSqrt(-2).Error())
	fmt.Println(Sqrt(2))
	fmt.Println(Sqrt(-2))
}
```

## Readers

An interface `io.Reader`.

[Implementations of Reader Interface - Go](https://golang.org/search?q=Read#Global)

```go
func (T) Read(b []byte) (n int, err error)
```

> Read populates the given byte slice with data and returns the number of bytes populated and an error value. 
> It returns an io.EOF error when the stream ends.

```go
r := strings.NewReader("Hello, Reader!")
b := make([]byte, 8)
for {
	n, err := r.Read(b)
	fmt.Printf("n = %v err = %v b = %v\n", n, err, b)
	fmt.Printf("b[:n] = %q\n", b[:n])
	if err == io.EOF {
		break
	}
}
```

```go
package main

import "golang.org/x/tour/reader"

type MyReader struct{}

// TODO: Add a Read([]byte) (int, error) method to MyReader.
func (m MyReader) Read(b []byte) (int, error) {
	for i := range b {
		b[i] = 'A'
	}
 	return len(b), nil
}

func main() {
	reader.Validate(MyReader{})
}
```

```go
package main

import (
	"io"
	"os"
	"strings"
	"fmt"
)

const ROT13_SHIFT byte = 13

type rot13Reader struct {
	r io.Reader
}

func (a rot13Reader) Error() string {
	return fmt.Sprintf("Failed to parse input")
}

func (a rot13Reader) Read(b []byte) (int, error) {
	_,err := a.r.Read(b)
	if err != nil {
		return 0, err
	}
	fmt.Printf("size: %v\n", len(b)) // 32768
	for i,v := range b {
		switch {
			case byte('a') <= byte(v) && byte(v) <= byte('z'): // lower case
				if (byte(v) + ROT13_SHIFT) > byte('z') {
					b[i] -= ROT13_SHIFT
				} else {
					b[i] += ROT13_SHIFT
				}
			case byte('A') <= byte(v) && byte(v) <= byte('Z'): // upper case
				if (byte(v) + ROT13_SHIFT) > byte('Z') {
					b[i] -= ROT13_SHIFT
				} else {
					b[i] += ROT13_SHIFT
				}
		}
	}
	return len(b), nil
}

func main() {
	s := strings.NewReader("Lbh penpxrq gur pbqr!")
	r := rot13Reader{s}
	io.Copy(os.Stdout, &r)
}
```

## Images

Image interface is defined in `image` package [documentation](https://golang.org/pkg/image/#Image).

[documentation for color](https://golang.org/pkg/image/color/)

```go
package image

type Image interface {
    ColorModel() color.Model
    Bounds() Rectangle
    At(x, y int) color.Color
}
```

```go
m := image.NewRGBA(image.Rect(0, 0, 100, 100))
fmt.Println(m.Bounds())
fmt.Println(m.At(0, 0).RGBA())
```

```go
package main

import (
	"image"
	"image/color"
	"golang.org/x/tour/pic"
)

type Image struct{
	Width int
	Height int
	Color int
}

const WIDTH int = 256
const HEIGHT int = 256
const COLOR int = 128

func (img Image) Bounds() image.Rectangle {
	return image.Rect(0,0,img.Width,img.Height)
}

func (img Image) ColorModel() color.Model {
	return color.RGBAModel
}

func (img Image) At(x,y int) color.Color {
	//v := uint8(x^y)
	//return color.RGBA{v,v,255,255}
	return color.RGBA{uint8(x+img.Color),uint8(y+img.Color),255,255}
}

func main() {
	m := Image{WIDTH, HEIGHT, COLOR}
	pic.ShowImage(m)
}
```

## Goroutines

A lightweight thread managed by Go runtime.

```go
func main() {
	go say("world")
	say("hello")
}
```

The argument is evaluated in the current goroutine.

The address space is shared. Shared memory access should be synced.

```go
package main

import (
	"fmt"
	"time"
)

func speak() {
	for i := 0; i < 5; i++ {
    //time.Sleep(100 * time.Millisecond)
    // if not comment, will not fully output since the main thread will quit before the print statement ?
		fmt.Println("Speaking: %v",i)
	}
}

func say(s string) {
	for i := 0; i < 5; i++ {
		time.Sleep(100 * time.Millisecond)
		fmt.Println(s)
	}
	go speak()
}

func main() {
	go say("world")
	say("hello")
}
```

## Channels

A way goroutines use to send and receive values.

```go
ch := make(chan int) // make channel ch before use

ch <- v    // Send v to ch
v := <-ch  // Assign value received from ch to v
// as the arrow points
```

> By default, sends and receives block until the other side is ready.
> This allows goroutines to synchronize without explicit locks or condition variables.

```go
  s := []int{7, 2, 8, -9, 4, 0}

	c := make(chan int)
	go sum(s[len(s)/2:], c)
	go sum(s[:len(s)/2], c)
	x, y := <-c, <-c

	go squareSum(s[len(s)/2:], c)
	go squareSum(s[:len(s)/2], c)
  a,b := <-c, <-c
  
  fmt.Println(x, y, x+y)
	fmt.Println(a, b, a+b)
```

```go
	go sum(s[len(s)/2:], c)
	go sum(s[:len(s)/2], c)
	go squareSum(s[len(s)/2:], c)
  go squareSum(s[:len(s)/2], c)
  // will mess up
	x, y := <-c, <-c
  a,b := <-c, <-c
  
  fmt.Println(x, y, x+y)
	fmt.Println(a, b, a+b)
```

Channels can be buffered

> Sends to a buffered channel block only when the buffer is full.
> Receives block when the buffer is empty.

```go
func main() {
	ch := make(chan int, 2)
	ch <- 1
	ch <- 2
	//ch <- 3 // uncomment to overfill buffer
	fmt.Println(<-ch)
	fmt.Println(<-ch)
}

// not overfilling

func main() {
	ch := make(chan int, 2)
	ch <- 1
	fmt.Println(<-ch)

	ch <- 2
	ch <- 3
	fmt.Println(<-ch)
	fmt.Println(<-ch)
}
```

## Range and Close

To indicate ending of sending, senders can `close` a channel. Receivers can test it if closed
but should never close it on themselves.

```go
v, ok := <-ch // ok is false if no more values and channel is closed
for i := range ch // receive until closed
```

```go
package main

import (
	"fmt"
	"time"
)

func fibonacci(n int, c chan int) {
	x, y := 0, 1
	for i := 0; i < n; i++ {
		c <- x
		x, y = y, x+y
	}
	close(c)
}

func bgSend(n int, c chan int) {
	for i:=0; i < n; i++ {
		time.Sleep(10*time.Millisecond)
		c <- i
	}
	close(c)
}

func main() {
  c := make(chan int,10)
  // calling them together might lead to send to closed channel
  // which is a panic
	go bgSend(cap(c)*20, c)
	//go fibonacci(cap(c), c)
	for i := range c {
		fmt.Println(i)
	}
	fmt.Println("Done")
}
```

> Channels aren't like files; you don't usually need to close them.
> Closing is only necessary when the receiver must be told there are
> no more values coming, such as to terminate a range loop.

## Select

Let a goroutine be able to wait for multiple communications (including "default").

```go
select {
	case i := <-c:
			// use i
	case <-myTimer:
			// this channel is open, for now
	default:
			// receiving from c would block
}
```

> A select blocks until one of its cases can run, then it executes that case.
> It chooses one at random if multiple are ready.

```go
package main

import "fmt"

func count(c, quit chan int) {
	x := 0
	for {
		select {
		case c <- x:
			x++
		case <-quit:
			fmt.Println("quit")
			return
		}
	}
}

func main() {
	c := make(chan int)
	quit := make(chan int)
	go func() {
		for i := 0; i < 10; i++ {
			fmt.Println(<-c)
		}
		quit <- 0
	}()
	count(c,quit)
}
```

snowme34's solution to "Exercise: Equivalent Binary Trees" (with a brief implementation of stack)

```go
package main

import "golang.org/x/tour/tree"
import "fmt"

const TREE_SIZE int = 10

type stack []interface{}

func (s *stack) Push(v interface{}) {
    *s = append(*s, v)
}

func (s *stack) Pop() interface{} {
	l := len(*s)

	if l == 0 {
		return nil
	}

	ret := (*s)[l-1]
	*s = (*s)[:l-1]

	return ret
}

func (s *stack) Len() int {
	return len(*s)
}


// Walk walks the tree t sending all values
// from the tree to the channel ch.
func Walk(t *tree.Tree, ch chan int) {
    var st stack

	for t != nil || st.Len() != 0 {
		if t != nil {
			st.Push(t)
			t = t.Left
		} else {
			t = st.Pop().(*tree.Tree)
			ch <- t.Value
			t = t.Right
		}
	}

}

// pre-order
func WalkPreOrder(t *tree.Tree, ch chan int) {
    var st stack

    if (t != nil) {
	  st.Push(t)
	}

    for st.Len() != 0 {
    	var x *tree.Tree
		x = st.Pop().(*tree.Tree)
    	for (x != nil) {
			ch <- x.Value
      		if(x.Right != nil) {
			  st.Push(x.Right)
			}

      		x = x.Left
    	}
  	}
}

// Same determines whether the trees
// t1 and t2 contain the same values.
func Same(t1, t2 *tree.Tree) bool {
    c1 := make(chan int)
	c2 := make(chan int)
	go Walk(t1, c1)
	go Walk(t2, c2)
	for i := 0; i < TREE_SIZE; i++ {
		if((<-c1) != (<-c2)) {
			return false
		}
	}
	return true
}

func main() {
  fmt.Println("Testing Walk")
  ch := make(chan int)
  go Walk(tree.New(1), ch)
  for i := 0; i < TREE_SIZE; i++ {
  	fmt.Println(<-ch)
  }
  
  fmt.Println("===============")
  
  fmt.Println("Testing Same")
  fmt.Println("Should be true",Same(tree.New(1), tree.New(1)))
  fmt.Println("Should be false",Same(tree.New(1), tree.New(2)))
}
```

## Mutual Exclusion

Mutex

Avoid conflicts

Go lib `sync.Mutex` has: `Lock`, `Unlock`

Can use `defer` to make sure mutex is unlocked at the end

```go
type aThing struct {
	v   []string
	mux sync.Mutex
}

func (a *aThing) Write(s string) {
	a.mux.Lock()
	a.v = append(a.v, s)
	a.mux.Unlock()
}

func (a *aThing) WriteDefer(s string) {
	a.mux.Lock()
	defer a.mux.Unlock()
	a.v = append(a.v, s)
}

func main() {
	a := aThing{v:[]string{}}
	a.Write("A")
	a.WriteDefer("B")
	fmt.Println(a.v)
}
```

snowme34's solutions to "Exercise: Web Crawler" (better one below)

```go
type CrawlCache struct {
  v	map[string]bool
  mux sync.Mutex
}

func (s *CrawlCache)checkAnsSetVisit(url string)bool{
	s.mux.Lock()
	defer s.mux.Unlock()

	if _,ok:=s.v[url]; ok==false {
		s.v[url] = true
		return false
	}

	return true
}

// Crawl uses fetcher to recursively crawl
// pages starting with url, to a maximum of depth.
func Crawl(ch chan string, cache *CrawlCache, url string, depth int, fetcher Fetcher) {
  defer close(ch)
  
  if depth <= 0 || cache.checkAnsSetVisit(url) {
    return
  }
  
  body, urls, err := fetcher.Fetch(url)
  if err != nil {
    ch <- fmt.Sprintf("%v", err)
	return
  }
  
  ch <- fmt.Sprintf("found: %s %q", url, body)
  
  chs := make([]chan string, len(urls))
  for i, u := range urls {
    chs[i] = make(chan string)
    go Crawl(chs[i], cache, u, depth-1, fetcher)
  }

  for i := range chs {
    for s := range chs[i] {
        ch <- s
    }
  }

  return
}

func main() {
  // all goroutines have ptr to this
  cache := CrawlCache{v:make(map[string]bool)} 
  ch := make(chan string)
  
  go Crawl(ch, &cache, "https://golang.org/", 4, fetcher)
  
  for s := range ch {
    fmt.Println(s)
  }
}
```

The solution using Wait Group

```go
type CrawlCache struct {
  v	map[string]bool
  mux sync.Mutex
}

func (s *CrawlCache)checkAnsSetVisit(url string)bool{
	s.mux.Lock()
	defer s.mux.Unlock()

	if _,ok:=s.v[url]; !ok {
		s.v[url] = true
		return false
	}
	
	return true
}

func doCrawl(wg *sync.WaitGroup, ch chan string, cache *CrawlCache, url string, depth int, fetcher Fetcher) {
  defer wg.Done()
  
  if depth <= 0 || cache.checkAnsSetVisit(url) {
    return
  }
  
  body, urls, err := fetcher.Fetch(url)
  if err != nil {
    ch <- fmt.Sprintf("%v", err)
	return
  }
  
  ch <- fmt.Sprintf("found: %s %q", url, body)
  
  for _, u := range urls {
    wg.Add(1)
    go doCrawl(wg, ch, cache, u, depth-1, fetcher)
  }
}

func Crawl(wg *sync.WaitGroup, ch chan string, cache *CrawlCache, url string, depth int, fetcher Fetcher) {
  defer close(ch)
  
  wg.Add(1)
  go doCrawl(wg, ch, cache, url, depth, fetcher)
  
  wg.Wait()
}

func main() {
  // all goroutines have ptr to this
  cache := CrawlCache{v:make(map[string]bool)} 
  ch := make(chan string)
  
  var wg sync.WaitGroup
  
  go Crawl(&wg, ch, &cache, "https://golang.org/", 4, fetcher)
  
  for s := range ch {
    fmt.Println(s)
  }
}
```

## CLI

Brief here, always read document

```bash
go build a.go -o my/path/a.exe
go build -v
go build -n    # print commands but do not execute
go build -x    # print commands and execute
go build -race # test data racing
# for different OS: mypackage_linux.go mypackage_windows.go mypackage_darwin.go

go clean -n
go clean -x
go clean -i    # files generated by go install
go clean -i -n

go fmt -n
go fmt -x

go get

go install -v

go test ./...

go vet

go mod init github.com/name/package

go run

godoc -http=localhost:6060
```
