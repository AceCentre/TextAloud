//
//  StringExtentions.swift
//  TextAloud
//
//  Created by Will Wade, Daniil Balakiriev  on 31.10.2022.
//

import Foundation


func isInCharacterSer(_ input: String, _ set: CharacterSet) -> Bool {
    return input.rangeOfCharacter(from: set) != nil
}

func isEndOfSentence(_ input: String) -> Bool {
    return input == "." || input == "!" || input == "?"
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    var byWordsAndRanges: [(String, Range<String.Index>)] {
        var words: [(String, Range<String.Index>)] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { word, range, _, _ in
            words.append((word!, range))
        }
        return words
    }
}
