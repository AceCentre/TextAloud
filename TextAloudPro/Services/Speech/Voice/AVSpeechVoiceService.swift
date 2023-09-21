//
//  AVSpeechVoiceService.swift
//  TextAloud
//
//

import Foundation
import Combine
import AVFAudio
import TextAloudKit

class AVSpeechVoiceService: VoiceServiceProtocol{
    
    @Published var languages = [LanguageGroup]()
    
    
    init() {
        fetchVoices()
    }
    
    func fetchVoices() {
        if #available(iOS 17.0, *) {
            AVSpeechSynthesizer.requestPersonalVoiceAuthorization() { status in
                let aVFvoices = AVSpeechSynthesisVoice.speechVoices()
                let uniquedLang = aVFvoices.map({$0.language}).uniqued()

                
                
                self.languages = uniquedLang.map({ code -> LanguageGroup in
                    let voice = aVFvoices
                        .filter({$0.language == code})
                        .filter { $0.voiceTraits.contains(.isPersonalVoice) == false } // Does not contain
                        .map({OldVoice(id: $0.identifier, name: $0.name, languageCode: $0.language, gender: ($0.gender == .male ? .male : .female), type: .apple)})
                    
                    return  .init(code: code, voices: voice)
                })
                
                let personalVoices = aVFvoices.filter { $0.voiceTraits.contains(.isPersonalVoice) }
                
                if(personalVoices.count > 0) {
                    let voices: [OldVoice] = personalVoices
                        .map({OldVoice(id: $0.identifier, name: $0.name, languageCode: $0.language, gender: .personal, type: .apple)})
                    
                    self.languages.insert(.init(code: "en", languageStr: "Personal Voice", voices: voices), at:0)
                }
            }
        } else {
            let aVFvoices = AVSpeechSynthesisVoice.speechVoices()
            let uniquedLang = aVFvoices.map({$0.language}).uniqued()

            self.languages = uniquedLang.map({ code -> LanguageGroup in
                let voice = aVFvoices.filter({$0.language == code}).map({OldVoice(id: $0.identifier, name: $0.name, languageCode: $0.language, gender: ($0.gender == .male ? .male : .female), type: .apple)})
                return  .init(code: code, voices: voice)
            })
        }
    }
    
    
    var defaultVoiceModel: OldVoice{
        let currentLocaleCode = Locale.current.collatorIdentifier ?? "en-US"
        return getVoicesModelsForLanguage(currentLocaleCode).first ??
            .init(id: "non", name: "Apple", languageCode: "en-US", gender: .female, type: .apple)
    }
    
    func getVoicesModelsForLanguage(_ language: String) -> [OldVoice] {
        languages.first(where: {$0.code == language})?.voices ?? []
    }
    
    func getLanguagesForCode(_ code: String) -> [LanguageGroup] {
        return languages.filter({$0.code == code})
    }
    
    func getVoicesModelForId(_ id: String) -> OldVoice {
        languages.map({$0.voices}).flatMap({$0}).first(where: {$0.id == id}) ?? defaultVoiceModel
    }
    
}
