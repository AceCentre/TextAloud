//
//  Helpers.swift
//  TextAloud
//
//  Created by Богдан Зыков on 14.02.2023.
//

import Foundation


final class Helpers{
    
    
    static func getWordRangeAtIndex(_ index: Int, _ text: String) -> NSRange {
        var endIndex = 0, startIndex = 0
        let textLength = text.length
        if index == textLength{
            endIndex = textLength
            for i in (0...index).reversed() {
                if isInCharacterSer(text[i], CharacterSet.whitespacesAndNewlines) || i == 0 {
                    startIndex = i
                    break
                }
            }
        } else if index == 0 {
            startIndex = 0
            for i in 0...textLength {
                if isInCharacterSer(text[i], CharacterSet.whitespacesAndNewlines) || i == text.length {
                    endIndex = i
                    break
                }
            }
        } else {
            for i in index...textLength {
                if isInCharacterSer(text[i], CharacterSet.whitespacesAndNewlines) || i == textLength {
                    endIndex = i
                    break
                }
            }
            for i in (0...index-1).reversed() {
                if isInCharacterSer(text[i], CharacterSet.whitespacesAndNewlines) || i == 0 {
                    startIndex = i
                    break
                }
            }
        }
        return NSRange(location: startIndex, length: endIndex - startIndex)
    }
    
    
    
   static func getSentenceRangeForLocation(_ currentLocation: Int, _ text: String) -> NSRange {
       
        var startIndex = 0, endIndex = 0
        let textLength = text.length
        if currentLocation == textLength && currentLocation - 2 >= 0 {
            endIndex = textLength
            for i in (0...(currentLocation - 2)).reversed() {
                if isEndOfSentence(text[i]) || i == 0 {
                    startIndex = i == 0 ? 0 : i + 1
                    break
                }
            }
        } else if currentLocation == 0 {
            startIndex = 0
            for i in 0...textLength - 1 {
                if isEndOfSentence(text[i]) || i == textLength - 1 {
                    endIndex = i + 1
                    break
                }
            }
        } else {
            for i in currentLocation...textLength - 1 {
                if isEndOfSentence(text[i]) || i == textLength - 1 || isInCharacterSer(text[i], CharacterSet.newlines) {
                    endIndex = i + 1
                    break
                }
            }
            for i in (0...currentLocation-1).reversed() {
                if isEndOfSentence(text[i]) || i == 0 || isInCharacterSer(text[i], CharacterSet.newlines){
                    startIndex = i == 0 ? 0 : i + 1
                    break
                }
            }
        }
        return NSRange(location: startIndex, length: endIndex - startIndex)
    }
    
    
   static func getParagraphRangeForLocation(_ currentLocation: Int, _ text: String) -> NSRange {
        var startIndex = 0, endIndex = 0
        let textLength = text.length
        if currentLocation == textLength && currentLocation - 1 >= 0 {
            endIndex = textLength
            for i in (0...(currentLocation - 1)).reversed() {
                if isInCharacterSer(text[i], CharacterSet.newlines) || i == 0 {
                    startIndex = i == 0 ? 0 : i + 1
                    break
                }
            }
        } else if currentLocation == 0 {
            startIndex = 0
            for i in 0...currentLocation {
                if isInCharacterSer(text[i], CharacterSet.newlines) || i == textLength {
                    endIndex = i
                    break
                }
            }
        } else {
            for i in currentLocation...textLength {
                if isInCharacterSer(text[i], CharacterSet.newlines) || i == textLength {
                    endIndex = i
                    break
                }
            }
            for i in (0...currentLocation - 1).reversed() {
                if isInCharacterSer(text[i], CharacterSet.newlines) || i == 0 {
                    startIndex = i == 0 ? 0 : i + 1
                    break
                }
            }
        }
        return NSRange(location: startIndex, length: endIndex - startIndex)
    }
    
    
   static func isInCharacterSer(_ input: String, _ set: CharacterSet) -> Bool {
        return input.rangeOfCharacter(from: set) != nil
    }

  static func isEndOfSentence(_ input: String) -> Bool {
        return input == "." || input == "!" || input == "?"
    }
    
}
