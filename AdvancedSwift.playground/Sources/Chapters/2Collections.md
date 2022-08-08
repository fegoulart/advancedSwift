# 2 BUILT-IN COLLECTIONS

## Collections vs Sequences

Collection is a protocol that inherits from Sequence
Collection is a SequenceType that can be accessed via subscript and defines a startIndex and endIndex. 
Collection is a step beyond a sequence; individual elements of a collection can be accessed multiple times

## COW - Copy on right

All collection types in the Swift standard library are implemented using a technique called copy-on-write

## ARRAYS

### Value semantics

var x = [1,2,3]
var y = x 
y.append(4)
x mantém [1,2,3]

### Ordered

Respeita a ordem de inserção e remoção

### Let / Immutability

  Uso de let: se o conteúdo for value type mantém total imutabilidade
  Contrário tb é verdade: uso de var garante a mutabilidade

### Working with arrays

Swift wants to discourage you from doing index math (ex: array[0])

* for x in array
* for x in array.dropFirst()
* for x in array.dropLast(5)
* for (num, element) in array.enumerated()
* if let idx = array.firstIndex { someMatchingLogic($0) } // finds location of a specific element
* array.map { someTransformation($0) }
* array.filter { someCriteria($0) }
* array.first / array.last - returns optional

### Transforming arrays

* map / flatMap
* filter
* allSatisfy - test all elements for a condition
* reduce - fold the element into an aggregate value
* forEach
* sort(by:), sorted(by:), lexicographicallyPrecedes(_:by:), partition(by:) - reorder
* firstIndex(where:), lastIndex(where:), first(where:), last(where:), contains(where:)
* min(by:), max(by:)
* elementsEqual(_:by:), starts(with:by:) - compares elements to another array
* split(whereSeparator:)
* prefix(while:) - take elements from the start as long as the condition holds true
* drop(while:) - drops element until condition ceases to be true, and then return the rest (inverse prefix return)
* removeAll(where:)
* zip: Creates a sequence of pairs built out of two underlying sequences

## Sorting

Element's don't have to be comparable or equatable, and you don't have to compare the entire element - you can sort an array of people by their ages:
people.sort { $0.age < $1.age }

## Custom tasks

Example: splitting an array into groups of adjacent equal elements

    extension Array {
        func split(where condition:(Element, Element) -> Bool) -> [[Element]] {
            var result:[[Element]] = self.isEmpty ? [] : [[self[0]]]
            for (previous, current) in zip(self, self.dropFirst()) {
                if condition(previous.current) {
                    result.append([current])
                } else {
                    result[result.endIndex - 1].append(current)
                }
            }
            return result
        }
    }
    
## Mutation and closures

We don't recommend use map to perform side effects
Map is for transforming the array and should not hide side-effects.

## Filter

Filter cria um novo array. Por isso, use apenas se o resultado do filter for utilizado.
Map + filter é algo muito poderoso. 

Prefira sempre contains do que filter se o objetivo for apenas saber se existe.

## Reduce

reduce(into:) é muito mais eficiente pois usa o parametro como inout e não precisa recriar arrays
 
 ## Flatenning Map

 flatMap combines mapping and flattening  (.joined())
 Flattening transform array of arrays in a single array

## forEach

Unlike map it returns nothing. It is perfect for side effects.
Cuidado com return dentro de um forEach.
The return inside the forEach closure doesn't return out of the outer function. It only returns from the closure itself.

Exemplo:

    (1..<10).forEach { number in 
        print(number)
        if number > 2 { return } // Não vai funcionar como esperado
    }

## Array slices

Não cria um novo array. Retorna uma "visão" do array original.
Cuidado com indices, pois ele nao reseta os indices. Mas usa os indices do array original.
Recomendado: nao usar 0 mas sim .startIndex (e tb .endIndex)
Has the same methods Array has: conforms to same protocols (ex: Collection)
Warning: en
EndIndex is the position one greater than the last valid subscript argument.

## Dictionaries

* Is a Sequence
* Unique keys - KEY MUST BE HASHABLE
* O(1) to retrieve
* not ordered
* Immutability: let 
* Mutability: var

Always return an optional
Doesn't crash. Just returns nil when not found.
Removing a key: 
    1) Assign nil
    2) Pop it (removeValue(forKey: ))
    3) Update value: (updateValue(_ forKey: )) // returns previous value

Useful methods:

* merge(_:uniquingKeysWith:)
* init (_ keysAndValues: S, uniquingKeysWith:) // Creates a new dictionary from the key-value pairs in the given sequence, using a combining closure to determine the value for any duplicate keys.
* mapValues // keep Dictionary structure intact and only transform its values

### Hashable

All the basic data types in standard library already are hashables (ex: string, integer, floating, bool)
Arrays, sets and optionals and other become hashable if ther elements are hashable
Structs and enums - Swift automatically synthesize the Hashable conformance as long they are composed of hashable types

For classes you first need to implement Equatable and then Hashable

### Key and Value Semantics

Take extra care about using key that doesn't have value semantics.
If you mutate an object after using it as a dictionary key in a way that changes its hash value and/or equality you won't be able to find it again in the dictionary.

### Random seeding

Standard library hash function uses a random seed as one of its inputs
Ex: the hash value of "abc" will be different on each program execution

Random seeding is a security measure to protect against targeted hash-flooding denial of service attacks

Since Dictionary and Set iterate over their elements in the order they are stored in the hash table, and since this order is determined by the hash values, this means the same code will produce different iteration orders on each launch.

If deterministic hashing is needed (e.g. for tests) you can disable random seeding by setting the environment variable SWIFT_DETERMINISTIC_HASHING=1 (DON'T DO IT IN PRODUCTION)

## Sets

* It is like a dictionary that only store keys and no values
* Implemented with a hash table
* Check if an element exists is O(1) - Very efficient membership check
* Conforms to ExpressibleByArraysLiteral - let naturals: Set = [ 1, 2, 3, 4, 5]

## Set Algebra

SetAlgebra is a protocol
Set significa conjunto. E as operações com conjuntos da Algebra são disponibilizadas aqui.

*  .subtracting
*  .intersection
*  .formUnion - form prefix: mutating method

Standard library types:

* Set
* OptionSet

Foundation types:

* IndexSet - set of positive integer numbers. More storage efficient than Set<Int>. Is a collection
* CharacterSet - set of Unicode code points (Unicode scalars). It is NOT a collection. Useful to check if a string contains only characters from a specific character subset (ex: alphanumerics, decimalDigits)


## Ranges

Operators:

* ..< half-open ranges (cannot contain the maximum value - ex: 5..<Int.max is an erro)
* ... closed ranges (cannot represent an empty interval - ex: 5...5 is an error)
* 0... prefix (from zero)
* ..<Character("z") postfix (up to Z)

5 different concrete types that represent ranges
2 most essential (both with Bound generic parameter - Bound must be Comparable):

* Range (..<)
* ClosedRange (...) - ex: lowercaseLetters

### Countable Ranges

Range conforms to Collection ONLY if:

* Element conforms to Strideable (you can jump from one element to another by adding an offset)
* Stride steps are integers

In other words: range must be countable in order for it to be iterated over. 
Ex of countable ranges: integer, pointer

Floating point is not a countable range. If we need to iterate over consecutive floating-point values, you can use the stride(from:to:by:) and stride(from:through:by:) functions to create such sequences.

CountableRange and CountableClosedRange are just aliases

### Partial Ranges

Misses one of their bounds

3 different kinds:

* PartialRangeFrom<> - let fromA: PartialRangeFrom<Character> = Character("a")...
* PartialRangeThrough - let throughZ: PartialRangeThrough<Character> = ...Character("z")
* PartialRangeUpTo - let upTo10: PartialRangeUpTo<Int> = ..<10

CountablePartialRangeFrom and PartialRangeFrom are just aliases

### Range Expressions

All range types conform to RangeExpression protocol: 

* contains(_ element:)
* relative(to collection:) // Computes a fully specified Range for us

Collection protocol takes a RangeExpression rather than the concrete Range type.

If possible, try copying the standard library's approach and make your own functions take a Range Expression rather than a concrete range type.
It's not always possible because the protocol doesn't give you access to the range's bounds unless you're in the context of a collection, but if it is, you'll give consumers of your APIs much more freedom to pass in any kind of range expression they like.