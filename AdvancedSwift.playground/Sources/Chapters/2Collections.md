# 2 BUILT-IN COLLECTIONS

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



| Values | Variables | References | Constants |
| ----------- | ----------- |  ----------- |  ----------- |
| Immutable and forever. It never changes |  | It's a pointer. As two references 
