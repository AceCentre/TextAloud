//
//  SelectionModeEnum.swift
//  TextAloud
//
//

import SwiftUI

/**
 TextSelection functions are used to get the index of the next chunk of text. You can get by `all`, `word`, `paragraph` or `sentence`
 */
class TextSelection {
    static func getAllTextRange(_ location: Int, _ text: String) -> NSRange{
        .init(location: 0, length: text.count)
    }

    static func getRangeTextForIndex(index: Int, with options: String.EnumerationOptions, text: String) -> NSRange{
        var ranges = [NSRange]()
        let fullTextRange = text.startIndex ..< text.endIndex
        
        // If we have overshot with our recursion bail back to the start
        if index > text.count {
            return getRangeTextForIndex(index: 0, with: options, text: text)
        }
        
        // Put all the ranges into a list
        text.enumerateSubstrings(in: fullTextRange, options: options) { _, substringRange, enclosingRange, _ in
            ranges.append(NSRange(substringRange, in: text))
        }
        

        // Find the matching range or move to the next stop
        if let foundRange = ranges.first(where: {$0.contains(index)}) {
            
            // Get the text in the range that we have found.
            // If its just an empty string then just recurse to the next range.
            let textThatWillPlay = String(text.substring(with: foundRange) ?? "default")
            let trimmed = textThatWillPlay.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.count == 0 {
                return getRangeTextForIndex(index: index + 1, with: options, text: text)
            }
            
            return foundRange
        } else {
            return getRangeTextForIndex(index: index + 1, with: options, text: text)
        }
    }
}



public enum TextSelectionEnum: Int, CaseIterable{
    
    case all, word, paragraph, sentence
    
    
    public func getRangeForIndex( _ index: Int, _ text: String) -> NSRange{
        
        switch self {
        case .word: return TextSelection.getRangeTextForIndex(index: index, with: .byWords, text: text)
        case .paragraph: return TextSelection.getRangeTextForIndex(index: index, with: .byParagraphs, text: text)
        case .sentence: return TextSelection.getRangeTextForIndex(index: index, with: .bySentences, text: text)
        case .all: return TextSelection.getAllTextRange(index, text)
        }
        
    }
    
    
    public var locale: LocalizedStringKey{
        switch self{
        case .word: return Localization.word.toString
        case .paragraph: return Localization.paragraph.toString
        case .sentence: return Localization.sentence.toString
        case .all: return Localization.all.toString
        }
    }
    
    public var keyboardShortcutValue: KeyEquivalent {
        return KeyEquivalent(Character(String(self.rawValue)))
    }
}
