//
//  LanguageGroup.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 27/04/2023.
//

import Foundation

public struct LanguageGroup: Identifiable{
    public var id: String{ code }
    public let code: String
    public var languageStr: String
    public let voices: [OldVoice]
    
    public init(code: String, voices: [OldVoice]) {
        self.code = code
        self.voices = voices
        self.languageStr = code.getFullLocaleLanguageStr
    }
    
    public init(code: String, languageStr: String, voices: [OldVoice]) {
        self.code = code
        self.voices = voices
        self.languageStr = languageStr
    }
    
    public var sampleVoiceText: String{
        let code = String(code.prefix(2))
        return voiceSampleText[code] ?? ""
    }
}

