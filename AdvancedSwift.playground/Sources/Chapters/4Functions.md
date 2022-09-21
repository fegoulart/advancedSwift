# 4 OPTIONALS

## THREE-LEGGED STOOL

1. Functions can be assigned to variables and passed in and out of other functions as arguments, just as an Int or a String can be
2. Functions can capture variables that exist outside of their local scope
3. There are two ways of creating functions:
* func keyword
* closure expressions:  { }

## FIRST-CLASS OBJECTS

É o conceito mais importante a se entender em programação funcional:
É basicamente o item 1 acima.

### Exemplo 1

func printIt(i: Int) {
    print("You passed \(i).")
}

let funVar = printIt

funVar(2) // You passed 2.

### Exemplo 2

func useFunction(function: (Int) -> ()) {
    function(3)
}

useFunction(function: printIt) // You passed 3.
useFunction(function: funVar) // You passed 3.

### Exemplo 3

func returnFunc() -> (Int) -> String {
    func innerFunc(i: Int) -> String {
        return "You passed \(i)."
    }
    return innerFunc
}

let myFunc = returnFunc()
myFunc(3) // You passed 3.

## Functions can capture values that exist outside of their local scope

Variables referenced by functions are captured and stick around. (Are not destroyed).

### Exemplo 1

func counterFunc() -> (Int) -> String {
    var counter = 0
    func innerFunc(i: Int) -> String {
        counter += i
        return "Running total: \(counter)"
    }
    return innerFunc
}


## High-Order Functions

Function that takes functions as argument and apply them in useful ways

### Closure != Closure Expression 


