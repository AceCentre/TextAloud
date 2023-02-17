//
//  SpeechVoiceService.swift
//  TextAloud
//
//

import SwiftUI
import AVFAudio
import MicrosoftCognitiveServicesSpeech

class SpeechVoiceService {
    
    static let share = SpeechVoiceService()
    
    @AppStorage("isAzureSpeech") var isAzureSpeech: Bool = false
    let azureSpeech = AzureSpeech.share
    let defaultAzureVoiceId = "en-US-JennyNeural"
    
    private var aVFvoices: [AVSpeechSynthesisVoice]
    private var azureVoices: [SPXVoiceInfo]
    
    private init() {
        aVFvoices = AVSpeechSynthesisVoice.speechVoices()
        azureVoices = azureSpeech.getAllVoices() ?? []
    }
    
    var uniquedLanguagesCodes: [String]{
        
        return isAzureSpeech ? azureVoices.map({$0.locale}).uniqued() :
        
        aVFvoices.map({$0.language}).uniqued()
    }
    
    
    var defaultVoiceModel: VoiceModel{
        let currentLocaleCode = Locale.current.collatorIdentifier ?? "en-US"
        return getVoicesModelForLanguage(currentLocaleCode).first ??
            .init(id: "", name: "", languageCode: "en-US")
    }
    
    func getVoicesModelForLanguage(_ language: String) -> [VoiceModel] {
        
        if isAzureSpeech{
            let filtered = azureVoices.filter({$0.locale == language})
            return filtered.map({.init(id: $0.shortName, name: $0.shortName, languageCode: $0.locale)})
        }else{
            let filtered = aVFvoices.filter({$0.language == language})
            return filtered.map({.init(id: $0.identifier, name: $0.name, languageCode: $0.language)})
        }
    }
    
    func getVoicesModelForId(_ id: String) -> VoiceModel? {
        
        if isAzureSpeech{
          return azureVoices.first(where: {$0.shortName == id}).map({.init(id: $0.shortName, name: $0.shortName, languageCode: $0.locale)})
        }else{
            return aVFvoices.first(where: {$0.identifier == id}).map({.init(id: $0.identifier, name: $0.name, languageCode: $0.language)})
        }
    }
}


struct VoiceModel: Identifiable, Hashable{
    let id: String
    let name: String
    let languageCode: String
    var languageStr: String { languageCode.getFullLocaleLanguageStr }
}



extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

extension String {
    
    
    var getFullLocaleLanguageStr: String{
        let locale: Locale = .current
        
        guard let countru = locale.localizedString(forLanguageCode: self) else {
            return "None"
        }
        
        guard let region = locale.localizedString(forRegionCode: String(self.suffix(2))) else{
            
            return countru
        }
        return "\(countru) (\(region))"
    }
}




