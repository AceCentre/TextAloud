//
//  VoiceModel.swift
//  TextAloud
//
//

import Foundation

struct VoiceModel: Identifiable, Hashable{
    
    let id: String
    let name: String
    let languageCode: String
    var languageStr: String { languageCode.getFullLocaleLanguageStr }
    let type: VoiceType
    
    var representableName: String{
        switch type{
        case .apple: return name
        case .azure: return String(name.dropFirst(6)).titlecased
        }
    }
}

extension VoiceModel{
    enum VoiceType{
        case apple, azure
    }
}





