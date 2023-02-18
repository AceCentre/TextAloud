//
//  Locali.swift
//  TextAloud
//
//

import SwiftUI

enum Localization: String {

    case play
    case stop
    case edit
    case cancel
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
    
    
    var toString: LocalizedStringKey {
        LocalizedStringKey(self.rawValue)
    }
}
