//
//  SpeechVoiceService.swift
//  TextAloud
//
//

import Foundation
import AVFAudio

class SpeechVoiceService {
    
    static let share = SpeechVoiceService()
    
    private var voices: [AVSpeechSynthesisVoice]
    
    private init() {
        voices = AVSpeechSynthesisVoice.speechVoices()
    }
    
    var uniquedLanguagesCodes: [String]{
        voices.map({$0.language}).uniqued()
    }
   
    func getLanguageForId(_ identifier: String) -> String?{
        voices.first(where: {$0.identifier == identifier})?.language.getFullLocaleLanguageStr
    }
    
    var defaultVoiceModel: VoiceModel{
        let currentLocaleCode = Locale.current.collatorIdentifier ?? "en-US"
        return getVoicesModelForLanguage(currentLocaleCode).first ??
            .init(id: "", name: "", languageCode: "en-US")
    }
    
    func getVoicesModelForLanguage(_ language: String) -> [VoiceModel] {
        let filtered = voices.filter({$0.language == language})
        return filtered.map({.init(id: $0.identifier, name: $0.name, languageCode: $0.language)})
    }
    
    func getVoicesModelForId(_ id: String) -> VoiceModel? {
        voices.first(where: {$0.identifier == id}).map({.init(id: $0.identifier, name: $0.name, languageCode: $0.language)})
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




