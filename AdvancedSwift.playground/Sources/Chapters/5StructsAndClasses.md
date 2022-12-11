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

Should we prefer unowned or weak references in own APIs ?

This question boils down to the lifetimes of the objects involved.
If the objects have independent lifetimes a weak reference is the only safe choice (when we cannot make assumptions about which object will outlive the other).

Unowned reference is often more convenient when we can guarantee that the non-strongly referenced object has the same lifetime as its counterpart or will always outlive it.
This is because it doesn't have to be optional and the variable can be declared with let (weak must always be var).

Same-lifetime situations are very common (especially when the 2 objects have a parent-child relationship).
When the parent controls the child's lifetime with a strong reference and you can guarantee that no other objects know about the child, the child's back reference to its parent can always be unowned.

unowned has less overhead so accessing it will be slightly faster. (just for performance-critical code paths)

## Deciding between Structs and Classes

When designing a type, we have to think about whether ownership of a particular instance of this type has to be shared among different parts of our program, or if multiple intances can be used interchangeably as long as they represent the same value.
To share ownership of a particular instance, we have to use a class. Otherwise, we can use a struct.

Ex: URL is a struct. Quando definimos uma URL para uma variavel, ou quando enviamos como parametro de uma funcao, o valor é copiado.
Mas isso nao é um problema pq podemos considerar que as duas copias sao intercambiaveis. Elas representam a mesma URL.
O mesmo ocorre com outras structs como integers, Booleans and strings.

Por outro lado, vamos pegar uma UIView. Nao podemos dizer que duas instancias de UIView sao intercambiaveis.
Mesmo que suas propriedades sejam as mesmas, elas ainda representam objetos diferentes na tela em lugares diferentes da view hierarchy.
Como UIView é uma classe podemos passar uma referencia para uma instancia em particular em diferentes pontos do programa.
Um view em particular é referenciada pela sua superview, mas também é a superview de suas views filhas.
Alem disto podemos tambem adicionar outras referencias para uma view (ex: view controller). A mesma instancia pode ser manipulada por todas suas referencias e essas mudancas sao automaticamente refletidas para todas as referencias.

Podemos tambem ter classes com comportamento de imutabilidade (value semantics). Apesar de perdermos algumas otimizacoes em tempo de compilacao e teremos tambem o custo de operacoes de ARC.

Porem fica dificil usar uma struct para se obter o comportamento de reference que tem uma classe. 
Structs offer simplicity: no references, no lifecycle, no subtypes.
No worries about reference cycles, side effects, race conditions through shared references and inheritance rules and etc

Structs promise better performance, especially for small values.
If Int were a class, an array of Ints would take up a lot more memory to store the references (pointers) to the actual instances.
Looping over an reference array would be much slower. Because code would have to follow the additional level of indirection for each element and thus potentially be unable to make effective use of CPU caches, especially if the Int instances were allocated at wildly different locations in Memory

## Classes with Value Semantics 

We can write immutable classes that behave more like a value type and we can write structs that don't really behave like a value type - at least at first sight.

Class with value semantics:

* declare all properties with let, making them immutable
* final class - disallow subclassing

ex:

final class ScoreClass {
    let home: Int
    let guest: Int
    init(home: Int, guest: Int) {
        self.home = home
        self.guest = guest
    }
}

let score1 = ScoreClass(home: 0, guest: 0)
let score2 = score1

score1 and score2 variables still contain references to the same underlying ScoreClass instance.
But for all practical intents and purposes, we can use score1 and score2 as if they contained independent values, because the underlying instance is completely immutable anyway.

Ex: NSArray in Foundation
NSArray itself doesn't expose any mutating APIs, so its instances can essentially be used as if they were values.
The reality is somewhat more complicated, since NSArray has a mutable subclass NSMutableArray and we can't make assumptions that we're really dealing with an NSArray insance if we haven't created it ourselves.

## Structs with Reference Semantics

Let's extend ScoreStruct type to include a computed property: pretty. It provides a nicely formatted string for the current score

struct ScoreStruct {
    var home: Int
    var guest: Int
    let scoreFormatter: NumberFormatter // it is a class inherited from Formatter
    
    init(home: Int, guest: Int) {
        self.home = home
        self.guest = guest
        scoreFormatter = NumberFormatter()
        scoreFormatter.minimumIntegerDigits = 2
    }
    
    var pretty: String {
        let h = scoreFormatter.string(from: home as NSNumber)
        let g = scoreFormatter.string(from: guest as NSNumber)
        return "\(h) - \(g)"
    }
}

let score1 = ScoreStruct(home: 2, guest: 1)
score1.pretty // "02 - 01"

let score2 = score1
score2.scoreFormatter.minimumIntegerDigits = 3

score1.pretty // 002 - 001
ATENCAO: Although we made the change on score2, the output of score1.pretty has changed as well

The reason for it is that NumberFormatter is a class.

Technically ScoreStruct still has a value semantics: when you assign an instance to another variable or pass it as a function parameter, a copy of the entire value is made.
However, it depends what we consider to be the value. (Se considerarmos que o ponteiro, a referencia, é um valor que foi preservado, ScoreStruct continua com value semantics. Mas se considerarmos o conteudo de pretty nao.)

O que podemos fazer entao nesses casos:

1) Mudar o tipo para classe. O usuario entao nao esperará value semantics.
2) Tornar o number formatter um detalhe de implementacao privado que nao pode ser alterado. Essa nao é uma solucao perfeita pois podemos acidentalmente expor outros metodos publicos do tipo que consegue alterar o number formatter internamente.

ATENCAO:

We recommend being very careful about storing references within structs, since doing so will often result in unexpected behavior.
However, there are cases where storing a reference is intentional and exactly what you need, mostly as an implementation detail for performance optimizations.

## Copy-On-Write Optimizations

Values types requerem muitas operacoes de copia. O proprio compilador tenta otimizar evitando copies quando percebe que é seguro fazer assim.
Uma tecnica que o dev pode fazer é implementar o tipo usando a tecnica de copy-on-write.

Copy-on-write é importante principalmente em tipos que guardam muitos dados, como colecoes (Array, Dictionary, Set and String). 
Colecoes em Swift sao implementadas com copy-on-write.

O que é copy on write ? 
Copy on write significa compartilhar os valores entre as diversas variaveis e atrasar o maximo possivel a operacao da copia.
Ou seja, a copia em si ocorre apenas quando alguma instancia altera algum valor.

Exemplo:

var x = [1, 2, 3]
var y = x 

Por enquanto x e y estao compartilhando os mesmos dados. Nao foi ainda feita a criacao de um nova estrutura de dados em memoria pra y.
Internally,the array values in x and y contain a reference to the same memory buffer.
This buffer is where the actual elements of the array are stored.
However, the moment we mutate x or y, the array detects that it's sharing it's buffer with one or more other variables and makes a copy of the buffer before applying the mutation.
The potentially expensive copy of the elements only happens when it has to.

x.append(5)
y.removeLast()

x // [1, 2, 3, 5]
y // [1, 2]

Copy-on-write behavior is not something we get for free for our own types. 
We have to implement it ourselves, just as the standard library implements it for its collection types.

Implementing copying-on-write for a custom struct is only necessary in rare circustances.
Even if we define a struct that can contain a lot of data, we'll often use the built-in collection types to represent this data internally, and as a result we benefit from their copy-on-write optimizations.

### Copy-On-Write Tradeoffs

Copy-on-write structs rely on storing a reference internally, and the internal reference count has to be incremented for every copy of a struct that gets created.
Ou seja, quando implementamos copy-on-write a gente volta a ter o "problema" de ter um reference counting para otimizar a performance das escritas.

Incrementing and decrementing a reference count is a relatively slow operation compared to, say, copying a few bytes to another location on the stack because such an operation must be thread-safe and therefore incurs locking overhead. 

Since all the variable-size types from the standard library (arrays, dictionaries, sets and strings) rely on copy-on-write internally, all structs containing properties of these types also incur reference counting costs on each copy. One exception: small strings up to 15 utf-8 code units in size.

Ex: HTTP request 
Modeled with a struct vs modeled with a class
Class / reference type is less data to be copied than all fields of a HTTP request struct and only one reference count has to be updated.

### Implementing copy-on-write

How to use copy-on-write technique to combine the best of both worlds in a particular case: value semantics and the performance of using a class

See Johannes Weiss talk at dotSwift 2019 (www.youtube.com/watch?v=iLDldae64xE)

Let's start with an extremely simplified version of an HTTP request struct: 

struct HTTPRequest {
    var path: String
    var headers: [String: String]
    // other fields omitted...
}  

See CopyOnWrite.swift file

#### isKnownUniquelyReferenced function

Used to find out if a reference has only one owner
Returns true if no one else has a strong reference to the object
Uses an inout argument (that's the only way in Swift to refer to a variable in the context of a function argument. Se nao fosse inout, mas sim um argumento padrao, automaticamente a variavel seria copiada e ja nao teria so um "owner")
Não funciona para classes Objective-C  

It is thread-safe but you have to make sure the variable that is being passed in is not being accessed from another thread like all inout arguments in Swift.
isKnownUniquelyReferenced doesn't protect you against race conditions

example of a non safe code:

var numbers = [1, 2, 3]
queue1.async { numbers.append(4) }
queue2.async { numbers.append(5) } 

