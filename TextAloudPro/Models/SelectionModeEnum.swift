//
//  SelectionModeEnum.swift
//  TextAloud
//
//

import SwiftUI
import TextAloudKit

enum SelectionEnum: Int, CaseIterable{
    
    case all, word, paragraph, sentence
    
    
    func getRangeForIndex( _ index: Int, _ text: String) -> NSRange{
        
        switch self {
        case .word: return Helpers.getRangeTextForIndex(index: index, with: .byWords, text: text)
        case .paragraph: return Helpers.getRangeTextForIndex(index: index, with: .byParagraphs, text: text)
        case .sentence: return Helpers.getRangeTextForIndex(index: index, with: .bySentences, text: text)
        case .all: return Helpers.getAllTextRange(index, text)
        }
        
    }
    
    
    var locale: LocalizedStringKey{
        switch self{
        case .word: return Localization.word.toString
        case .paragraph: return Localization.paragraph.toString
        case .sentence: return Localization.sentence.toString
        case .all: return Localization.all.toString
        }
    }
    
    var keyboardShortcutValue: KeyEquivalent {
        return KeyEquivalent(Character(String(self.rawValue)))
    }
    
    var playMode: PlayMode{
        switch self {
        case .all: return .all
        default: return .selecting
        }
    }
}
