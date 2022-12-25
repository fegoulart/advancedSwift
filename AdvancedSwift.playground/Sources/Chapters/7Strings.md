# 7 STRINGS

## User perceived characters

Swift's string implementation is as Unicode-correct as possible.
String in Swift is a collection of Character values. Character is what a human reader of a text would perceive as a single character regardless of how many Unicode scalars it's composed of.
All standard Collection operations (ex: count, prefix(5)) work on the level of user-perceived characters.

String does not support random access: jumping to an arbitrary character is not an O(1) operation. It can't be - when characters have variable width, the string doesn't know where the nth character is stored without looking all the characters that come before it.

Swift's priority is to do the correct thing by default. Swift String provides views that let you operate directly on Unicode scalar or code units.

## Unicode

### ASCII strings

Sequence of integers between 0 and 127. Strings could be random access. No spare bit if stored in 8-bit byte.
Enough only for American English.
British English needs £

### ISO 8859

Extra bit to define 16 different encodings above the ASCII range. Part 1 (ISO 8859-1, aka Latin-1) covering several Western European languages and Part 5 covering Cyrillic alphabet.
Still limiting. If you want to write in Turkish about Ancient Greek you're out of luck. Should choose Part 7 (Latin/Greek) or Part 9 (Turkish).

### Variable-width encoding

When you run out of room with a fixed width encoding you have 2 choices: increase the size or switch to variable-width encoding.

### Unicode, Scalar, Code unit

Initially, unicode was defined as 2-byte fixed-width format, now called UCS-2.
But 2 bytes are not sufficient. 4 bytes would be horribly inefficient.

So today, Unicode is a variable-width format. Variable in 2 different senses:

* A single character (called extended grapheme cluster) consists of 1+ Unicode scalars
* A scalar is encoded by 1+ code units

### Code Point

Integer value which ranges from 0 to 0x10ffff (1.114.111) commonly written in hex notation with U+ prefix. ex: U+20AC (8364) is euro sign.
It is the basic building block of Unicode.
Every character that is part of Unicode is assigned a unique code point. (In 2019 only 138k of the 1.1mi were already used).

### Unicode scalars 

Almost, but not quite, the same as code points. 
They're all the code points except the 2048 surrogate code points in the range 0xD800 to 0xDFFF (used by UTF-16 to represent code points greater than 65535)
Represented in swift string literals as "\u{xxxx}" where xxxx represents hex digits.
The corresponding Swift type is Unicode.Scalar which is wrapped around a UInt32 value.
Ex: euro sign is "\u{20AC}"
(Unicode table)[https://unicode-table.com/en/blocks/]

### Code unit

The smallest entity in an encoding is called a code unit.
Unicode data (ex: sequence of scalars) can be encoded with different encodings (ex: UTF-8, UTF-16).
UTF-8 encoding has 8-bit wide code units and UTF-16 has 16-bit code units.

UTF-8 is backwardly compatible with 8-bit ASCII.

Code units are different from code points or scalars because a single scalar is often encoded with multiple code-units.
UTF-8 take one to four code units (1-4 byte represented as UInt8) to encode a single scalar.
UTF-16 takes one to two code units represented as UInt16 to encode a single scalar.

### Text segmentation

How scalars form grapheme clusters determine how text is segmented.
ex: quando teclamos o backspace queremos que o editor de texto apague exatamente um grapheme cluster independentemente se aquele "caracter" é composto de mais de um Unicode scalars. E cada scalar pode usar 1+ code units de representação na memória.

### Grapheme cluster

É representado pelo Swift pelo tipo Character.
Um Character codifica um numero variavel de scalars, desde que represente um único caracter para o usuário.

## Grapheme Clusters and Canonical Equivalence

### Combining Marks

"é" can be written in 2 different ways:

* U+0039: Latin small letter e with acute 
* e followed by U+0301: Plain letter e + acute accent

User has an expectation that 2 strings displayed as "résumé" would not only be equal to each other but also have a "length" of six characters. That is what Unicode specification describes as canonically equivalent.

let single = "Pok\u{00E9}mon" // Pokémon
let double = "Poke\u{0301|mon" // Pokémon

single.count // 7
double.count // 7

single == double // true

single.unicodeScalars.count // 7
double.unicodeScalars.count // 8

### Emoji

One emoji in Swift is counted as 1 character long (Java or C# would say is 2).
let oneEmoji = "😂" // U+1F602
oneEmoji.count = 1

### unicodeScalars view

to inspect the scalars that the string is composed of.

let flags = "🇧🇷🇦🇺"
flags.count // 2

flags.unicodeScalars.map {
    "U+\(String($0.value, radix: 16, uppercase: true))"
}

### ZWJ (Zero-width joiner)

Invisible character U+200D used to combined different emojis into a single one.

Man + ZWJ + Woman + ZWJ + girl + ZWJ + boy = Family

Rendering these sequences into a single glyph is the task of the operating system. When no glyph is available for a syntactically valid sequence, the text-rendering system falls back to rendering each component as a separate glyph.

## Strings and collections

PAREI AQUI NA PAGINA 258

## Functions

* joined - return lines.joined(separator: "\n")
* split - self.split(omittingEmptySubsequences: false) { character in // return true if separator }
* 

## Strings and Foundation (NSString)

## Ranges of Characters

Character doesn't comnform to the Strideble protocol, which is a requirement for ranges to become countable and thus collections.
All you can do with a range of characters is compare other characters against it (ie: check wehter a character is inside the range or not):

let lowercaseLetters = ("a" as Character)..."z"
lowercaseLetters.contains("A") // false
lowercaseLetters.contains("é") // false

## CharacterSet 

Na verdade é um UnicodeScalarSet. It is not at all compatible with the Character type.

let favoriteEmoji = CharacterSet("🧑‍🚒".unicodeScalars)
