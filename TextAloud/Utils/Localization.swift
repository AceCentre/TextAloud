//
//  Locali.swift
//  TextAloud
//
//

import Foundation

enum Localization: String {

    case play
    case stop
    case edit
    case pause
    case save
    case word
    case paragraph
    case sentence
    case settings
    case aboutTextAloud
    case customization
    case aboutCustomization
    case textWillLook
    case simpleText
    case pickSelection
    case pickHighlight
    case fontSize
    case pickVoice
    
    
    var toString: String {
        NSLocalizedString(self.rawValue, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
