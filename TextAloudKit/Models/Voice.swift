//
//  Voice.swift
//  TextAloudKit
//
//  Created by Gavin Henderson on 27/04/2023.
//

import Foundation

public struct Voice: Identifiable, Hashable, Codable{
    
    public let id: String
    let name: String
    public let languageCode: String
    public var languageStr: String { languageCode.getFullLocaleLanguageStr }
    public let gender: Gender
    public let type: VoiceProvider
    
    public init(id: String, name: String, languageCode: String, gender: Gender, type: VoiceProvider) {
        self.id = id
        self.name = name
        self.languageCode = languageCode
        self.gender = gender
        self.type = type
    }
    
    public var representableName: String{
        switch type{
        case .apple: return name
        case .azure: return String(name.dropFirst(6)).titlecased
        }
    }
    
    public enum Gender: Int, Codable{
        case male, female
        
        public var toStr: String{
            switch self{
            case .male: return "Male"
            case .female: return "Female"
            }
        }
    }
}

public enum VoiceProvider: Int, CaseIterable, Equatable, Codable{
    case apple, azure
    
    public var title: String{
        switch self{
            
        case .apple: return "Offline"
        case .azure: return "Online"
        }
    }
}
