//
//  VoiceModel.swift
//  TextAloud
//
//

import Foundation

struct VoiceModel: Identifiable, Hashable, Codable{
    
    let id: String
    let name: String
    let languageCode: String
    var languageStr: String { languageCode.getFullLocaleLanguageStr }
    let gender: Gender
    let type: VoiceType
    
    var representableName: String{
        switch type{
        case .apple: return name
        case .azure: return String(name.dropFirst(6)).titlecased
        }
    }
}

extension VoiceModel {
    
    enum VoiceType: Codable{
        case apple, azure
    }
    
    enum Gender: Int, Codable{
        case male, female
        
        var toStr: String{
            switch self{
            case .male: return "Male"
            case .female: return "Female"
            }
        }
    }
}

struct LanguageModel: Identifiable{
    var id: String{ code }
    let code: String
    var languageStr: String { code.getFullLocaleLanguageStr }
    let voices: [VoiceModel]
    
    
    var simpleVoiceText: String{
        let code = String(code.prefix(2))
        return voicesSimpleTexts[code] ?? ""
    }
}

