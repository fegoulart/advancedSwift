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


## Dictionaries

* Is a Sequence
* Unique keys
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
* mapVlues // keep Dictionary structure intact and only transform its values
