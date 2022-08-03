# INTRODUCTION

Keywords  **@objc** and **dynamic** allow use of selectors and runtime dynamism (dynamic dispatch) as in objective-c

Arrays in swift are not covariant

Static vs dynamic dispatch (witnesse table and message dispatch)

Swift is referenced counted and executes a class's deinit deterministically

## Values vs variables vs references vs constants

| Values | Variables | References | Constants |
| ----------- | ----------- |  ----------- |  ----------- |
| Immutable and forever. It never changes |  | It's a pointer. As two references can refer to the same location, the value stored at that location can be mutated from 2 different parts of the program at once | When a constant receives a value, it can never be assigned a new value |
| var x = [1, 2] is a variable named x that holds a value| | Reference types have identity. We can check by === operator (pointer equality / reference equality) checks if two variables are referring to the exact same object | When a constant receives a reference it cannot reference something else, but it doesn't mean that the object it refers to cannot be changed |
| x = [1, 2, 3] We are mutating the variable. x receives a new value | | We don't need to do any explicit dereferencing | |
| structs, enums | | classes, pointers (withUnsafeMutablePointer), functions | |
| Have value semantics: perform deep copy (eagerly or lazily) | | final classes have value semantics | |

## Value Semantics - Shallow Copy - Copy on Write

|  |  | |
| ----------- | ----------- | ----------- |
| Value Semantics | Perform deep copy (eagerly or lazily) | all value types and some reference types (ex: final classes) |
| Shallow Copy | When a value type (struct) contains reference types, the referenced objects won't automatically get copied upon assigning the struct to a new variable. Only the references themselves get copied  | 
| Copy on write | Behavior that doesn't come for free. Extra steps to perform a deep copy of the class instance whenever the Data struct is mutated | Collections wraps reference types and use COW to efficiently provide value semantics. Ex: Swift array only has value semantics if its elements have value semantics. |

## High order functions

Functions that take other functions as arguments (ex: map )

## Closing over variables / Closures / Closure expression

**Closing over variables** is a behavior of capturing and not destroying local variables even if the local scope ends.
Functions that have closing over behavior (can hold state through local scope and local variables) are called **closures**

**Closure expression** is when you declare a function only with a shorthand { } syntax. WARNING: closure expression is different from closure. Closure can be a function declared with func keyword.

## Methods vs Free Functions

**Methods** are functions inside a class or protocol

## Static vs Dynamic Dispatch

|  |  | |
| ----------- | ----------- | ----------- |
| Static | Function that will be called is known at compile time. Compiler can inline the function, so boost performance. | Free functions and struct methods |
| Dynamic | Compiler doesn't necessary know which function to run at compile time. Done via vtables, selectors or objc_msgSend | |

## Polymorphism

Ways of getting polymorphism:

* Subtyping and method overriding
* Function overloading
* Generics

## Swift Style Guide

[Swift Api Design Guidelines](https://swift.org/documentation/api-design-guidelines/)

* Default to structs unless you actually need a class-only feature or reference semantics
* Mark classes as final unless you've explicitly designed them to be inheritable. Public (not open) allows to use inheritance internally but not subclassing for external clients.
* Use trailing closure syntax (and not as a function parameter), except when that closure is immediately followed by another opening brace
* Favor immutable variables. Default to let unless you know you need mutation.
* Leave off self when you don't need it 
* Instead of writing a free function, write an extension on a type or protocol.