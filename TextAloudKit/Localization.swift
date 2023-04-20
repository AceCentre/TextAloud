//
//  Locali.swift
//  TextAloud
//
//

import SwiftUI

public enum Localization: String {

    case play
    case stop
    case edit
    case cancel
    case pause
    case save
    case word
    case paragraph
    case sentence
    case all
    case offlineAlertMessage
    case offlineAlertTitle
    case selectVoices
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
    case help
    
    
    public var toString: LocalizedStringKey {
        LocalizedStringKey(self.rawValue)
    }
}
