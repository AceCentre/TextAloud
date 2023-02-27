//
//  SelectionModeEnum.swift
//  TextAloud
//
//

import SwiftUI


enum SelectionEnum: Int, CaseIterable{
    
    case all, word, paragraph, sentence
    
    
    var getRangeForIndex: ( _ index: Int, _ text: String) -> NSRange{
        
        switch self {
        case .word: return Helpers.getWordRangeAtIndex(_:_:)
        case .paragraph: return Helpers.getParagraphRangeForLocation(_:_:)
        case .sentence: return Helpers.getSentenceRangeForLocation(_:_:)
        case .all: return Helpers.getAllTextRange(_:_:)
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
    
    var keyboardShortcutValue: KeyEquivalent{
        .init(Character(String(self.rawValue)))
    }
    
    var playMode: PlayMode{
        switch self {
        case .all: return .all
        default: return .selecting
        }
    }
}
