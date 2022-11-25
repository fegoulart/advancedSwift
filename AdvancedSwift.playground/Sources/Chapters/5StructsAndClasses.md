# 5 STRUCTS AND CLASSES

Structs and classes seem to be similar:

Both have:

* Stored and computed properties
* Methods
* Initializers
* Extensions
* Protocol conformance

But Structs and classes have fundamentally different behaviors

Value types: structs
Reference types: classes

## Value types and Reference Types

Value type: assignment copies the value
Each value type variable holds its own independent value
A type that behave as a value type is said to have value semantics.

A value type is a name for a location in memory that directly contains the value

Reference type:

var view1 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
var view2 = view1
view2.frame.origin = CGPoint(x: 50, y: 50)
view1.frame.origin // (50, 50)
view1.frame.origin // (50, 50)

Reference type variables don't contain the thing itself, but a reference to it.
A type with these properties is also said to have reference semantics.

A reference type variable contain a pointer to the actual instance somewhere else in memory

### Custom types

class ScoreClass {
    var home: Int
    var guest: Int
    init(home: Int, guest: Int) {
        self.home = home
        self.guest = guest
    }
}

var score1 = ScoreClass(home: 0, guest: 0)
var score2 = score1
score2.guest += 1
score1.guest // 1

func scoreGuest(_ score: ScoreClass) {
    score.guest +=1
}

scoreGuest(score1)
score1.guest // 2
score2.guest // 2

struct ScoreStruct {
    var home: Int
    var guest: Int
}

var score3 = ScoreStruct(home: 0, guest 0)
var score4 = score1
score4.guest += 1
score3.guest // 0

Passing a value type as a functon's parameter creates an independent copy of the value.
Function parameter is immutable within the function (like a let variable)

Classes are more powerful tool, but their capabilities come at a cost.
On the other hand, structs are much limiting, but it can be beneficial.

## Mutation

class ScoreClass {
    var home: Int
    var guest: Int
    init(home: Int, guest: Int) {
        self.home = home
        self.guest = guest
    }
}

struct ScoreStruct {
    var home: Int
    var guest: Int
}

### Both var instances

var scoreClass = ScoreClass(home: 0, guest: 0)
var scoreStruct = ScoreStruct(home: 0, guest: 0)

scoreClass.home += 1
scoreStruct.guest += 1

Changing a property within a struct is semantically equivalent to assigning a whole new struct instance to the variable

scoreStruct.guest += 1 is equivalent to 
scoreStruct = ScoreStruct(home: scoreStruct.home, guest: scoreStruct.guest + 1)

### Both let instances

let scoreClass = ScoreClass(home: 0, guest: 0)
let scoreStruct = ScoreStruct(home: 0, guest: 0)

scoreClass.home += 1
scoreStruct.guest += 1 // Error: Left side of mutating operator isn't mutable
// scoreStruct is a let constant

### properties with let but instances with var

class ScoreClass {
    let home: Int
    let guest: Int
    init(home: Int, guest: Int) {
        self.home = home
        self.guest = guest
    }
}

struct ScoreStruct {
    let home: Int
    let guest: Int
}

var scoreClass = ScoreClass(home: 0, guest: 0)
var scoreStruct = ScoreStruct(home: 0, guest: 0)

scoreClass.home += 1 // Error: Left side of mutating operator isn't mutable
// home is a let constant 
scoreStruct.guest += 1 // Error: Left side of mutating operator isn't mutable
// guest is a let constant

### default suggestion

Struct:

use var properties to struct as default:
this allows the mutability of struct instances to be controlled by using var or let on variable level, giving more flexibility
it doesn't introduce potentially global mutable state

let should be used sparingly and intentionally for properties that really shouldn't be mutated after initialization


### Mutating Methods

mutating keyword

extension ScoreStruct {
    mutating func scoreGuest() {
        self.guest += 1  // ---> On mutating methods, self is a var
    }
}

var scoreStruct2 = ScoreStruct(home: 0, guest: 0)
scoreStruct2.scoreGuest()
scoreStruct2.guest // 1

Implicitily mutating: property and subscript setters. If you don't want it, you can use "nonmutating set"

### inout parameter

// new free function:
func scoreGuest(_ score: inout ScoreStruct) {
    score.guest += 1
}

var scoreStruct3 = ScoreStruct(home: 0, guest: 0)
scoreGuest(&scoreStruct3)
scoreStruct3.guest // 1

## Lifecycle

Structs:
* can't have multiple owners
* lifetime is tied to the lifetime of the variable containing the struct
* When variable goes out of the scope, its memory is freed and the struct disappears

Classes:
* can be referenced by multiple owners (requires a more sophisticated memory management)
* Swift uses ARC (Automatic Reference Counting) to keep track of the number of references to a particular instance
  When reference count goes to zero - class deinit is called and memory is freed
* Classes can be used to model shared entities that perform cleanup work when they are eventually freed: ex: file handles have to close their underlying file descriptor or view controllers can require all kinds of cleanup work as intance unregistering observers

### Reference Cycles

A reference cycle is when 2 or more objects reference each other strongly in a way that prevents them form ever being deallocated.
This creates memory leaks and prevents the execution of potential cleanup tasks.

It is impossible to create reference cycles between structs. 
WE CANNOT MODEL CYCLIC DATA STRUCTURES USING STRUCTS.

### Many forms of reference cycle

Reference cycles can have many forms from 2 objects referencing each other strongly to complex cycles consisting of many objects and closures closing over objexts.

Simple example:

// First version
class Window {
    var rootView: View?
} 

class View {
    var window: Window
    init(window: Window) {
        self.window = window
    }
}

var window: Window? = Window() // window: 1
var view: View? = View(window: window) // window: 2, view: 1 - view holds a strong reference to window
window?.rootView = view // window: 2, view: 2

view = nil // window: 2, view: 1
window = nil // window: 1, view: 1 ---> reference cycle

### Weak references

To break the reference cycle, we need to make one of the references weak or unowned.
Assigning an object to a weak variable doesn't change its reference count.
Weak references in Swift are always zeroing: the variable will automatically be set to nil once the referred object gets deallocated. 
This is why weak references must always be optionals.

Fix previously example:

// Second version
class Window {
    weak var rootView: View?
    deinit {
        print("Deinit Window")
    }
}

class View {
    var window: Window
    init(window: Window) {
        self.window = window
    }
    deinit {
        print("Deinit view")
    }
}

var window: Window? = Window()
var view: View? = View(window: window)
window?.rootView = view
window = nil
view = nil
/*
Deinit View
Deinit Window
*/

weak references are very useful when working with delegates, as is common in Cocoa.
The delegating object (ex: table view) needs a reference to its delegate, but it shouldn't own the delegate because that would likely create a reference cycle. Therefore, delegate references are usually weak, and another object (e.g. a view controller) is responsible for making sure the delegate statys around for as long as needed.

### Unowned Reference 

non strong reference that is not optional
The Swift runtime keeps a second reference count in the object to keep track of unowned references.
When all strong references are gone, the object will release all of its resources.
However, the memory of the object itself will still be there until all unowned references are gone too.
The memory is marked as invalid (sometimes called as zombie memory) and any time we try to access an unowned reference, a runtime error will occur.
The safeguard can be circumvented by using unowned(unsafe). If we access an invalid reference that's marked as unowned(unsafe) we get undefined behavior.

### Closures and Reference Cycles

Functions (and closure) are reference types too.
If a closure capture a variable holding a reference type, the closure will maintain a strong reference to it.
This is the other primary way of introducing reference cycles to our code.

Usual pattern:

object A references object B
but object B stores a closure that references object A 

example:

class Window {
    weak var rootView: View?
    var onRotate: (() -> ())? = nil
} 

introducing a reference cycle:

var window: Window? = Window()
var view: View? = View(window: window!)
window?.onRotate = {
    print("We now also need to update the view: \(view)")  // view is captured by this closure
}

View references window
window references the callback 
the callback references the view

#### 3 places where we could break this reference cycle, but just one possible 

As 3 possiveis formas de quebrar esse reference cycle tem a ver com as 3 setas abaixo:

view aponta pra window
windows aponta pra onRotate
onRotate aponta pra view

1. Make the view's reference to the window weak. Unfortunately the window could be deallocated immediately, because there are no other references keeping it alive
2. Make onRotate property weak. Swift doesn't allow marking function properties as weak
3. make sure the closure doesn't strongly reference the view by using a capture list that captures view weakly.
This is the only correct option in this example

Solucao

window?.onRotate = { [weak view] in 
    print("We now also need to update the view: \(view)")
}

Capture lists do more than just marking variables as weak or unowned. 
For example, if we wanted to have a weak variable that refers to the window, we could initialize it in the capture list, or we could even define completely unrelated variables like so:
This is almost the same as definig the variable just above the closure, except that with capture lists, the scope of the variable is just the scope of the closure; it's not available outside of the closure

window?.onRotate = { [weak view, weak myWindow = window, x = 5*5] in
    print("We now also need to update the view: 
    \(view)")
    print("Because the window \(myWindow) changed")
}

### Refactoring the book code to test it

class Window {
    weak var rootView: View?
    var onRotate: (() -> ())? = nil
    deinit {
        print("Window deinit")
    }
}

class View {
    var window: Window // weak var window: Window?
    init(window: Window) {
        self.window = window
    }
    deinit {
        print("View deinit")
    }
}

class Main {
    func runIt() {
        var view: View? = View(window: Window())
        view?.window.onRotate = { // [weak view] in
            print("We now also need to update the view: \(view)")
        }
        view?.window.onRotate?()
    }
}

var main = Main()
main.runIt()

### Choosing between Unowned and Weak References


