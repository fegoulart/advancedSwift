# 7 STRINGS

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
