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
