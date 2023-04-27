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
    public var languageStr: String { code.getFullLocaleLanguageStr }
    public let voices: [Voice]
    
    public init(code: String, voices: [Voice]) {
        self.code = code
        self.voices = voices
    }
    
    public var sampleVoiceText: String{
        let code = String(code.prefix(2))
        return voiceSampleText[code] ?? ""
    }
}

