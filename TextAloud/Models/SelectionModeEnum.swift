//
//  SelectionModeEnum.swift
//  TextAloud
//
//

import Foundation


enum SelectionEnum: String, CaseIterable{
    
    case word, paragraph, sentence
    
    
    var getRangeForIndex: ( _ index: Int, _ text: String) -> NSRange{
        
        switch self {
        case .word: return Helpers.getWordRangeAtIndex(_:_:)
        case .paragraph: return Helpers.getParagraphRangeForLocation(_:_:)
        case .sentence: return Helpers.getSentenceRangeForLocation(_:_:)
        }
        
    }
    
}
